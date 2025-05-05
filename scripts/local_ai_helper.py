import json
import requests

def send_to_local_ai(prompt, model="qwen3-8b", temperature=0.3, url="http://localhost:8080/v1/chat/completions"):
    print(f"Prompting local AI with model: {model}...")

    payload = {
        "model": model,
        "temperature": temperature,
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }

    try:
        response = requests.post(
            url,
            headers={"Content-Type": "application/json"},
            data=json.dumps(payload)
        )
        response.raise_for_status()
        content = response.json()["choices"][0]["message"]["content"]
        print("Response from AI:\n")
        return content
    except requests.RequestException as e:
        raise RuntimeError(f"Error during AI processing: {e}")

def get_prompt_for_single_commit(diff, commit_type=None, custom_rules=None, language="English"):
    prompt = f"Write a professional git commit message based on the diff below in {language} language"
    prompt += f" with commit type '{commit_type}'." if commit_type else "."
    prompt += " Do not preface the commit with anything, use the present tense, return the full sentence, and use the conventional commits specification (<type in lowercase>: <subject>)"
    prompt += f". Additionally apply these JSON formatted rules to your response, even though they might be against previous mentioned rules {custom_rules}:" if custom_rules else ":"
    prompt += f"\n\n{diff}"
    return prompt

def get_prompt_for_multiple_commits(diff, commit_type=None, custom_rules=None, num_options=3, language="English"):
    prompt = f"Please write a professional commit message for me to push to GitHub based on this git diff: {diff}. Message should be in {language} language"
    prompt += f" with commit type '{commit_type}'," if commit_type else ","
    prompt += f" and make {num_options} options that are separated by \";\". For each option, use the present tense, return the full sentence, and use the conventional commits specification (<type in lowercase>: <subject>)"
    prompt += f". Additionally apply these JSON formatted rules to your response, even though they might be against previous mentioned rules {custom_rules}:" if custom_rules else ":"
    return prompt

