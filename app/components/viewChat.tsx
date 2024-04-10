import React, { useState } from 'react';
import { useAccount } from "wagmi";

const ViewChat = () => {
    const { address } = useAccount();
    const [systemPrompt, setSystemPrompt] = useState('');
    const [userPrompt, setUserPrompt] = useState('');
    const [model, setModel] = useState('GPT-4');
    const [temperature, setTemperature] = useState('');
    const [message, setMessage] = useState('');
    const [chatHistory, setChatHistory] = useState([]);

    const sendMessage = () => {
        if (!message.trim()) return;
        const newMessage = { id: chatHistory.length + 1, text: message, sender: 'user' };
        const reply = { id: chatHistory.length + 2, text: "Thank you", sender: 'bot' };

        setChatHistory(chatHistory => [...chatHistory, newMessage, reply]);
        setMessage('');
    };

    const styles = {
        chatContainer: {
            borderRadius: '20px',
            overflow: 'hidden',
            fontFamily: "'Helvetica Neue', Helvetica, Arial, sans-serif",
        },
        chatHeader: {
            backgroundColor: '#f7f7f7',
            color: '#000',
            textAlign: 'center',
            padding: '10px 0',
            fontSize: '18px',
            borderBottom: '1px solid #ddd',
        },
        chatBody: {
            padding: '10px',
            height: '500px', // Adjust as needed
            overflowY: 'scroll',
            backgroundColor: '#E5E5EA', // Light gray background similar to iMessage
        },
        messageInput: {
            display: 'flex',
            padding: '10px',
            backgroundColor: '#f7f7f7',
            borderTop: '1px solid #ddd',
        },
        inputField: {
            flex: 1,
            padding: '10px',
            borderRadius: '20px',
            border: '1px solid #ddd',
            marginRight: '10px',
        },
        sendButton: {
            display: 'inline-block',
            fontSize: '16px',
            padding: '10px 15px',
            color: '#007bff', // iOS send button color
            background: 'none',
            border: 'none',
            cursor: 'pointer',
        },
        userMessage: {
            backgroundColor: '#007AFF', // Blue bubble for user messages
            color: '#fff',
            padding: '8px 12px',
            borderRadius: '18px',
            maxWidth: '60%',
            marginLeft: 'auto',
            marginBottom: '8px',
            wordBreak: 'break-word',
        },
        botMessage: {
            backgroundColor: '#fff', // White bubble for bot/received messages
            color: '#000',
            padding: '8px 12px',
            borderRadius: '18px',
            maxWidth: '60%',
            marginRight: 'auto',
            marginBottom: '8px',
            wordBreak: 'break-word',
            border: '1px solid #ddd',
        }
    };

    return (
        <div className="container-fluid">
            <div className="row">
                {/* First column for the form */}
                <div className="col-md-4">
                    <div className="card">
                        <div className="card-body">
                            <form>
                                <div className="form-group">
                                    <label>System Prompt:</label>
                                    <textarea type="text" className="form-control" value={systemPrompt} onChange={(e) => setSystemPrompt(e.target.value)} />
                                </div>
                                <br />
                                <div className="form-group">
                                    <label>Model:</label>
                                    <select
                                        className="form-control"
                                        value={model}
                                        onChange={(e) => setModel(e.target.value)}>
                                        <option value="GPT-4">GPT-4</option>
                                        <option value="GPT-3.5-turbo">GPT-3.5-turbo</option>
                                        <option value="Claude3">Claude3</option>
                                        {/* Additional OpenAI models */}
                                        <option value="Llama2">Llama2</option>
                                        <option value="curie">Curie</option>
                                        <option value="babbage">Babbage</option>
                                        <option value="ada">Ada</option>
                                    </select>
                                </div>
                                <br />
                                <div className="form-group">
                                    <label>Temperature:</label>
                                    <input type="number" className="form-control" value={temperature} onChange={(e) => setTemperature(e.target.value)} />
                                </div>
                                {/* Submit button if needed */}
                            </form>
                        </div>
                    </div>
                </div>

                {/* Second column for the chat window */}
                <div className="col-md-8">
                    <div style={styles.chatContainer}>
                        <div style={styles.chatHeader}>Chat with {model}</div>
                        <div style={styles.chatBody}>
                            {chatHistory.map(msg => (
                                <div key={msg.id} style={msg.sender === 'user' ? styles.userMessage : styles.botMessage}>
                                    {msg.text}
                                </div>
                            ))}
                        </div>
                        <div style={styles.messageInput}>
                            <input type="text" placeholder="Type your message here..." value={message} onChange={e => setMessage(e.target.value)} style={styles.inputField} />
                            <button onClick={sendMessage} style={styles.sendButton}>Send</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ViewChat;
