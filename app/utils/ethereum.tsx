import { BigNumber, ethers } from 'ethers';
import { MARKETPLACE_ADDRESS, MARKETPLACE_ABI, TRB_ADDRESS, ERC20_ABI } from '../config/constants'; 

// Methods for executing transaction on Ethereum 

export const getProvider = () => {
    if (typeof window.ethereum !== 'undefined') {
        return new ethers.providers.Web3Provider(window.ethereum);
    }
    throw new Error('Ethereum provider not found.');
};

export const getSigner = (provider: ethers.providers.Web3Provider) => {
    return provider.getSigner();
};

export const approve = async (depositToken: string) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const contract = new ethers.Contract(
        depositToken,
        ERC20_ABI,
        signer
    );
    const maxApprovalAmount = ethers.constants.MaxUint256;
    const approvalTx = await contract.approve(MARKETPLACE_ADDRESS, maxApprovalAmount);
    await approvalTx.wait();
};

export const allowance = async (depositToken: string) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const contract = new ethers.Contract(
        depositToken,
        ERC20_ABI,
        signer
    );
    const allowance = await contract.allowance(await signer.getAddress(), MARKETPLACE_ADDRESS);
    return allowance;
}

export const submitRequest = async (
    systemPrompt: string,
    userPrompt: string,
    model: string,
    temperature: number,
    paymentTrb: bigint
) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        MARKETPLACE_ABI,
        signer
    );
    const tx = await marketplace.submitRequest(
        systemPrompt,
        userPrompt,
        model,
        temperature,
        paymentTrb
    );
    return await tx.wait();
};

export const getQueryResult = async (queryId: string) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        MARKETPLACE_ABI,
        signer
    );
    const result = await marketplace.getQueryResult(queryId);
    return result;
}

export const queryData = async (
    systemPrompt: string,
    userPrompt: string,
    model: string,
    temperature: number
) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        MARKETPLACE_ABI,
        signer
    );
    const result = await marketplace.queryData(
        systemPrompt,
        userPrompt,
        model,
        temperature
    );
    return result;
}

export const queryId = async (
    systemPrompt: string,
    userPrompt: string,
    model: string,
    temperature: number
) => {
    const provider = await getProvider();
    const signer = await getSigner(provider);
    const marketplace = new ethers.Contract(
        MARKETPLACE_ADDRESS,
        MARKETPLACE_ABI,
        signer
    );
    const result = await marketplace.queryId(
        systemPrompt,
        userPrompt,
        model,
        temperature
    );
    return result;
}






