WITH events_data AS (
  SELECT
    user_pseudo_id,
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS session_id,
    event_name,
    event_timestamp,
    (
      SELECT value.string_value
      FROM UNNEST(event_params)
      WHERE key = 'page_location'
    ) AS page_location
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
    AND event_name IN ('session_start', 'purchase')
),

user_sessions AS (
  SELECT
    user_pseudo_id,
    session_id,
    CASE
      WHEN page_location IS NULL THEN NULL
      ELSE COALESCE(
        NULLIF(
          REGEXP_EXTRACT(
            page_location,
            r'^https?://[^/?#]+(/[^?#]*)'
          ),
          ''
        ),
        '/'
      )
    END AS page_path
  FROM events_data
  WHERE
    event_name = 'session_start'
    AND user_pseudo_id IS NOT NULL
    AND session_id IS NOT NULL
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY user_pseudo_id, session_id
    ORDER BY event_timestamp
  ) = 1
),

purchases AS (
  SELECT
    user_pseudo_id,
    session_id,
    COUNT(*) AS purchase_count
  FROM events_data
  WHERE
    event_name = 'purchase'
    AND user_pseudo_id IS NOT NULL
    AND session_id IS NOT NULL
  GROUP BY
    user_pseudo_id,
    session_id
)

SELECT
  s.page_path,
  COUNT(*) AS sessions_count,
  SUM(COALESCE(p.purchase_count, 0)) AS purchases_count,
  SAFE_DIVIDE(
    COUNTIF(p.purchase_count > 0),
    COUNT(*)
  ) AS cr_to_purchase
FROM user_sessions AS s
LEFT JOIN purchases AS p
  ON s.user_pseudo_id = p.user_pseudo_id
  AND s.session_id = p.session_id
GROUP BY
  s.page_path
ORDER BY
  sessions_count DESC;
