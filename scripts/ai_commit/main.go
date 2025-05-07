package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

const (
	ENDPOINT = "http://192.168.68.114:8081/v1/chat/completions"
	MODEL    = "gwen3-8b"
)

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type Payload struct {
	Model       string    `json:"model"`
	Temperature float64   `json:"temperature"`
	Messages    []Message `json:"messages"`
	N           int       `json:"n,omitempty"`
}

type Choice struct {
	Message Message `json:"message"`
}

type Response struct {
	Choices []Choice `json:"choices"`
}

var commitTypeDescriptions = map[string]string{
	"feat":     "A new feature",
	"fix":      "A bug fix",
	"docs":     "Documentation only changes",
	"style":    "Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)",
	"refactor": "A code change that neither fixes a bug nor adds a feature",
	"perf":     "A code change that improves performance",
	"test":     "Adding missing tests or correcting existing tests",
	"build":    "Changes that affect the build system or external dependencies",
	"ci":       "Changes to our CI configuration files and scripts",
	"chore":    "Other changes that don't modify src or test files",
	"revert":   "Reverts a previous commit",
}

var commitTypeEmojis = map[string]string{
	"feat":     "✨",
	"fix":      "🐛",
	"docs":     "📝",
	"style":    "💄",
	"refactor": "♻️",
	"perf":     "⚡",
	"test":     "✅",
	"build":    "🏗️",
	"ci":       "🔧",
	"chore":    "🔨",
	"revert":   "⏪",
}

func getStagedDiff() (string, error) {
	cmd := exec.Command("git", "diff", "--cached")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(output), nil
}

func buildPrompt(diff, userSuggestion, commitType, language string, maxLength int) string {
	descriptionBlock, _ := json.MarshalIndent(commitTypeDescriptions, "", "  ")

	promptParts := []string{
		"Generate a concise git commit message written in present tense for the following code diff with the given specifications below:",
		fmt.Sprintf("Message language: %s", language),
		fmt.Sprintf("Commit message must be a maximum of %d characters.", maxLength),
		"Exclude anything unnecessary such as translation. Your entire response will be passed directly into git commit.",
		fmt.Sprintf("Use this user suggestion as the main source of information: %s", userSuggestion),
	}

	if commitType != "" {
		promptParts = append(promptParts, fmt.Sprintf("Choose a type from the type-to-description JSON below that best describes the git diff:\n%s", descriptionBlock))
		promptParts = append(promptParts, "The output response must be in format:\n<type>(<optional scope>): <commit message>")
	} else {
		promptParts = append(promptParts, "The output response must be a simple message in present tense.")
	}

	promptParts = append(promptParts, fmt.Sprintf("\nHere is the code diff:\n%s", diff))
	return strings.Join(promptParts, "\n")
}

func sendToAI(prompt, model string, count int) ([]string, error) {
	payload := Payload{
		Model:       model,
		Temperature: 0.7,
		N:           count,
		Messages: []Message{{
			Role:    "user",
			Content: prompt,
		}},
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return nil, err
	}

	resp, err := http.Post(ENDPOINT, "application/json", bytes.NewBuffer(data))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var result Response
	err = json.Unmarshal(body, &result)
	if err != nil {
		return nil, err
	}

	if len(result.Choices) == 0 {
		return nil, fmt.Errorf("no choices returned by AI")
	}

	messages := []string{}
	for _, choice := range result.Choices {
		messages = append(messages, strings.TrimSpace(choice.Message.Content))
	}
	return messages, nil
}

func selectMessage(messages []string) (string, error) {
	if len(messages) == 1 {
		return messages[0], nil
	}

	fmt.Println("\n💬 Choose one of the following commit messages:")
	for i, msg := range messages {
		fmt.Printf("[%d]: %s\n", i+1, msg)
	}

	var choice int
	fmt.Print("\nEnter the number of your choice: ")
	_, err := fmt.Scanf("%d", &choice)
	if err != nil || choice < 1 || choice > len(messages) {
		return "", fmt.Errorf("invalid selection")
	}

	return messages[choice-1], nil
}

func addEmojiToMessage(message, commitType string, emojiEnabled bool) string {
	if !emojiEnabled || commitType == "" {
		return message
	}
	emoji, ok := commitTypeEmojis[commitType]
	if !ok {
		return message
	}
	return fmt.Sprintf("%s %s", emoji, message)
}

func main() {
	commitType := flag.String("commit-type", "feat", "Conventional commit type (e.g., fix, feat)")
	language := flag.String("language", "English", "Language for commit message")
	model := flag.String("model", MODEL, "Model to use")
	maxLength := flag.Int("max-length", 72, "Maximum commit message length")
	dryRun := flag.Bool("dry-run", false, "Only print the commit message, don't commit")
	emojiEnabled := flag.Bool("emoji", false, "Prefix the commit message with an emoji")
	numChoices := flag.Int("choices", 3, "Number of commit message suggestions to choose from")
	userSuggestion := flag.String("user-suggestion", nil, "User suggestion if there are any")
	flag.Parse()

	diff, err := getStagedDiff()
	if err != nil || strings.TrimSpace(diff) == "" {
		fmt.Println("❌ No staged changes found.")
		os.Exit(1)
	}

	prompt := buildPrompt(diff, *userSuggestion, *commitType, *language, *maxLength)
	messages, err := sendToAI(prompt, *model, *numChoices)
	if err != nil {
		fmt.Println("Error sending to AI:", err)
		os.Exit(1)
	}

	selectedMessage, err := selectMessage(messages)
	if err != nil {
		fmt.Println("Error selecting message:", err)
		os.Exit(1)
	}

	finalMessage := addEmojiToMessage(selectedMessage, *commitType, *emojiEnabled)

	if *dryRun {
		fmt.Println("\n💬 Selected commit message:\n")
		fmt.Println(finalMessage)
	} else {
		cmd := exec.Command("git", "commit", "-m", finalMessage)
		cmd.Stdin = os.Stdin
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err := cmd.Run()
		if err != nil {
			fmt.Println("Failed to create commit:", err)
			os.Exit(1)
		}
		fmt.Println("✅ Commit created.")
	}
}
