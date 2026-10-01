-- Invariantes de dinero, puntuación y seguimiento que no formaban parte del alta de cada tabla.

ALTER TABLE bids
  ADD CONSTRAINT bids_amount_positive_check CHECK (amount > 0);

ALTER TABLE auctions
  ADD CONSTRAINT auctions_money_check CHECK (
    start_price > 0
    AND min_increment > 0
    AND current_price >= start_price
  );

ALTER TABLE auctions
  ADD CONSTRAINT auctions_schedule_check CHECK (
    initial_ends_at > starts_at
    AND ends_at >= initial_ends_at
  );

ALTER TABLE transactions
  ADD CONSTRAINT transactions_amount_positive_check CHECK (amount > 0);

ALTER TABLE lots
  ADD CONSTRAINT lots_score_range_check CHECK (
    authenticity_score IS NULL OR authenticity_score BETWEEN 0 AND 100
  );

ALTER TABLE lots
  ADD CONSTRAINT lots_suggested_price_order_check CHECK (
    suggested_price_min IS NULL
    OR suggested_price_max IS NULL
    OR (suggested_price_min >= 0 AND suggested_price_max >= suggested_price_min)
  );

ALTER TABLE audit_summaries
  ADD CONSTRAINT audit_summaries_score_range_check CHECK (score BETWEEN 0 AND 100);

ALTER TABLE audit_summaries
  ADD CONSTRAINT audit_summaries_price_order_check CHECK (
    price_min >= 0 AND price_max >= price_min
  );

ALTER TABLE follows
  ADD CONSTRAINT follows_no_self_check CHECK (follower_id <> followee_id);
