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

const ENDPOINT = "http://192.168.68.114:8081/v1/chat/completions"

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type Payload struct {
	Model       string    `json:"model"`
	Temperature float64   `json:"temperature"`
	Messages    []Message `json:"messages"`
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

func buildPrompt(diff, commitType, language string, maxLength int) string {
	descriptionBlock, _ := json.MarshalIndent(commitTypeDescriptions, "", "  ")

	promptParts := []string{
		"Generate a concise git commit message written in present tense for the following code diff with the given specifications below:",
		fmt.Sprintf("Message language: %s", language),
		fmt.Sprintf("Commit message must be a maximum of %d characters.", maxLength),
		"Exclude anything unnecessary such as translation. Your entire response will be passed directly into git commit.",
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

func sendToAI(prompt, model string) (string, error) {
	payload := Payload{
		Model:       model,
		Temperature: 0.7,
		Messages: []Message{{
			Role:    "user",
			Content: prompt,
		}},
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}

	resp, err := http.Post(ENDPOINT, "application/json", bytes.NewBuffer(data))
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var result Response
	err = json.Unmarshal(body, &result)
	if err != nil {
		return "", err
	}

	if len(result.Choices) == 0 {
		return "", fmt.Errorf("no choices returned by AI")
	}

	return strings.TrimSpace(result.Choices[0].Message.Content), nil
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
	commitType := flag.String("commit-type", "", "Conventional commit type (e.g., fix, feat)")
	language := flag.String("language", "English", "Language for commit message")
	model := flag.String("model", "mistral-7b-instruct-v0.3", "Model to use")
	maxLength := flag.Int("max-length", 72, "Maximum commit message length")
	dryRun := flag.Bool("dry-run", false, "Only print the commit message, don't commit")
	emojiEnabled := flag.Bool("emoji", false, "Prefix the commit message with an emoji")
	flag.Parse()

	diff, err := getStagedDiff()
	if err != nil || strings.TrimSpace(diff) == "" {
		fmt.Println("❌ No staged changes found.")
		os.Exit(1)
	}

	prompt := buildPrompt(diff, *commitType, *language, *maxLength)
	message, err := sendToAI(prompt, *model)
	if err != nil {
		fmt.Println("Error sending to AI:", err)
		os.Exit(1)
	}

	message = addEmojiToMessage(message, *commitType, *emojiEnabled)

	if *dryRun {
		fmt.Println("\n💬 Commit message:\n")
		fmt.Println(message)
	} else {
		cmd := exec.Command("git", "commit", "-m", message)
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
