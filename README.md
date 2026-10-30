# Meera's meetup assurance contract

**Guarantee:** If the target is reached, Meera gets the deposit. If not, everyone gets their money back. Nobody can stop that. Terms are immutable and supporters claim refunds directly.

Sepolia address: `PENDING_DEPLOYMENT` (tracked in `deployments/sepolia.json`).

Run `forge test`. To deploy: `cp .env.example .env`, fill its values, then run `source .env && forge script script/Deploy.s.sol:Deploy --rpc-url "$SEPOLIA_RPC_URL" --broadcast`. Never commit `.env`; replace the pending address after deploy.

Phone UI: `cd web && npm install && npm run dev`; set `VITE_CONTRACT_ADDRESS` in `web/.env`. The contract enforces terms, deadline and withdrawals; an optional bonus is split pro-rata if the campaign fails.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
