import speech_recognition as sr
from gtts import gTTS
import playsound
import os

# Speak Marathi text naturally
def speak(text):
    tts = gTTS(text=text, lang='mr')
    tts.save("output.mp3")
    playsound.playsound("output.mp3")
    os.remove("output.mp3")
    print("Assistant:", text)

# Record and transcribe using Google Speech Recognition
def record_and_transcribe(duration=15):
    r = sr.Recognizer()
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source)
        print("Recording... Speak now.")
        audio = r.listen(source, phrase_time_limit=duration)
    try:
        # First try Marathi
        query = r.recognize_google(audio, language="mr-IN")
        if query.strip() == "":
            # fallback to English
            query = r.recognize_google(audio, language="en-IN")
        return query
    except sr.UnknownValueError:
        try:
            return r.recognize_google(audio, language="en-IN")
        except:
            return ""
    except sr.RequestError:
        return ""


# Static Q&A for farmers
FAQ = {
    # General questions about farming
    "शेतातील पाणी कसे व्यवस्थापित करावे": "पाणी व्यवस्थापनासाठी वर्षावानुसार शेतातील पाण्याचे नियोजन करावे. ड्रिप इरिगेशन, पाणीसाठा तलाव किंवा पाईपलाइनसारख्या पद्धती वापरता येतात.",
    "पीक कधी पेरावे": "पीक पेरण्याची योग्य वेळ त्या पिकाच्या प्रकारावर आणि स्थानिक हवामानावर अवलंबून असते. स्थानिक कृषी कार्यालय किंवा KVK कडून माहिती मिळवता येईल.",
    "खते कशी वापरावी": "शेतासाठी खत वापरण्यापूर्वी मातीची चाचणी करावी. NPK प्रमाणानुसार खताची योग्य मात्रा निश्चित करा.",
    "कीटक कसे नियंत्रित करावे": "कीटक प्रतिबंधासाठी जैविक पद्धती वापरा. कीटकनाशक फवारणी करताना योग्य प्रमाण आणि वेळेचे पालन करा.",
    "बियाणे कुठून मिळेल": "स्थानिक कृषि दुकान किंवा KVK कडून प्रमाणित बियाणे मिळू शकते.",
    
    # Government support / help centers
    "कुठे जाऊन सल्ला घ्यावा": "तुमच्या जवळच्या Krishi Vigyan Kendra (KVK) किंवा तालुका कृषी कार्यालय येथे सल्ला घेऊ शकता.",
    "काय कागदपत्रे आवश्यक आहेत": "सामान्य कागदपत्रे: आधार कार्ड, जमिन दाखला, बँक खाते, Soil Health Card (जर लागू असेल).",
    "शेतकऱ्यांसाठी कोणती मदत उपलब्ध आहे": "शेतकऱ्यांसाठी सरकारकडून विविध आर्थिक व तांत्रिक मदत उपलब्ध आहे. स्थानिक कृषी कार्यालयातून माहिती मिळवता येईल.",
    
    # Weather / crop info
    "उद्या पाऊस पडेल का": "स्थानिक हवामान विभागाच्या अहवालानुसार उद्याचा पाऊस अंदाज पाहता येईल.",
    "हवामान कसे तपासावे": "स्थानिक हवामान विभाग, मोबाइल अ‍ॅप्स किंवा वेबसाईटवर हवामानाची माहिती मिळवता येते.",
    "पीक हानी भरपाई कशी मिळवावी": "जर पिकाची हानी झाली असेल, तर FRUITS प्लॅटफॉर्मवर Farmer ID सोबत नोंदणी करून दावा करता येतो.",
    
    # Market / selling
    "शेतीसाठी बाजारभाव कसे मिळवावे": "स्थानिक बाजार किंवा ऑनलाइन कृषी पोर्टल्सवर तुमच्या पिकांचे बाजारभाव मिळवता येतात.",
    "शेती उत्पादन कसे विकावे": "Farmer Producer Organization (FPO) किंवा स्थानिक मंडईत विक्री करता येते."
}

# Assistant answer using keyword search (Marathi + English)
import difflib

def get_answer(query):
    query_lower = query.lower()
    
    # Check similarity with each key
    best_score = 0
    best_key = None
    for key in FAQ.keys():
        key_lower = key.lower()
        # similarity ratio
        score = difflib.SequenceMatcher(None, query_lower, key_lower).ratio()
        if score > best_score:
            best_score = score
            best_key = key
    
    if best_score > 0.5:  # adjust cutoff as needed
        return FAQ[best_key]
    return "माफ करा, सध्या उत्तर उपलब्ध नाही."


# Main assistant flow
def main():
    speak("नमस्कार! मी तुमचा शेतकरी सहाय्यक आहे. तुम्ही काही विचारू शकता.")
    
    query = record_and_transcribe(duration=15)
    if not query:
        speak("माफ करा, काही ऐकू आले नाही. कृपया पुन्हा बोला.")
        return
    speak("तुम्ही म्हणालात: " + query)
    
    answer = get_answer(query)
    speak(answer)
    
    speak("🙏 धन्यवाद! भेटूया पुन्हा.")

if __name__ == "__main__":
    main()
