# Meera's Meetup Assurance Contract

**Guarantee:** If the target is reached by the deadline, the beneficiary collects the deposit. If not, supporters get their money back. Nobody can stop that — terms are immutable and supporters claim refunds directly.

## Deployed Contracts

| Network | Contract | Address |
|---------|----------|---------|
| Sepolia (11155111) | AssuranceCampaign | `0xE7C539Fa90b3abf68e5f47276A7Ce8c7edcc781f` |

## Setup

```sh
cp .env.example .env
# fill PRIVATE_KEY, SEPOLIA_RPC_URL, TARGET, DEADLINE, BENEFICIARY
source .env
```

## Deploy

```sh
forge script script/Deploy.s.sol --rpc-url "$SEPOLIA_RPC_URL" --private-key "$PRIVATE_KEY" --broadcast
```

Never commit `.env`; replace the pending address after deploy.

## Phone UI

```sh
cd web && npm install && npm run dev
```

Set `VITE_CONTRACT_ADDRESS` in `web/.env`.

## Testing

```sh
forge test
```

## Foundry

https://book.getfoundry.sh/

```sh
$ forge build
$ forge test
$ forge fmt
$ anvil
$ forge --help
$ cast --help
```