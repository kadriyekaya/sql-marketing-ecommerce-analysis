WITH events_data AS (
  SELECT
    CONCAT(
      user_pseudo_id,

      CAST((
        SELECT value.int_value
        FROM UNNEST(event_params)
        WHERE key = 'ga_session_id'
      ) AS STRING)
    ) AS user_session_id,
    event_name,
    TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
    AND event_name IN (
      'session_start',
      'add_to_cart',
      'begin_checkout',
      'purchase'
    )
),

sessions AS (
  SELECT
    user_session_id,
    DATE(MIN(
      CASE
        WHEN event_name = 'session_start' THEN event_timestamp
      END
    )) AS event_date,
    ANY_VALUE(source) AS source,
    ANY_VALUE(medium) AS medium,
    ANY_VALUE(campaign) AS campaign,
    MAX(CASE
      WHEN event_name = 'add_to_cart' THEN 1 ELSE 0
    END) AS added_to_cart,
    MAX(CASE
      WHEN event_name = 'begin_checkout' THEN 1 ELSE 0
    END) AS begin_checkout,
    MAX(CASE
      WHEN event_name = 'purchase' THEN 1 ELSE 0
    END) AS purchase
  FROM events_data
  WHERE user_session_id IS NOT NULL
  GROUP BY user_session_id
),

events_count AS (
  SELECT
    event_date,
    source,
    medium,
    campaign,
    COUNT(*) AS user_sessions_count,
    COUNTIF(added_to_cart = 1) AS added_to_cart_count,
    COUNTIF(begin_checkout = 1) AS begin_checkout_count,
    COUNTIF(purchase = 1) AS purchase_count
  FROM sessions
  WHERE event_date IS NOT NULL
  GROUP BY
    event_date,
    source,
    medium,
    campaign
)

SELECT
  event_date,
  source,
  medium,
  campaign,
  user_sessions_count,
  SAFE_DIVIDE(
    added_to_cart_count, user_sessions_count
  ) AS visit_to_cart,
  SAFE_DIVIDE(
    begin_checkout_count, user_sessions_count
  ) AS visit_to_checkout,
  SAFE_DIVIDE(
    purchase_count, user_sessions_count
  ) AS visit_to_purchase
FROM events_count
ORDER BY event_date DESC;
