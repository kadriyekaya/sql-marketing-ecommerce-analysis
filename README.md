# SQL ile Pazarlama ve E-Ticaret Analizi

Bu projede, dijital reklam performansını ve e-ticaret kullanıcı davranışlarını SQL ile inceledim.

PostgreSQL kullanarak Facebook ve Google reklam verilerindeki harcama, kampanya değeri ve erişim değişimlerini analiz ettim. Google BigQuery üzerinde GA4 örnek e-ticaret verileriyle oturum bazlı dönüşüm oranlarını, açılış sayfası performansını ve kullanıcı etkileşimi ile satın alma arasındaki ilişkiyi değerlendirdim.

## Projenin Amacı

Reklam ve kullanıcı davranışı verilerini analiz ederek pazarlama performansını değerlendirmek ve raporlamada kullanılabilecek özet tablolar hazırlamak.

Çalışma iki bölümden oluşur:

1. PostgreSQL ile dijital reklam performansı analizi
2. BigQuery ile GA4 e-ticaret ve dönüşüm analizi

## Kullanılan Teknolojiler

- **PostgreSQL:** Reklam verilerinin birleştirilmesi ve analizi
- **DBeaver:** PostgreSQL sorgularının hazırlanması
- **Google BigQuery:** GA4 olay verilerinin sorgulanması
- **SQL:** Veri hazırlığı, toplulaştırma ve analitik hesaplamalar

## 1. Dijital Reklam Performansı Analizi

Facebook ve Google reklam verilerini birleştirerek günlük, haftalık ve aylık performans metriklerini inceledim.

Sorgular `postgresql/` klasöründe yer alır.

| SQL Dosyası | Analiz |
|---|---|
| `1-gunluk_harcama.sql` | Gün ve platform bazında ortalama, maksimum ve minimum reklam harcaması |
| `2-en_yuksek_5_romi.sql` | Toplam value / spend oranı en yüksek beş gün |
| `3-haftalik_kampanya_value.sql` | En yüksek haftalık toplam value değerine sahip kampanya |
| `4-aylik_erisim_artisi.sql` | Aylık erişim toplamlarında en büyük mutlak artışı gösteren kampanya |
| `5-kesintisiz_gosterim.sql` | En uzun kesintisiz gösterim serisine sahip reklam seti ve serinin süresi |

### Veri Kaynakları

Analizlerde aşağıdaki PostgreSQL tabloları kullanılmıştır:

- `public.facebook_ads_basic_daily`
- `public.google_ads_basic_daily`
- `public.facebook_adset`
- `public.facebook_campaign`

## 2. GA4 E-Ticaret ve Dönüşüm Analizi

GA4 örnek e-ticaret veri kümesini kullanarak kullanıcı oturumlarını, satın alma dönüşümlerini ve etkileşim metriklerini inceledim.

Sorgular `bigquery/` klasöründe yer alır.

### BI Raporları İçin Veri Hazırlığı

**Dosya:** `02_bi_data_preparation.sql`

2021 yılına ait seçili e-ticaret olaylarını; zaman, kullanıcı, oturum, ülke, cihaz ve trafik kaynağı bilgileriyle birlikte raporlamaya uygun bir sonuç tablosunda bir araya getirdim.

İncelenen olaylar:

- `session_start`
- `view_item`
- `add_to_cart`
- `begin_checkout`
- `add_shipping_info`
- `add_payment_info`
- `purchase`

### Trafik Kanallarına Göre Dönüşüm Analizi

**Dosya:** `03_channel_conversion_rates.sql`

2021 yılı verilerinde, oturum başlangıcı bulunan kullanıcı oturumlarını tarih, kaynak, aracı ve kampanya bazında grupladım.

Hesaplanan metrikler:

- Toplam oturum sayısı
- Oturumdan sepete eklemeye dönüşüm oranı
- Oturumdan ödeme başlangıcına dönüşüm oranı
- Oturumdan satın almaya dönüşüm oranı

### Açılış Sayfası Performansı

**Dosya:** `04_landing_page_conversion.sql`

2020 yılı verilerinde oturum başlangıcındaki URL’den sayfa yolunu çıkardım. Satın alma olaylarını kullanıcı ve oturum kimlikleri üzerinden eşleştirerek açılış sayfası bazında şu metrikleri hesapladım:

- Benzersiz kullanıcı oturumu sayısı
- Satın alma olayı sayısı
- Satın alma gerçekleşen oturumların toplam oturumlara oranı

### Etkileşim ve Satın Alma Korelasyonu

**Dosya:** `05_engagement_purchase_correlation.sql`

Oturum bazında toplam etkileşim süresini, etkileşimli oturum göstergesini ve satın alma durumunu hesapladım.

İncelenen ilişkiler:

- Toplam etkileşim süresi ile satın alma
- Etkileşimli oturum göstergesi ile satın alma

### Veri Kaynağı

Google BigQuery üzerinde bulunan herkese açık, anonimleştirilmiş GA4 örnek e-ticaret veri kümesi kullanılmıştır:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

## Kullanılan SQL Teknikleri

- **CTE (WITH):** Analizlerin aşamalı olarak yapılandırılması
- **JOIN:** Reklam, kampanya ve oturum verilerinin eşleştirilmesi
- **UNION ALL:** Facebook ve Google reklam verilerinin birleştirilmesi
- **Toplulaştırma:** SUM, AVG, MIN, MAX ve COUNT ile metrik hesaplanması
- **Pencere fonksiyonları:** LAG ile dönem karşılaştırması, ROW_NUMBER ile sıralama ve kesintisiz gün serilerinin belirlenmesi
- **UNNEST:** GA4 olay parametrelerinin açılması
- **Tarih ve zaman fonksiyonları:** Günlük, haftalık ve aylık analizler
- **Düzenli ifadeler:** URL üzerinden sayfa yolunun çıkarılması
- **SAFE_DIVIDE:** Sıfıra bölme durumlarının yönetilmesi
- **CORR:** Korelasyon katsayılarının hesaplanması

## Sorguların Çalıştırılması

### PostgreSQL

1. DBeaver veya uyumlu bir PostgreSQL istemcisiyle ilgili veritabanına bağlanın.
2. Veri kaynakları bölümünde belirtilen tabloların `public` şemasında bulunduğundan emin olun.
3. `postgresql/` klasöründeki sorguları ayrı ayrı çalıştırın.

PostgreSQL veri kümesi depoya dahil değildir. Bu sorguların çalıştırılması ilgili tablolara erişim gerektirir.

### BigQuery

1. Google BigQuery konsolunu açın.
2. `bigquery/` klasöründeki sorgulardan birini sorgu düzenleyicisine yapıştırın.
3. GoogleSQL kullanarak sorguyu çalıştırın.

BigQuery sorguları, herkese açık GA4 örnek veri kümesine başvurur.

## Analiz Kapsamı ve Yorumlama Notları

- Reklam sorgusunda `romi` olarak adlandırılan alan, mevcut haliyle `SUM(value) / SUM(spend)` oranını hesaplar. Bu hesaplama, maliyetin çıkarıldığı ROMI formülünden farklıdır.
- Aylık erişim artışı sorgusu, her kampanyanın mevcut ayını verideki bir önceki mevcut ayıyla karşılaştırır. Eksik aylar varsa karşılaştırma ardışık takvim aylarını temsil etmeyebilir.
- Günlük `reach` değerlerinin toplamı, ay boyunca tekilleştirilmiş kullanıcı sayısı değildir.
- Dönüşüm oranları 0–1 aralığında hesaplanır. Yüzde gösterimi için 100 ile çarpılabilir.
- Trafik kanalı analizi, ilgili olayların aynı oturumda gerçekleşmesini ölçer; olayların belirli bir sırayla gerçekleşmesini zorunlu tutmaz.
- `traffic_source` alanları kullanıcı edinim kaynağını temsil eder; oturum bazlı trafik ilişkilendirmesi olarak yorumlanmamalıdır.
- Korelasyon katsayıları değişkenler arasındaki ilişkiyi gösterir; neden-sonuç ilişkisi kanıtlamaz.
- Sorgulardaki tarih filtreleri, örnek veri kümesinde ilgili tarihler için bulunan kayıtlarla sınırlı sonuç üretir.
