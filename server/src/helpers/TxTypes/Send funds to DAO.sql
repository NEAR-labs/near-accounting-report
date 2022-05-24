SELECT block_timestamp,
       originated_from_transaction_hash transaction_hash,
       block_height,
       args ->> 'deposit' deposit,
    args ->> 'args_base64' args_base64
FROM receipts r
    INNER JOIN execution_outcomes e ON e.receipt_id = r.receipt_id
    INNER JOIN blocks b ON b.block_hash = r.included_in_block_hash
    INNER JOIN transaction_actions a ON a.transaction_hash = r.originated_from_transaction_hash
WHERE r.predecessor_account_id = $1
  AND r.receiver_account_id LIKE '%.sputnik-dao.near'
  AND e.status = 'SUCCESS_VALUE'
  AND a.action_kind = 'TRANSFER'
  AND b.block_timestamp > $2
ORDER BY b.block_timestamp LIMIT $3