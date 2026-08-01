# Backend Kod Kuralları

**Kapsam:** `src/backend/**`, `src/api/**`, `src/services/**`, `src/domain/**`

---

## Katmanlar

```
domain          → hiçbir şeye bağımlı değil (framework, ORM, HTTP bilmez)
application     → domain'e bağımlı (kullanım senaryoları, orkestrasyon)
infrastructure  → application + domain'e bağımlı (DB, HTTP, kuyruk, dış servis)
interface       → HTTP/CLI/kuyruk giriş noktaları
```

Ters yön bağımlılık **yasak**. İş kuralı `domain`'de yaşar — controller'da,
ORM modelinde veya SQL'de değil.

## Sözleşme

- Yanıt gövdesi ve durum kodları `docs/api/openapi.yaml` ile **birebir** aynı
- Sözleşme yanlışsa değiştirme → `solution-architect`'e escalate et
- Yanıt zarfı tutarlı: `{data, meta}` — endpoint'e göre değişmez

## Güvenlik (her endpoint'te)

- **Varsayılan reddet.** Yetkilendirme her giriş noktasında açıkça yazılır
- **Kaynak sahipliği kontrolü zorunlu** (IDOR) — "bu kaydı bu kullanıcı görebilir mi"
- Girdi doğrulama sınırda (şema), iş doğrulaması domain'de
- Parametreli sorgu — string birleştirme ile SQL **yasak**
- Hata yanıtında iç detay yok: stack trace, SQL, dosya yolu, sürüm bilgisi sızmaz
- Log'da gizli veri maskelenir: şifre, token, kart, kimlik, e-posta (kısmi)
- Dış URL alan her yer allowlist ile korunur (SSRF)

## İşlem (transaction) ve tutarlılık

- Bir kullanım senaryosu = bir işlem sınırı
- İşlem içinde dış çağrı (HTTP, e-posta, kuyruk yayını) **yapma** — sonrasına bırak
- Yazma işlemleri idempotent olmalı: idempotency key veya doğal anahtar kontrolü
- Yarış koşulu olan yerlerde iyimser kilitleme (versiyon sütunu) veya DB kısıtı

## Hata yönetimi

- Hata yanıtı RFC 7807 `problem+json`: `{type, title, status, detail, instance, errors[]}`
- Domain hatası ≠ altyapı hatası. Ayrı tipler, ayrı ele alma
- `catch` bloğu hatayı **yutmaz** — ya ele alır ya yeniden fırlatır ya loglar
- Yeniden deneme: sadece geçici hatalarda, üstel geri çekilme, üst sınır ile

## Performans

- N+1 sorgu yasak — toplu yükleme veya join
- Sınırsız sonuç kümesi yasak — her liste sayfalanır, varsayılan limit var
- Pahalı işlem senkron istekte yapılmaz — kuyruğa alınır
- Dış servis çağrılarında zaman aşımı **zorunlu**

## Veri

- Zaman UTC saklanır, sınırda dönüştürülür (`timestamptz`)
- Para: tam sayı minor-unit veya decimal — `float` **yasak**
- Şema değişikliği `sql-developer`'ın işi; buradan migration yazma

## Gözlemlenebilirlik

- Yapılandırılmış log (JSON), her satırda korelasyon kimliği
- Log seviyeleri: ERROR (aksiyon gerekir), WARN (dikkat), INFO (iş olayı), DEBUG (geliştirme)
- Kritik iş olayları metriklenir

## Test

- Her `AC-N` için en az bir test, test adında `AC-N` geçsin
- Her iş kuralı (`BR-N`) için sınır durumu testi: boş, sıfır, negatif, maksimum
- Her endpoint için uygulanabilir olanlar: 200/201, 400, 401, 403 (başkasının kaynağı),
  404, 409
- Integration testler gerçek veritabanına karşı (geçici/izole), mock'a karşı değil

## Yasaklar

- Yeni kütüphane eklemek (ADR gerekir)
- Sabit kodlanmış secret, URL, kimlik bilgisi
- `catch (e) {}` boş yakalama
- Sahipsiz `TODO`
- Yorum satırına alınmış kod
- İş kuralını iki yerde tekrarlamak
