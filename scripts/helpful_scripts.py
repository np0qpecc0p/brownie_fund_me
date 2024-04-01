from brownie import accounts, config, network, MockV3Aggregator
from web3 import Web3

# global variables for MockV3Integrator setings
DECIMASLS = 8
STARTING_PRICE = 35102242349900
# dictionary for IF statement when deploying to different networks
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account():  # function that load PRIVATE_KEY from .env with brownie-config.yaml and Create address from it
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


# function that deploying MockV3Aggregator which is simulate prices for local ganache
def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(
            DECIMASLS,
            Web3.from_wei(STARTING_PRICE, "ether"),  # changing from eth to wei
            {
                "from": get_account(),
                "gas_price": config["networks"][network.show_active()].get("gas_price"),
            },
        )
    print("Mocks Deployed!")
