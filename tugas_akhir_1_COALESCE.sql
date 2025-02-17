UPDATE tugas_akhir_1.payment
SET buyer_username = COALESCE(buyer_username, 'Unknown Buyer'),
    price = COALESCE(price, 0)
WHERE buyer_username IS NULL
    OR price IS NULL;


UPDATE tugas_akhir_1.payment
SET buyer_username = COALESCE(
                                  (SELECT buyer_username
                                   FROM tugas_akhir_1.payment
                                   WHERE payment_id = '4'
                                   ORDER BY effective DESC, asserted DESC -- Ensures latest update is used

                                   LIMIT 1), 'Unknown Buyer')
WHERE payment_id = '4';


UPDATE tugas_akhir_1.payment
SET price = COALESCE(price,
                         (SELECT price
                          FROM tugas_akhir_1.payment
                          WHERE payment_id = '4'
                          ORDER BY effective DESC, asserted DESC
                          LIMIT 1))
WHERE payment_id = '4';


UPDATE tugas_akhir_1.payment
SET effective = COALESCE(effective,
                             (SELECT effective
                              FROM tugas_akhir_1.payment
                              WHERE payment_id = '5'
                              ORDER BY effective DESC, asserted DESC
                              LIMIT 1), now())
WHERE payment_id = '5';


SELECT DISTINCT ON (payment_id) payment_id,
                   book_id,
                   COALESCE(buyer_username, 'Unknown Buyer') AS latest_buyer_username,
                   COALESCE(price, 0) AS latest_price,
                   COALESCE(effective, now()) AS latest_effective_time
FROM tugas_akhir_1.payment
ORDER BY payment_id,
         effective DESC,
         asserted DESC;

