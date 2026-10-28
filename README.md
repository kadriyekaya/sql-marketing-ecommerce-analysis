# SQL ile Pazarlama ve E-Ticaret Analizi

Bu proje, PostgreSQL ile Facebook ve Google reklam performansını,
BigQuery ile Google Analytics 4 e-ticaret verilerini analiz eden SQL sorgularını içerir.

## Kullanılan Araçlar

- PostgreSQL
- DBeaver
- Google BigQuery
- Google Analytics 4 örnek veri kümesi

## 1. Reklam Performansı Analizi

`postgresql` klasöründeki beş sorgu şu soruları ele alır:

1. Google ve Facebook için günlük ortalama, maksimum ve minimum harcamalar nelerdir?
2. Toplam value / spend oranı en yüksek beş gün hangileridir?
3. En yüksek haftalık toplam value değerine sahip kampanya hangisidir?
4. Aylık erişimde en büyük mutlak artışı gösteren kampanya hangisidir?
5. En uzun süre kesintisiz gösterim alan reklam seti hangisidir?

Kullanılan tablolar:
- facebook_ads_basic_daily
- google_ads_basic_daily
- facebook_adset
- facebook_campaign

Sorgular, bu tabloların bulunduğu PostgreSQL veritabanında çalıştırılmak üzere hazırlanmıştır.

## 2. GA4 E-Ticaret Analizi

`bigquery` klasöründeki sorgular:

- **Görev 2:** 2021 yılına ait seçili e-ticaret olaylarının BI raporları için hazırlanması.
- **Görev 3:** Tarih ve trafik kaynağı bazında oturumdan sepete, ödeme başlangıcına ve satın almaya dönüşüm oranlarının hesaplanması.
- **Görev 4:** 2020 yılı verileriyle açılış sayfalarının satın alma dönüşümlerinin karşılaştırılması.
- **Görev 5:** Oturum etkileşimi ve etkileşim süresi ile satın alma arasındaki korelasyonun hesaplanması.

Veri kaynağı:
`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

Sorgular Google BigQuery üzerinde çalıştırılmak üzere hazırlanmıştır.

## Kullanılan SQL Teknikleri

- CTE (WITH)
- JOIN ve UNION ALL
- Toplulaştırma ve koşullu hesaplamalar
- Tarih ve zaman fonksiyonları
- LAG ve ROW_NUMBER
- UNNEST ile iç içe alanların açılması
- Düzenli ifadelerle URL yolu çıkarımı
- SAFE_DIVIDE
- CORR

## Analiz Notları

- Reklam sorgusundaki `romi` alanı mevcut haliyle `value / spend` oranını hesaplar.
- Dönüşüm oranları 0–1 aralığında verilir; yüzde gösterimi için 100 ile çarpılabilir.
- Görev 3, olayların oturum içinde gerçekleşmesini ölçer; olay sırasını zorunlu tutmaz.
- Günlük reach değerlerinin toplamı, dönem boyunca tekilleştirilmiş kullanıcı sayısı değildir.
- Korelasyon sonuçları neden-sonuç ilişkisi göstermez.
