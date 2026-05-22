-- L2 fee yield = annualized sequencer/network fees / TVL proxy
-- Dune Analytics (Trino/DuneSQL). Adjust table names per chain spellbook coverage.
-- Idea: rank rollups by how much fee revenue each $ of bridged/locked capital produces.

WITH fees_30d AS (
    SELECT
        blockchain,
        SUM(gas_used * gas_price) / 1e18 AS native_fees_30d
    FROM (
        SELECT 'arbitrum'  AS blockchain, gas_used, gas_price, block_time FROM arbitrum.transactions
        UNION ALL
        SELECT 'base'      AS blockchain, gas_used, gas_price, block_time FROM base.transactions
        UNION ALL
        SELECT 'optimism'  AS blockchain, gas_used, gas_price, block_time FROM optimism.transactions
        UNION ALL
        SELECT 'scroll'    AS blockchain, gas_used, gas_price, block_time FROM scroll.transactions
        UNION ALL
        SELECT 'zksync'    AS blockchain, gas_used, gas_price, block_time FROM zksync.transactions
    ) t
    WHERE block_time >= now() - interval '30' day
    GROUP BY 1
)
SELECT
    blockchain,
    native_fees_30d,
    native_fees_30d * (365.0/30.0) AS native_fees_annualized
FROM fees_30d
ORDER BY native_fees_annualized DESC;
-- Multiply native_fees by the chain's gas-token USD price (prices.usd) for a $-denominated
-- yield, then divide by a TVL series (e.g. dune.<bridge>.balances) to finish the ratio.
