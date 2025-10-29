let sessionId = null;

const recordBtn = document.getElementById("recordBtn");
const status = document.getElementById("status");
const audioEl = document.getElementById("audioResponse");
const conversationEl = document.getElementById("conversation");

const recognition = new (window.SpeechRecognition ||
  window.webkitSpeechRecognition)();
recognition.lang = "mr-IN";
recognition.interimResults = false;

recordBtn.onclick = () => {
  status.textContent = "ऐकत आहे...";
  recognition.start();
};

recognition.onresult = async (event) => {
  const speech = event.results[0][0].transcript;
  addMessage("user", speech);
  status.textContent = "प्रक्रिया सुरू आहे...";
  await askAssistant(speech);
};

recognition.onerror = (event) => {
  status.textContent = "त्रुटी: " + event.error;
};

function addMessage(role, text) {
  const msgDiv = document.createElement("div");
  msgDiv.className = role === "user" ? "user-msg" : "assistant-msg";
  msgDiv.textContent = text;
  conversationEl.appendChild(msgDiv);
  conversationEl.scrollTop = conversationEl.scrollHeight;
}

async function askAssistant(message) {
  try {
    const res = await fetch("http://localhost:5000/ask", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message, session_id: sessionId }),
    });

    const data = await res.json();
    sessionId = data.session_id;
    addMessage("assistant", data.reply);
    audioEl.src = data.audio_url;
    audioEl.play();

    // ✅ Save everything to localStorage
    saveConversation({
      question: message,
      answer: data.reply,
      audio: data.audio_url,
      timestamp: new Date().toLocaleString("mr-IN"),
    });

    status.textContent = "बोला बटणावर क्लिक करा";
  } catch (err) {
    console.error("Error:", err);
    status.textContent = "सर्व्हरशी संपर्क नाही.";
  }
}

function saveConversation(entry) {
  let history = JSON.parse(localStorage.getItem("conversationHistory")) || [];
  history.push(entry);
  localStorage.setItem("conversationHistory", JSON.stringify(history));
  console.log("✅ जतन झाले:", entry);
}
