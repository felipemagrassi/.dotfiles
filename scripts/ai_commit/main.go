package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

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

func getStagedDiff() (string, error) {
	cmd := exec.Command("git", "diff", "--cached")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return string(output), nil
}

func buildPrompt(diff, commitType, language string) string {
	prompt := fmt.Sprintf("Write a professional git commit message based on the diff below in %s language", language)
	if commitType != "" {
		prompt += fmt.Sprintf(" with commit type '%s'.", commitType)
	} else {
		prompt += "."
	}
	prompt += " Do not preface the commit with anything, use the present tense, return the full sentence, and use the conventional commits specification (<type in lowercase>: <subject>):\n\n"
	prompt += diff
	return prompt
}

func sendToAI(prompt, model string) (string, error) {
	payload := Payload{
		Model:       model,
		Temperature: 0.3,
		Messages: []Message{{
			Role:    "user",
			Content: prompt,
		}},
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}

	resp, err := http.Post("http://localhost:8081/v1/chat/completions", "application/json", bytes.NewBuffer(data))
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
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

	return result.Choices[0].Message.Content, nil
}

func main() {
	commitType := flag.String("commit-type", "", "Conventional commit type (e.g., fix, feat)")
	language := flag.String("language", "English", "Language for commit message")
	model := flag.String("model", "mistral-7b-instruct-v0.3", "Model to use")
	dryRun := flag.Bool("dry-run", false, "Only print the commit message, don't commit")
	flag.Parse()

	diff, err := getStagedDiff()
	if err != nil || strings.TrimSpace(diff) == "" {
		fmt.Println("❌ No staged changes found.")
		os.Exit(1)
	}

	prompt := buildPrompt(diff, *commitType, *language)
	message, err := sendToAI(prompt, *model)
	if err != nil {
		fmt.Println("Error sending to AI:", err)
		os.Exit(1)
	}

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
