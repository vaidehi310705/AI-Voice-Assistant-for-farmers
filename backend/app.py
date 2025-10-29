from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from gpt4all import GPT4All
from deep_translator import GoogleTranslator
from gtts import gTTS
import os
import uuid

app = Flask(__name__)
CORS(app)

# Load GPT4All model
model_path = "C:\\Users\\HP\\Downloads\\Phi-3-mini-4k-instruct-q4.gguf"
model = GPT4All(model_path)

# Maintain conversations per session
conversations = {}

@app.route("/ask", methods=["POST"])
def ask():
    data = request.json
    marathi_text = data.get("message")
    session_id = data.get("session_id", str(uuid.uuid4()))

    # Initialize conversation
    if session_id not in conversations:
        conversations[session_id] = []

    # Translate user message to English
    translated = GoogleTranslator(source='mr', target='en').translate(marathi_text)
    conversations[session_id].append(f"User: {translated}")

    # Build prompt from conversation
    prompt = "\n".join(conversations[session_id]) + "\nAssistant:" 

    # Generate response from GPT4All
    response = model.generate(prompt, max_tokens=150)

    # Translate response back to Marathi
    marathi_response = GoogleTranslator(source='en', target='mr').translate(response)
    conversations[session_id].append(f"Assistant: {response}")

    # Save TTS audio
    os.makedirs("audio_responses", exist_ok=True)
    audio_file = f"{session_id}.mp3"
    tts = gTTS(marathi_response, lang="mr")
    tts.save(f"audio_responses/{audio_file}")

    return jsonify({
        "reply": marathi_response,
        "audio_url": f"http://localhost:5000/audio_responses/{audio_file}",
        "session_id": session_id
    })

@app.route("/audio_responses/<filename>")
def serve_audio(filename):
    return send_from_directory("audio_responses", filename)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
