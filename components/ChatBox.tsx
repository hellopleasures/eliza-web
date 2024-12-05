interface ChatBoxProps {
  messages: { sender: string; text: string }[];
}

const ChatBox: React.FC<ChatBoxProps> = ({ messages }) => (
  <div className="chat-box">
    {messages.map((message, index) => (
      <div
        key={index}
        className={`message ${message.sender === "user" ? "user" : "bot"}`}
      >
        <span>{message.text}</span>
      </div>
    ))}
  </div>
);

export default ChatBox;



