from scripts.helpful_scripts import get_account, LOCAL_BLOCKCHAIN_ENVIRONMENTS
from scripts.deploy import deploy_fund_me
import pytest
from brownie import network, accounts, exceptions, FundMe


def main():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me = deploy_fund_me()
    entrance_fee = fund_me.getPrice()
    print(f"The current entry fee is {entrance_fee}")
