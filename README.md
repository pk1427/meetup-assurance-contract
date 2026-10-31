# Meera's Meetup Assurance Contract

If the target is reached by the deadline, Meera receives the deposit. If it is missed, each supporter claims their own refund. Target, deadline, and beneficiary are immutable: no admin can change the deal.

## Verified Sepolia deployment

| Item | Value |
| --- | --- |
| Contract | `AssuranceCampaign` |
| Address | [`0x4F4eD57ED746E2Fd0583044259CB283d088786c3`](https://sepolia.etherscan.io/address/0x4F4eD57ED746E2Fd0583044259CB283d088786c3) |
| Deployment | [`0x0672c17c78653705dd88c03f691fcba4e5f363f5db214712c77daa5a676fb5ce`](https://sepolia.etherscan.io/tx/0x0672c17c78653705dd88c03f691fcba4e5f363f5db214712c77daa5a676fb5ce) |
| Network | Sepolia (`11155111`), confirmed `status: 1` |

The live campaign target is `1 ETH`. The optional beneficiary bonus is split pro-rata on campaign failure; on success, it goes to the beneficiary with the deposit.

## Safety guarantees

- `pledge()` records exactly `msg.value` before the deadline.
- `refund()` is pull-based, clears the caller’s pledge before ETH transfer, and reverts once the target is met.
- `collect()` is beneficiary-only, checks the target on-chain, writes `collected` before transferring, and can run only once.
- ETH paths use checks-effects-interactions and `ReentrancyGuard`.

## Test

```sh
forge test
```

The suite covers late pledges, early operations, double collection/refunds, reentrancy, and bonus distribution.

## Mobile frontend

```sh
cd web
npm install
npm run dev -- --host 127.0.0.1
```

The phone UI reads the verified contract, shows progress/time/status, and keeps newly submitted pledge/refund/collect transaction links in browser-local activity. `web/.env` is ignored and holds the local `VITE_CONTRACT_ADDRESS`.

## Re-deploy

```sh
cp .env.example .env
# set PRIVATE_KEY, SEPOLIA_RPC_URL, TARGET (wei), DEADLINE (future Unix time), BENEFICIARY
forge create src/AssuranceCampaign.sol:AssuranceCampaign \
  --rpc-url "$SEPOLIA_RPC_URL" --private-key "$PRIVATE_KEY" --broadcast \
  --gas-limit 15000000 \
  --constructor-args "$TARGET" "$DEADLINE" "$BENEFICIARY"
```

Never commit `.env` or `web/.env`.
