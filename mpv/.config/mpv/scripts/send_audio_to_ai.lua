local utils = require("mp.utils")
local msg = require("mp.msg")

local audio_path, text_path, log_file, markdown_path

function log(message)
	mp.osd_message(message)
	if log_file then
		local f = io.open(log_file, "a")
		if f then
			f:write(os.date("[%Y-%m-%d %H:%M:%S] ") .. message .. "\n")
			f:close()
		end
	end
end

function run()
	local file_path = mp.get_property_native("path")
	if not file_path then
		log("❌ No file is currently playing.")
		return
	end

	local parts = {}
	for part in string.gmatch(file_path, "[^/]+") do
		table.insert(parts, part)
	end
	local file_name = parts[#parts]
	local dir_name = parts[#parts - 1] or "unknown"
	local clean_name = file_name:gsub("%.%w+$", ""):gsub("[^%w_-]", "_")

	local home_dir = os.getenv("HOME") or "/tmp"
	local output_dir = string.format("%s/generated/%s", home_dir, dir_name)
	utils.subprocess({ args = { "mkdir", "-p", output_dir } })

	audio_path = string.format("%s/%s.ogg", output_dir, clean_name)
	text_path = string.format("%s/%s.txt", output_dir, clean_name)
	markdown_path = string.format("%s/%s.md", output_dir, clean_name)
	log_file = string.format("%s/%s.log", output_dir, clean_name)

	-- Extract audio
	log("🔊 Extracting audio to: " .. audio_path)
	local ffmpeg_args = {
		"ffmpeg",
		"-y",
		"-i",
		file_path,
		"-vn",
		"-ac",
		"1",
		"-ar",
		"16000",
		"-b:a",
		"24k",
		audio_path,
	}

	local ffmpeg_result = utils.subprocess({ args = ffmpeg_args, cancellable = false })
	if ffmpeg_result.status ~= 0 then
		log("❌ ffmpeg failed: " .. (ffmpeg_result.stderr or "unknown error"))
		return
	end

	-- Transcription via Whisper
	log("🧠 Transcribing via Whisper...")
	local curl_args = {
		"curl",
		"http://localhost:8080/v1/audio/transcriptions",
		"-H",
		"Content-Type: multipart/form-data",
		"-F",
		"file=@" .. audio_path,
		"-F",
		"model=whisper-1",
	}

	local curl_result = utils.subprocess({ args = curl_args, cancellable = false })
	if curl_result.status ~= 0 or not curl_result.stdout then
		log("❌ Transcription failed.")
		return
	end

	local ok, json = pcall(function()
		return utils.parse_json(curl_result.stdout)
	end)
	if not ok or not json or not json.text then
		log("❌ Failed to parse Whisper response.")
		return
	end

	local f = io.open(text_path, "w")
	if not f then
		log("❌ Could not write transcript.")
		return
	end
	f:write(json.text)
	f:close()
	log("✅ Transcription saved to: " .. text_path)

	-- Prepare improved prompt
	log("🤖 Sending prompt to Second Brain AI...")

	local function escape_json(s)
		return s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n")
	end

	local prompt_template = [[
🧠 Act as my second brain and help me process the following transcript:

%s

Your task is to:
1. Extract only the **most important ideas** (not everything), focusing on concepts or steps that are reusable, insightful, or essential to remember.
2. For each important idea, generate a **Zettelkasten-style permanent note** in the format below:
    - Unique ID (e.g., 20250505A)
    - Note title
    - Note content (clear and concise, written so even someone who hasn’t seen the original can understand)
    - A **short practical example or use case**
    - Category: [Projects, Areas, Resources, Archives]
    - Suggested tags (e.g., #algorithms, #productivity, #learning)
    - (Optional) Linked note IDs

3. After listing the notes, write a **simple summary** of the entire transcript for a beginner or outsider, in 3–5 sentences. Make it understandable without watching the video.

📝 Return everything in **Markdown format**, structured with headers for:
- `# Notes`
- `# Summary`

Make the output clear, structured, and useful for someone building a Zettelkasten or personal knowledge base.
]]

	local escaped_prompt = escape_json(string.format(prompt_template, json.text))

	local ai_result = utils.subprocess({
		args = {
			"curl",
			"http://localhost:8080/v1/chat/completions",
			"-H",
			"Content-Type: application/json",
			"-d",
			string.format(
				[[
{
  "model": "qwen3-8b",
  "messages": [
    {"role": "user", "content": "%s"}
  ],
  "temperature": 0.3
}
]],
				escaped_prompt
			),
		},
		cancellable = false,
	})

	if not ai_result or ai_result.status ~= 0 or not ai_result.stdout then
		log("❌ AI analysis failed.")
		return
	end

	local ok2, ai_json = pcall(function()
		return utils.parse_json(ai_result.stdout)
	end)
	if not ok2 or not ai_json or not ai_json.choices or not ai_json.choices[1] then
		log("❌ Failed to parse AI response.")
		return
	end

	local ai_text = ai_json.choices[1].message.content
	local md = io.open(markdown_path, "w")
	if md then
		md:write(ai_text)
		md:close()
		log("✅ AI notes saved to: " .. markdown_path)
	else
		log("⚠️ Could not save markdown result.")
	end

	-- Cleanup
	if os.remove(audio_path) then
		log("🗑️ Deleted audio file: " .. audio_path)
	else
		log("⚠️ Failed to delete audio file: " .. audio_path)
	end
end

mp.add_key_binding("ctrl+a", "extract-and-transcribe", run)
