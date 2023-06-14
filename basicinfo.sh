
# block explorer urls
declare -A BLOCK_EXPLORERS=(
  ["ethereum"]='https://etherscan.io'
  ["bsc"]='https://bscscan.com'
  ["polygon"]='https://polygonscan.com'
  ["arbitrum"]='https://arbiscan.io'
  ["optimism"]='https://optimistic.etherscan.io'
  ["avalanche"]='https://snowtrace.ioi'
  ["fantom"]='https://ftmscan.com/'
  ["gnosis"]='https://gnosisscan.io'
)
# rpcs links
declare -A RPC_URLS=(
  ["ethereum"]='https://rpc.ankr.com/eth'
  ["bsc"]='https://rpc.ankr.com/bsc'
  ["polygon"]='https://rpc.ankr.com/polygon'
  ["arbitrum"]='https://rpc.ankr.com/arbitrum'
  ["optimism"]='https://rpc.ankr.com/optimism'
  ["avalanche"]='https://rpc.ankr.com/avalanche'
  ["fantom"]='https://rpc.ankr.com/fantom'
  ["gnosis"]='https://rpc.ankr.com/gnosis'
)

declare -A ETHERSCAN_API_KEYS=(
  ["ethereum"]='<YOUR_API_KEY>'
  ["bsc"]='<YOUR_API_KEY>'
  ["polygon"]='<YOUR_API_KEY>'
  ["arbitrum"]='<YOUR_API_KEY>'
  ["optimism"]='<YOUR_API_KEY>'
  ["avalanche"]='<YOUR_API_KEY>'
  ["fantom"]='<YOUR_API_KEY>'
  ["gnosis"]='<YOUR_API_KEY>'
)

declare -A PHALCON_CHAIN_ID_URL_PATHS=(
  ['1']="eth"
  ['56']="bsc"
  ['137']="polygon"
  ['42161']="arbitrum"
  ['10']="optimism"
  ['43114']="avax"
  ['250']="ftm"
  ['100']="gnosis"
  ['25']="cronos"
)

declare -A OPENCHAIN_CHAIN_ID_URL_PATHS=(
  ['1']="ethereum"
  ['56']="binance"
  ['137']="polygon"
  ['42161']="arbitrum"
  ['10']="optimism"
  ['43114']="avalanche"
  ['250']="fantom"
)

