WITH combined_ads AS (
    SELECT
        public.facebook_ads_basic_daily.ad_date,
        public.facebook_adset.adset_name,
        public.facebook_ads_basic_daily.impressions
    FROM public.facebook_ads_basic_daily
    LEFT JOIN public.facebook_adset
        ON public.facebook_ads_basic_daily.adset_id =
           public.facebook_adset.adset_id

    UNION ALL

    SELECT
        public.google_ads_basic_daily.ad_date,
        public.google_ads_basic_daily.adset_name,
        public.google_ads_basic_daily.impressions
    FROM public.google_ads_basic_daily
),
daily_ads AS (
    SELECT DISTINCT
        ad_date::date AS ad_date,
        adset_name
    FROM combined_ads
    WHERE impressions > 0
),
numbered_days AS (
    SELECT
        ad_date,
        adset_name,
        ad_date - INTERVAL '1 day' * (
            ROW_NUMBER() OVER (
                PARTITION BY adset_name
                ORDER BY ad_date
            )
        ) AS streak_group
    FROM daily_ads
),
streaks AS (
    SELECT
        adset_name,
        MIN(ad_date) AS streak_start,
        MAX(ad_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM numbered_days
    GROUP BY
        adset_name,
        streak_group
)
SELECT
    adset_name,
    streak_start,
    streak_end,
    streak_length
FROM streaks
ORDER BY
    streak_length DESC
LIMIT 1;