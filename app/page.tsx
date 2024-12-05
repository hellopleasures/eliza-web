'use client';

import { useState } from "react";
import ChatBox from "./components/ChatBox";
import MessageInput from "./components/MessageInput";

export default function Home() {
  const [messages, setMessages] = useState<{ sender: string; text: string }[]>([]);
  const [selectedAgent, setSelectedAgent] = useState<string>("Agent");

  const sendMessage = async (input: string) => {
    // Add user message to state
    const userMessage = { sender: "user", text: input };
    setMessages((prev) => [...prev, userMessage]);
  
    try {
      // Send user input to the backend
      const response = await fetch("/api/message", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ input }),
      });
  
      // Add bot's response to state
      const data: { sender: string; text: string }[] = await response.json();
      const botMessage = { sender: "bot", text: data[0]?.text || "No response" };
      setMessages((prev) => [...prev, botMessage]);
    } catch (error) {
      console.error("Error sending message:", error);
    }
  };
  
  return (
    <div className="container">
      <h1>Eliza Chat</h1>
      <select onChange={(e) => setSelectedAgent(e.target.value)} value={selectedAgent}>
        <option value="Agent">Agent</option>
        {/* Add other agents dynamically here */}
      </select>
      <ChatBox messages={messages} />
      <MessageInput onSend={sendMessage} />
    </div>
  );
}
