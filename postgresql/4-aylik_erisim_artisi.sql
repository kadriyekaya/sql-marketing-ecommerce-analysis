WITH combined_ads AS (
    SELECT
        public.facebook_ads_basic_daily.ad_date,
        public.facebook_campaign.campaign_name,
        public.facebook_ads_basic_daily.reach
    FROM public.facebook_ads_basic_daily
    LEFT JOIN public.facebook_campaign
        ON public.facebook_ads_basic_daily.campaign_id =
           public.facebook_campaign.campaign_id

    UNION ALL

    SELECT
        public.google_ads_basic_daily.ad_date,
        public.google_ads_basic_daily.campaign_name,
        public.google_ads_basic_daily.reach
    FROM public.google_ads_basic_daily
),
monthly_totals AS (
    SELECT
        DATE_TRUNC('month', ad_date)::date AS ad_month,
        campaign_name,
        SUM(reach) AS monthly_reach
    FROM combined_ads
    GROUP BY
        DATE_TRUNC('month', ad_date)::date,
        campaign_name
),
monthly_changes AS (
    SELECT
        ad_month,
        campaign_name,
        monthly_reach,
        monthly_reach - LAG(monthly_reach) OVER (
            PARTITION BY campaign_name
            ORDER BY ad_month
        ) AS monthly_growth
    FROM monthly_totals
)
SELECT
    TO_CHAR(ad_month, 'YYYY-MM') AS ad_month,
    campaign_name,
    monthly_reach,
    monthly_growth
FROM monthly_changes
ORDER BY
    monthly_growth DESC NULLS LAST
LIMIT 1;