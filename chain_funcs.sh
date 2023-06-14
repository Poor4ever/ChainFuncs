########################################################
#                                                      # 
#      _     _              __                         #
#     | |   (_)            / _|                        #
#  ___| |__  _  __ _ _ __  | |_ _   _ _ __   ___ ___   # 
# / __| '_ \| |/ _` | '_ \ |  _| | | | '_ \ / __/ __|  #
#| (__| | | | | (_| | | | || | | |_| | | | | (__\__ \  #
# \___|_| |_|_|\__,_|_| |_||_|  \__,_|_| |_|\___|___/  #
#                                                      # 
########################################################

# =========== import ===========
# includes RPC links and Blockchain Explore links, etc.
source "$(dirname "$0")/basicinfo.sh"

# =========== variables ===========
#IMPLEMENTATION_SLOT="0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"

# =========== utils ===========
chainlist() {
    # If you use bash, change it to `echo "${!RPC_URLS[@]}"`
    echo "${(k)RPC_URLS[@]}"
}

showchain() {
    gas_price=$(gas)
    block_number=$(cast block-number)
    echo "\033[34m [*] Current Chain:\033[0m $chain_name"
    echo "\033[34m [*] ChianID:\033[0m $(chainid) "
    echo "\033[34m [*] Gas Price:\033[0m $((gas_price / 1000000000)) GWEI"
}

setchain() {	
    if [ "${BLOCK_EXPLORERS[$1]+isset}" ]; then
        chain_name=$1
        export ETH_RPC_URL=${RPC_URLS[$chain_name]}
        export BLOCK_EXPLORER=${BLOCK_EXPLORERS[$chain_name]}
        export ETHERSCAN_API_KEY=${ETHERSCAN_API_KEYS[$chain_name]}
        export CHAIN_ID=$(cast chain-id)
    else
        echo "\033[31m This network is not configured, Check the basicinfo.sh file. \033[0m"
    fi
}

check_address() {
    tx=""
    address=""
    if [[ ${#1} -ne 42 && ! $1 =~ \.eth && ${#1} -ne 66 ]]; then
        echo "Invalid address"
        return 1
    else
        if [[ ${#1} -eq 42 ]]; then
            address=$1
        elif [[ $1 =~ \.eth ]]; then
            address=`ens $1`
        elif [[ ${#1} -eq 66 ]]; then
            tx=$1
        fi
    fi
}

check_upgradeable() {
    # impl_address=$(cast --abi-decode "implementation()(address)" $(cast storage $1 $IMPLEMENTATION_SLOT))
    zero_address=$(cast --address-zero)
    impl_address=$(cast impl $1)
    if [[ $impl_address == $zero_address ]]; then
        impl_address=$1
    fi
}

get_tx_chainid() {
    chain_id=$(curl -s 'https://explorer.phalcon.xyz/api/v1/tx/search' \
                -H 'content-type: application/json;charset=utf-8' \
                --data-raw "{\"txnHash\":\"${1}\"}" \
                | jq -r ".txns[0].chainID"
            )   
}

# =========== visitweb ===========

debank() {
    if check_address $1; then
	    link="https://debank.com/profile/$address"
        open -n $link
    fi
}

explore() {
    check_address $1
    if [[ ! -z $address ]]; then
        arg="${BLOCK_EXPLORER}/address/$address"
        open -n $arg
    elif [[ ! -z $tx ]]; then
        arg="${BLOCK_EXPLORER}/tx/$tx"
        open -n $arg
    fi
}

phalcon() {
    get_tx_chainid $1
    link="https://explorer.phalcon.xyz/tx/${PHALCON_CHAIN_ID_URL_PATHS[$chain_id]}/$1"
    open -n $link
}

openchain() {
    get_tx_chainid $1
    link="https://openchain.xyz/trace/${OPENCHAIN_CHAIN_ID_URL_PATHS[$chain_id]}/$1"
    open -n $link
}

# =========== cast ===========

# Decimal to Hex
d2h() {
    cast --to-base $1 16
}

# Hex to Decimal
h2d() {
    cast --to-base $1 10
}

# Convert wei into an ETH amount
w2e() {
    cast --from-wei $1
}

#Convert an ETH amount to wei
e2w() {
    cast --to-wei $1
}

# Get token decimals
qdecimals() {
   cast call $1 "decimals()(uint256)"
}

# Query for the specified address token balance, e.g. `qbalance tokenAddress queryAddress`
qbalance() {
    if check_address $2; then
        balance=$(cast call $1 balanceOf\(address\)\(uint256\) $address)
        echo "[+] Balance Amount: $balance"
        echo "[+] Token Decimals: $(qdecimals $1)"
    fi
}

# Gets the function signature and corresponding function from the not verify contract
# Todo: add more get function signature rules
allf() {
    contract_bytecode=$(bytecode $1)
    function_signatures=($(echo "$contract_bytecode" | grep -Eo "63([0-9a-f]{8})1461([0-9a-f]{4})57" | cut -c 3-10))
    echo "\033[34m Query function signatures: \033[0m"
    for sig in "${function_signatures[@]}"; do
        result=$(4byte $sig 2>&1)
        if [[ $result == *"No matching function signatures"* ]]; then
            echo "\033[33m [!] 0x$sig Function signature not found \033[0m"
        else
            echo "\033[32m [+] 0x$sig -> $result \033[0m"
        fi
    done
}

#Get the source code of a contract from Etherscan and save to local
downloadsoure() {
  check_upgradeable $1
  contract_name=$(curl -s --location --request GET "https://api.etherscan.io/api?module=contract&action=getsourcecode&address=${impl_address}&apikey=${ETHERSCAN_API_KEY}" | jq -r '.result[0].ContractName')
  cast etherscan-source $impl_address -d $contract_name
}

# Get the bytecode of a contract
bytecode() {
    cast code $1
}

fsig() {
    cast sig $1
}

4byte() {
    echo `cast 4byte $1`
}
 
ens() {
    cast resolve-name $1
}

interface() {
    cast interface $1 -c $CHAIN_ID
}

chainid() {
    cast chain-id
}

gas() {
   cast gas-price
}


# automatically configure mainnet when opening a new shell, if ETH_RPC_URL is not already configured
if [[ -z "$ETH_RPC_URL" ]] then 
    setchain ethereum
fi
