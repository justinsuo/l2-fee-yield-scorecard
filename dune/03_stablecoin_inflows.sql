-- Net stablecoin inflows per L2 (30d) — "is real money arriving, or just incentives?"
-- Dune Analytics (Trino/DuneSQL). USDC as the bellwether; extend to USDT/DAI as needed.

WITH transfers AS (
    SELECT 'base'     AS blockchain, value/1e6 AS amt, "to" AS dst, evt_block_time AS ts
    FROM erc20_base.evt_Transfer
    WHERE contract_address = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913 -- USDC on Base
    UNION ALL
    SELECT 'arbitrum' AS blockchain, value/1e6 AS amt, "to" AS dst, evt_block_time AS ts
    FROM erc20_arbitrum.evt_Transfer
    WHERE contract_address = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831 -- USDC on Arbitrum
)
SELECT
    blockchain,
    date_trunc('week', ts) AS week,
    SUM(amt) AS usdc_volume
FROM transfers
WHERE ts >= now() - interval '30' day
GROUP BY 1, 2
ORDER BY 2 DESC, 3 DESC;
