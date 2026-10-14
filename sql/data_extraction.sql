-- Customer Churn Analysis: Data Extraction Queries
  -- Purpose: Extract customer metrics needed for churn prediction model
    -- Updated: Oct 2026

    -- =====================================================
    -- 1. CUSTOMER BASE TABLE
    -- =====================================================
    -- Extract all active customers with basic attributes

    SELECT
      customer_id,
      signup_date,
  first_payment_date,
  country,
  customer_segment,
  DATEDIFF(DAY, first_payment_date, CAST(GETDATE() AS DATE)) as days_since_first_payment,
  CASE 
        WHEN DATEDIFF(DAY, first_payment_date, CAST(GETDATE() AS DATE)) > 180 THEN 'Churned'
        ELSE 'Active'
      END as churn_flag
    INTO #customer_base
    FROM customers
    WHERE signup_date >= DATEADD(MONTH, -12, GETDATE())
      AND account_status = 'Active';

-- =====================================================
  -- 2. PAYMENT VELOCITY (Most Important Feature)
  -- =====================================================
  -- How fast customers make their first payment

  SELECT
    customer_id,
  signup_date,
  first_payment_date,
  DATEDIFF(DAY, signup_date, first_payment_date) as payment_velocity_days,
  CASE
        WHEN DATEDIFF(DAY, signup_date, first_payment_date) <= 2 THEN '0-2 days'
        WHEN DATEDIFF(DAY, signup_date, first_payment_date) <= 7 THEN '3-7 days'
        WHEN DATEDIFF(DAY, signup_date, first_payment_date) <= 14 THEN '8-14 days'
        ELSE '15+ days'
      END as payment_velocity_bucket
    INTO #payment_velocity
    FROM customers
    WHERE first_payment_date IS NOT NULL;

-- =====================================================
  -- 3. ENGAGEMENT VELOCITY
  -- =====================================================
  -- How fast customers make their second purchase

  SELECT
    customer_id,
  first_payment_date,
  MIN(payment_date) as second_payment_date,
  DATEDIFF(DAY, first_payment_date, MIN(payment_date)) as engagement_velocity_days
    INTO #engagement_velocity
    FROM payments
    WHERE payment_status = 'Successful'
      AND payment_date > first_payment_date
    GROUP BY customer_id, first_payment_date
      HAVING COUNT(*) >= 2;

-- =====================================================
  -- 4. CUSTOMER SUPPORT INTERACTIONS
  -- =====================================================
  -- How many times customer contacted support in first 30 days

  SELECT
    customer_id,
    COUNT(*) as support_interactions_first_30_days,
  MIN(support_ticket_date) as first_support_date
    INTO #support_interactions
    FROM support_tickets
    WHERE DATEDIFF(DAY, customer_signup_date, support_ticket_date) <= 30
    GROUP BY customer_id;

-- =====================================================
  -- 5. SPENDING METRICS
  -- =====================================================

  SELECT
    customer_id,
  COUNT(DISTINCT payment_id) as total_transactions,
  SUM(CAST(payment_amount AS DECIMAL(10,2))) as total_spending,
  AVG(CAST(payment_amount AS DECIMAL(10,2))) as avg_transaction_value,
  MAX(payment_date) as last_payment_date,
  DATEDIFF(DAY, MAX(payment_date), CAST(GETDATE() AS DATE)) as days_since_last_payment
    INTO #spending_metrics
    FROM payments
    WHERE payment_status = 'Successful'
    GROUP BY customer_id;

-- =====================================================
  -- COMBINE ALL FEATURES
  -- =====================================================

  SELECT
    cb.customer_id,
  cb.signup_date,
  cb.churn_flag,
  pv.payment_velocity_days,
  pv.payment_velocity_bucket,
  COALESCE(ev.engagement_velocity_days, 999) as engagement_velocity_days,
  COALESCE(si.support_interactions_first_30_days, 0) as support_interactions,
  COALESCE(sm.total_transactions, 0) as total_transactions,
  COALESCE(sm.total_spending, 0) as total_spending,
  COALESCE(sm.avg_transaction_value, 0) as avg_transaction_value,
  COALESCE(sm.days_since_last_payment, 999) as days_since_last_payment
    FROM #customer_base cb
    LEFT JOIN #payment_velocity pv ON cb.customer_id = pv.customer_id
    LEFT JOIN #engagement_velocity ev ON cb.customer_id = ev.customer_id
    LEFT JOIN #support_interactions si ON cb.customer_id = si.customer_id
    LEFT JOIN #spending_metrics sm ON cb.customer_id = sm.customer_id
    ORDER BY cb.signup_date DESC;

-- =====================================================
  -- Clean up temp tables
  -- =====================================================
  DROP TABLE IF EXISTS #customer_base;
DROP TABLE IF EXISTS #payment_velocity;
DROP TABLE IF EXISTS #engagement_velocity;
DROP TABLE IF EXISTS #support_interactions;
DROP TABLE IF EXISTS #spending_metrics;
