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
                    <div className="card">
                        <div className="card-header">Chat with {model}</div>
                        <div className="card-body">
                            <div className="chat-history">
                                {chatHistory.map(msg => (
                                    <div key={msg.id} className={msg.sender === 'user' ? 'alert alert-light' : 'alert alert-primary'}>
                                        {msg.text}
                                    </div>
                                ))}
                            </div>
                            <div className="input-group mt-3">
                                <input type="text" className="form-control" placeholder="Type your message here..." value={message} onChange={e => setMessage(e.target.value)} />
                                <div className="input-group-append">
                                    <button className="btn btn-primary" type="button" onClick={sendMessage}>Send</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ViewChat;
