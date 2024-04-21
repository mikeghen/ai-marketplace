import React, { useState, useEffect } from 'react';
import { useAccount, useContractRead } from "wagmi";
import { ethers } from "ethers";
import { MARKETPLACE_ADDRESS, MARKETPLACE_ABI, TRB_ADDRESS, ERC20_ABI } from "../config/constants";
import {
    queryData,
    queryId,
    getQueryResult,
    submitRequest,
    approve,
    allowance
} from "../utils/ethereum";
import toast from "react-hot-toast";


type ChatMessage = {
    id: number;
    text: string;
    sender: string;
};

const ViewChat = () => {
    const { address } = useAccount();
    const [systemPrompt, setSystemPrompt] = useState('');
    const [userPrompt, setUserPrompt] = useState('');
    const [model, setModel] = useState('GPT-4');
    const [temperature, setTemperature] = useState('');
    const [chatHistory, setChatHistory] = useState<ChatMessage[]>([]);
    const [sendLoading, setSendLoading] = useState(false);
    const [currentQueryId, setCurrentQueryId] = useState<string>('');
    const [currentResult, setCurrentResult] = useState<string>('');
    const [isAllowed, setIsAllowed] = useState<boolean>(false);
    const [approveLoading, setApproveLoading] = useState(false);
    const [balance, setBalance] = useState<string>('0');

    const queryResult = useContractRead({
        addressOrName: MARKETPLACE_ADDRESS,
        contractInterface: MARKETPLACE_ABI,
        functionName: "getQueryResult",
        args: [currentQueryId],
        watch: true,
    });

    useEffect(() => {
        if (queryResult.data) {
            console.log("queryResult.data", queryResult.data.toNumber());
            setCurrentResult(queryResult.data.toNumber());
        }
    }, [queryResult.data]);

    const balanceResult = useContractRead({
        addressOrName: TRB_ADDRESS,
        contractInterface: ERC20_ABI,
        functionName: "balanceOf",
        args: [address],
        watch: true,
    });

    useEffect(() => {
        console.log("balanceResult.data", balanceResult.data);
        if (balanceResult.data) {
            setBalance(ethers.utils.formatUnits(balanceResult.data, 18));
        }
    }, [balanceResult.data]);

    const allowance = useContractRead({
        addressOrName: TRB_ADDRESS,
        contractInterface: ERC20_ABI,
        functionName: "allowance",
        args: [address, MARKETPLACE_ADDRESS],
        watch: true,
    });

    useEffect(() => {
        console.log("allowance.data", allowance.data);
        if (allowance.data) {
            if (allowance.data.gt(0)) {
                setIsAllowed(true);
            } else {
                setIsAllowed(false);
            }
        }
    }, [allowance.data]);


    const sendMessage = async () => {
        const payment = ethers.utils.parseUnits('1', 18).toString();
        console.log("User Prompt: ", userPrompt);
        console.log("System Prompt: ", systemPrompt);
        console.log("Model: ", model);
        console.log("Temperature: ", temperature);
        console.log("Payment: ", payment);

        // Try to approve the goalz contract to spend the amount
        try {
            setSendLoading(true);
            await submitRequest(
                systemPrompt,
                userPrompt,
                model,
                Number(temperature),
                BigInt(payment)
            );
            toast.success('Message sent 📬');
            setCurrentQueryId(
                await queryId(
                    systemPrompt,
                    userPrompt,
                    model,
                    Number(temperature)
                )
            );
        } catch (error) {
            console.log("AIMarketplace#submitRequest Error:", error);
            toast.error('Error sending message');
            return
        } finally {
            setSendLoading(false);
        }

        if (!userPrompt.trim()) return;
        const newMessage = { id: chatHistory.length + 1, text: `${userPrompt}`, sender: 'user' };

        const reply = { id: chatHistory.length + 2, text: "⏳", sender: 'bot' };

        // Set a time out for 10 seconds to check the query result
        setTimeout(async () => {   
            // TODO: Never got this working sending request response to Tellorplayground
            const cannedResponse = "The AI Marketplace typically refers to an online platform where developers and organizations can find, buy, sell, or exchange various AI-related products, services, models, datasets, and tools. It's essentially a marketplace dedicated to AI technologies, where users can discover solutions to their AI-related needs. These marketplaces can host a variety of offerings, including pre-trained machine learning models, APIs for integrating AI functionalities into applications, datasets for training AI algorithms, tools for model development and deployment, and consulting services related to AI implementation and optimization. AI marketplaces can be operated by independent companies, AI platform providers, cloud service providers, or online communities, and they serve as hubs for the AI ecosystem, fostering collaboration, innovation, and accessibility in the field of artificial intelligence.";
            const newReply = { id: chatHistory.length + 3, text: `${cannedResponse}`, sender: 'bot' };
            setChatHistory(chatHistory => [...chatHistory, newReply]);
        }, 5000);

        setChatHistory(chatHistory => [...chatHistory, newMessage, reply]);
        setUserPrompt('');
    };

    const handleApprove = async () => {
        try {
            setApproveLoading(true);
            await approve(TRB_ADDRESS);
            toast.success('TRB approved for the contract');
        } catch (error) {
            console.log("Error approving TRB for the contract:", error);
            toast.error('Error approving TRB for the contract');
        } finally {
            setApproveLoading(false);
        }
    }

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
                            <h5 className="card-title">Chat Settings</h5>
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
                                <br />
                                <div className="form-group">
                                    <label>Balance:</label>
                                    <input type="text" className="form-control" value={balance} disabled />
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
                            <input type="text" placeholder="Type your message here..." value={userPrompt} onChange={e => setUserPrompt(e.target.value)} style={styles.inputField} />
                                
                            { isAllowed ? (
                                <button onClick={sendMessage} style={styles.sendButton}>
                                    {sendLoading ? (
                                        <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                                    ) : (
                                        'Send'
                                    )}
                                </button>
                            ) : (
                                <button onClick={handleApprove} style={styles.sendButton}>
                                    {approveLoading ? (
                                        <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                                    ) : (
                                        'Approve'
                                    )}
                                </button>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ViewChat;
