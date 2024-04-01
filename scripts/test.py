from web3 import Web3
from brownie import FundMe, MockV3Aggregator, network, config, accounts
from scripts.helpful_scripts import (
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    get_account,
    deploy_mocks,
)

DECIMASLS = 6
STARTING_PRICE = 35102242349900 * 10**8


def main():
    account = get_account()
    MockV3Aggregator.deploy(
        DECIMASLS,
        Web3.from_wei(STARTING_PRICE, "ether"),  # changing from eth to wei
        {
            "from": get_account(),
            "gas_price": config["networks"][network.show_active()].get("gas_price"),
        },
    )
    price_feed_address = MockV3Aggregator[-1].address
    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )

    print(f"Contract deployed to {fund_me.address}")
    print(fund_me.getPrice())
