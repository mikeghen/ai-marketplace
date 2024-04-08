import React, { useState } from 'react';
import { useAccount } from "wagmi";
// Import your CSS file if you decide to use a separate file
// import './ViewChat.css';

const ViewChat = () => {
    const { address } = useAccount();
    const [message, setMessage] = useState('');
    const [chatHistory, setChatHistory] = useState([]);

    const sendMessage = () => {
        if (!message.trim()) return;
        const newMessage = { id: chatHistory.length + 1, text: message, sender: 'user' };
        const reply = { id: chatHistory.length + 2, text: "Thank you", sender: 'bot' };
        
        setChatHistory(chatHistory => [...chatHistory, newMessage, reply]);
        setMessage('');
    };

    // Inline styles
    const styles = {
        chatContainer: {
            display: 'flex',
            flexDirection: 'column',
            height: '500px',
            maxWidth: '600px',
            margin: '0 auto',
            border: '1px solid #ccc',
            borderRadius: '8px',
            overflow: 'hidden',
        },
        chatHeader: {
            backgroundColor: '#007bff',
            color: '#ffffff',
            padding: '10px',
        },
        chatHistory: {
            flex: 1,
            padding: '10px',
            overflowY: 'auto',
            display: 'flex',
            flexDirection: 'column',
            gap: '8px',
        },
        chatMessage: {
            alignSelf: 'flex-start',
            backgroundColor: '#f1f1f1',
            padding: '8px',
            borderRadius: '8px',
        },
        botMessage: {
            alignSelf: 'flex-end',
            backgroundColor: '#007bff',
            color: '#ffffff',
            padding: '8px',
            borderRadius: '8px',
        },
        messageInput: {
            display: 'flex',
            padding: '10px',
            borderTop: '1px solid #ccc',
        },
        inputField: {
            flex: 1,
            marginRight: '8px',
            padding: '8px',
            border: '1px solid #ccc',
            borderRadius: '8px',
        },
        sendButton: {
            padding: '8px 16px',
            border: 'none',
            borderRadius: '8px',
            backgroundColor: '#007bff',
            color: 'white',
            cursor: 'pointer',
        }
    };

    return (
        <div style={styles.chatContainer}>
            <div style={styles.chatHeader}>Chat</div>
            <div style={styles.chatHistory} className="chat-history">
                {chatHistory.map(msg => (
                    <div key={msg.id} style={msg.sender === 'user' ? styles.chatMessage : styles.botMessage}>
                        {msg.text}
                    </div>
                ))}
            </div>
            <div style={styles.messageInput}>
                <input
                    type="text"
                    value={message}
                    onChange={e => setMessage(e.target.value)}
                    placeholder="Type your message here..."
                    style={styles.inputField}
                />
                <button onClick={sendMessage} style={styles.sendButton}>Send</button>
            </div>
        </div>
    );
};

export default ViewChat;
