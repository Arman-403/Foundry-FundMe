-include .env

build:
	forge build

deploy-local:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast 

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(W_PRIVATE_KEY) --broadcast

deploy-mainnet:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(MAINNET_RPC_URL) --private-key $(W_PRIVATE_KEY) --broadcast


.PHONY: test
TEST ?=

test: 
	@forge test $(if $(TEST), --mt $(TEST)) -vvvv