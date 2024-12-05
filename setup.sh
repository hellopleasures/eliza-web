#!/bin/bash

# Define the project root and ensure the script runs from there
ROOT_DIR=$(pwd)

echo "Setting up Eliza frontend with the App Router in Next.js..."

# Create required directories
mkdir -p $ROOT_DIR/app/api/chat $ROOT_DIR/app/components $ROOT_DIR/app/styles

# Create files and populate them
# app/page.tsx
cat > $ROOT_DIR/app/page.tsx <<EOL
'use client';

import { useState } from 'react';
import ChatBox from './components/ChatBox';
import MessageInput from './components/MessageInput';

export default function Home() {
  const [messages, setMessages] = useState<{ sender: string; text: string }[]>([]);

  const sendMessage = async (text: string) => {
    const userMessage = { sender: 'user', text };
    setMessages((prev) => [...prev, userMessage]);

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text }),
      });

      const data = await response.json();
      const botMessage = { sender: 'bot', text: data.response };
      setMessages((prev) => [...prev, botMessage]);
    } catch (error) {
      console.error('Error sending message:', error);
    }
  };

  return (
    <div className="container">
      <h1>Eliza Chat</h1>
      <ChatBox messages={messages} />
      <MessageInput onSend={sendMessage} />
    </div>
  );
}
EOL

# app/components/ChatBox.tsx
cat > $ROOT_DIR/app/components/ChatBox.tsx <<EOL
interface ChatBoxProps {
  messages: { sender: string; text: string }[];
}

const ChatBox: React.FC<ChatBoxProps> = ({ messages }) => {
  return (
    <div className="chat-box">
      {messages.map((message, index) => (
        <div
          key={index}
          className={\`message \${message.sender === 'user' ? 'user' : 'bot'}\`}
        >
          <span>{message.text}</span>
        </div>
      ))}
    </div>
  );
};

export default ChatBox;
EOL

# app/components/MessageInput.tsx
cat > $ROOT_DIR/app/components/MessageInput.tsx <<EOL
'use client';

import { useState } from 'react';

interface MessageInputProps {
  onSend: (text: string) => void;
}

const MessageInput: React.FC<MessageInputProps> = ({ onSend }) => {
  const [input, setInput] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (input.trim()) {
      onSend(input.trim());
      setInput('');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="message-input">
      <input
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="Type your message..."
      />
      <button type="submit">Send</button>
    </form>
  );
};

export default MessageInput;
EOL

# app/api/chat/route.ts
cat > $ROOT_DIR/app/api/chat/route.ts <<EOL
import { NextResponse } from 'next/server';

export async function POST(req: Request) {
  try {
    const { message } = await req.json();

    const response = await fetch('http://localhost:5000/chat', { // Update the URL to match your backend
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message }),
    });

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error('Error in API route:', error);
    return NextResponse.json({ error: 'Error communicating with backend' }, { status: 500 });
  }
}
EOL

# app/styles/globals.css
cat > $ROOT_DIR/app/styles/globals.css <<EOL
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.chat-box {
  width: 100%;
  max-width: 600px;
  height: 400px;
  border: 1px solid #ccc;
  padding: 10px;
  overflow-y: auto;
  margin-bottom: 20px;
  background-color: #f9f9f9;
}

.message {
  margin: 10px 0;
  padding: 10px;
  border-radius: 5px;
}

.message.user {
  align-self: flex-end;
  background-color: #d1e7dd;
}

.message.bot {
  align-self: flex-start;
  background-color: #f8d7da;
}

.message-input {
  display: flex;
  gap: 10px;
}

.message-input input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.message-input button {
  padding: 10px 20px;
  border: none;
  background-color: #007bff;
  color: #fff;
  border-radius: 5px;
  cursor: pointer;
}

.message-input button:hover {
  background-color: #0056b3;
}
EOL

echo "Setup complete! You can now start your app with 'npm run dev'."
