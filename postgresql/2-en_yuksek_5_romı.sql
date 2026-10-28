WITH combined_ads AS (
    SELECT
        ad_date,
        spend,
        value
    FROM public.facebook_ads_basic_daily

    UNION ALL

    SELECT
        ad_date,
        spend,
        value
    FROM public.google_ads_basic_daily
)
SELECT
    ad_date,
    CASE
        WHEN SUM(spend) = 0 THEN NULL
        ELSE 1.00 * COALESCE(SUM(value), 0) / SUM(spend)
    END AS romi
FROM combined_ads
GROUP BY ad_date
ORDER BY
    romi DESC NULLS LAST,
    ad_date DESC
LIMIT 5;