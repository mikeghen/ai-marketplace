import '../styles/globals.css'
import 'tailwindcss/tailwind.css'
import '@rainbow-me/rainbowkit/styles.css'

import type { AppProps } from 'next/app'
import { ThemeProvider } from 'next-themes'

import { getDefaultWallets, RainbowKitProvider } from '@rainbow-me/rainbowkit'
import { chain, configureChains, createClient, WagmiConfig } from 'wagmi'
import { alchemyProvider } from 'wagmi/providers/alchemy'
import { publicProvider } from 'wagmi/providers/public'
import { Chain } from 'wagmi'

import config from '../config/env-vars'
const { NEXT_PUBLIC_ALCHEMY_ID, NEXT_PUBLIC_INFURA_ID, NEXT_PUBLIC_ETHERSCAN_API_KEY } = config

const alchemyId = NEXT_PUBLIC_ALCHEMY_ID
const etherscanApiKey = NEXT_PUBLIC_ETHERSCAN_API_KEY

export const localhost: Chain = {
  id: 31337,
  name: 'Localhost',
  network: 'localhost',
  nativeCurrency: {
    decimals: 18,
    name: 'Ether',
    symbol: 'ETH',
  },
  rpcUrls: {
    public: 'http://localhost:8545',
    default: 'http://localhost:8545',
  },
} 

const { chains, provider } = configureChains(
  [chain.arbitrum, localhost],
  [alchemyProvider({ apiKey: alchemyId }), publicProvider()],
)
const { connectors } = getDefaultWallets({
  appName: 'AI Marketplace Chat Demo',
  chains,
})

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
})

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <ThemeProvider attribute="class">
      <div className="min-h-screen bg-white dark:bg-gray-900 dark:text-white">
        <WagmiConfig client={wagmiClient}>
          <RainbowKitProvider chains={chains}>
            <Component {...pageProps} />
          </RainbowKitProvider>
        </WagmiConfig>
      </div>
    </ThemeProvider>
  )
}
export default App
