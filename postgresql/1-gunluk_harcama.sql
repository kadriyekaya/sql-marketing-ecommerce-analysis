WITH combined_ads AS (
    SELECT
        public.facebook_ads_basic_daily.ad_date,
        'Facebook' AS media_source,
        public.facebook_ads_basic_daily.spend
    FROM public.facebook_ads_basic_daily
    LEFT JOIN public.facebook_adset
        ON public.facebook_ads_basic_daily.adset_id =
           public.facebook_adset.adset_id
    LEFT JOIN public.facebook_campaign
        ON public.facebook_ads_basic_daily.campaign_id =
           public.facebook_campaign.campaign_id

    UNION ALL

    SELECT
        public.google_ads_basic_daily.ad_date,
        'Google' AS media_source,
        public.google_ads_basic_daily.spend
    FROM public.google_ads_basic_daily
)
SELECT
    ad_date::date AS ad_date,
    media_source,
    AVG(spend)::numeric AS avg_spend,
    MAX(spend)::numeric AS max_spend,
    MIN(spend)::numeric AS min_spend
FROM combined_ads
GROUP BY
    ad_date,
    media_source
ORDER BY
    ad_date,
    media_source;