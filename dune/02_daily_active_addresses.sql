-- Daily active addresses per L2 (30d) — demand-side health, not just locked capital.
-- Dune Analytics (Trino/DuneSQL).

SELECT
    blockchain,
    date_trunc('day', block_time) AS day,
    COUNT(DISTINCT "from") AS active_addresses
FROM (
    SELECT 'arbitrum' AS blockchain, "from", block_time FROM arbitrum.transactions
    UNION ALL
    SELECT 'base'     AS blockchain, "from", block_time FROM base.transactions
    UNION ALL
    SELECT 'scroll'   AS blockchain, "from", block_time FROM scroll.transactions
    UNION ALL
    SELECT 'optimism' AS blockchain, "from", block_time FROM optimism.transactions
) t
WHERE block_time >= now() - interval '30' day
GROUP BY 1, 2
ORDER BY 2 DESC, 3 DESC;
