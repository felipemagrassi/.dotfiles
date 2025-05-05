import argparse
import subprocess
from local_ai_helper import send_to_local_ai, get_prompt_for_single_commit

def get_git_diff():
    result = subprocess.run(["git", "diff", "--cached"], capture_output=True, text=True)
    return result.stdout.strip()

def main():
    parser = argparse.ArgumentParser(description="Generate Git commit message using local AI")
    parser.add_argument("--commit-type", help="Type for conventional commit (e.g., feat, fix)")
    parser.add_argument("--language", default="English", help="Language of the commit message")
    parser.add_argument("--model", default="qwen3-8b", help="Local AI model to use")
    parser.add_argument("--dry-run", action="store_true", help="Print commit message but don't commit")

    args = parser.parse_args()
    diff = get_git_diff()

    if not diff:
        print("❌ No staged changes detected.")
        return

    prompt = get_prompt_for_single_commit(diff, commit_type=args.commit_type, language=args.language)
    commit_msg = send_to_local_ai(prompt, model=args.model)

    if args.dry_run:
        print("\n💬 Commit message:\n")
        print(commit_msg)
    else:
        subprocess.run(["git", "commit", "-m", commit_msg])
        print("✅ Commit created with AI-generated message.")
