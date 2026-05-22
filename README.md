# L2 Capital-Efficiency Scorecard

**Live demo → https://justinsuo.github.io/l2-fee-yield-scorecard/**

A one-page, zero-backend scorecard that compares major L2 rollups not by the headline
everyone quotes (TVL) but by the number that actually accrues value to a token:
**fee yield** — annualized network fees ÷ TVL. It's revenue-on-assets for rollups.

Data is pulled live from the [DefiLlama](https://defillama.com) API in the browser, so the
page is always current — no server, no key, no build step.

## Why this metric
TVL measures attracted capital; it says nothing about whether that capital *does* anything.
A chain with $4B locked and thin fees is renting liquidity with incentives. A chain earning
real fees per dollar locked has product–market fit you can underwrite. Fee yield surfaces that
gap — and the gap is where L2 mispricing tends to live.

## Chains covered
General-purpose rollups, split by proof system:
- **Optimistic:** Arbitrum, Base, Optimism
- **ZK:** Scroll, Starknet, zkSync Era, Linea, Taiko

## Stack
- Single static `index.html` — vanilla JS + [Chart.js](https://www.chartjs.org/)
- DefiLlama endpoints: `/v2/chains` (TVL), `/overview/fees/<chain>` (fees)
- Annualization: 30d fees × (365/30)

## Run locally
```bash
python3 -m http.server 8000   # then open http://localhost:8000
```

## `/dune` — SQL companion
[`dune/`](dune/) holds three Dune Analytics queries (Postgres/Trino dialect) that compute the
same fee-yield idea directly from on-chain tables, for when the DefiLlama aggregate isn't
granular enough.

## Caveats
Fees are a proxy for protocol revenue, not token cash flow. Directionally right, not GAAP.
Built as a working sketch of internal diligence tooling — opinionated, not exhaustive.

— [Justin Suo](https://github.com/justinsuo)
