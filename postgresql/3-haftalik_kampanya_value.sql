WITH combined_ads AS (
    SELECT
        public.facebook_ads_basic_daily.ad_date,
        public.facebook_campaign.campaign_name,
        public.facebook_ads_basic_daily.value
    FROM public.facebook_ads_basic_daily
    LEFT JOIN public.facebook_campaign
        ON public.facebook_ads_basic_daily.campaign_id =
           public.facebook_campaign.campaign_id

    UNION ALL

    SELECT
        public.google_ads_basic_daily.ad_date,
        public.google_ads_basic_daily.campaign_name,
        public.google_ads_basic_daily.value
    FROM public.google_ads_basic_daily
)
SELECT
    DATE_TRUNC('week', ad_date)::date AS week_start,
    campaign_name,
    SUM(value) AS weekly_value
FROM combined_ads
GROUP BY
    DATE_TRUNC('week', ad_date)::date,
    campaign_name
ORDER BY
    weekly_value DESC NULLS LAST
LIMIT 1;