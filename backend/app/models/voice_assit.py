import speech_recognition as sr
from gtts import gTTS
from gpt4all import GPT4All
from googletrans import Translator
import pygame
import io

# Initialize pygame mixer
pygame.mixer.init()

# Load PHI model
MODEL_NAME = r"C:\Users\Kalyani\OneDrive\AI-Voice-Assistant-for-farmers\models\Phi-3-mini-4k-instruct-q4.gguf"
model = GPT4All(MODEL_NAME, allow_download=False)

translator = Translator()

# Speak Marathi fully in-memory using pygame
def speak(text):
    print("Assistant (Marathi):", text)
    tts = gTTS(text=text, lang="mr")
    mp3_fp = io.BytesIO()
    tts.write_to_fp(mp3_fp)
    mp3_fp.seek(0)

    # Load MP3 data directly into pygame mixer
    pygame.mixer.music.load(mp3_fp, "mp3")
    pygame.mixer.music.play()

    # Wait until playback is finished
    while pygame.mixer.music.get_busy():
        pygame.time.Clock().tick(10)

# Listen from microphone
def listen():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("🎙️ Recording... बोला.")
        audio = r.listen(source, timeout=5)
    try:
        query = r.recognize_google(audio, language="mr-IN")
        print("Farmer (Marathi):", query)
        return query
    except:
        print("⚠️ ऐकू आले नाही.")
        return "मला ऐकू आले नाही."

# PHI with memory
conversation_history = []

def ask_phi_with_memory(user_input_en):
    prompt = ""
    for q, a in conversation_history:
        prompt += f"Farmer: {q}\nAssistant: {a}\n"
    prompt += f"Farmer: {user_input_en}\nAssistant:"
    try:
        with model.chat_session():
            response = model.generate(prompt, max_tokens=200)
        conversation_history.append((user_input_en, response))
        return response
    except Exception as e:
        print("⚠️ GPT error:", e)
        return "मला उत्तर देता आले नाही."

# Main loop
print("🌾 Marathi Voice Assistant for Farmers (Offline)")
speak("नमस्कार! मी तुमचा शेतकरी सहाय्यक आहे. तुम्ही काही विचारू शकता.")
print("Type 'थांब' or 'बंद' to exit.\n")

while True:
    query_mr = listen()
    if "थांब" in query_mr or "बंद" in query_mr:
        speak("ठीक आहे, नमस्कार!")
        break

    query_en = translator.translate(query_mr, src="mr", dest="en").text
    response_en = ask_phi_with_memory(query_en)
    response_mr = translator.translate(response_en, src="en", dest="mr").text
    speak(response_mr)
