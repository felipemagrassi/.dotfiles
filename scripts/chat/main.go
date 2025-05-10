package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

const endpoint = "http://192.168.68.114:1234/v1/chat/completions"
const model = "mistral-7b-instruct-v0.3"

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type Payload struct {
	Model       string    `json:"model"`
	Temperature float64   `json:"temperature"`
	Messages    []Message `json:"messages"`
	MaxTokens   float64   `json:"max_tokens"`
}

type Choice struct {
	Message Message `json:"message"`
}

type Response struct {
	Choices []Choice `json:"choices"`
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	var history []Message

	fmt.Println("💬 Chat iniciado! Digite 'exit' para sair.\n")

	for {
		fmt.Print("👤 Você: ")
		userInput, _ := reader.ReadString('\n')
		userInput = strings.TrimSpace(userInput)

		if userInput == "exit" {
			fmt.Println("👋 Saindo do chat.")
			break
		}

		history = append(history, Message{
			Role:    "user",
			Content: userInput,
		})

		payload := Payload{
			Model:       model,
			Temperature: 0.8,
			Messages:    history,
		}

		body, _ := json.Marshal(payload)
		resp, err := http.Post(endpoint, "application/json", bytes.NewBuffer(body))
		if err != nil {
			fmt.Println("❌ Erro ao chamar o endpoint:", err)
			break
		}

		respBody, _ := io.ReadAll(resp.Body)
		resp.Body.Close()

		var parsed Response
		if err := json.Unmarshal(respBody, &parsed); err != nil {
			fmt.Println("❌ Erro ao parsear resposta:", err)
			break
		}

		if len(parsed.Choices) > 0 {
			reply := strings.TrimSpace(parsed.Choices[0].Message.Content)
			fmt.Println("🤖 AI:", reply)
			history = append(history, parsed.Choices[0].Message)
		} else {
			fmt.Println("🤖 AI: (sem resposta)")
		}
	}
}
