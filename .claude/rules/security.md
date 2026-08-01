# Güvenlik Kuralları (tüm kod için geçerli)

**Kapsam:** `src/**`, `infra/**`, `db/**` — diğer kural dosyalarının üstünde geçerlidir.

---

## Kimlik ve yetki

- **Varsayılan reddet.** Her giriş noktasında yetkilendirme açıkça yazılır
- **Kaynak sahipliği kontrolü zorunlu.** "Bu kaydı bu kullanıcı görebilir/değiştirebilir mi"
  — en sık bulunan kritik açık budur (IDOR)
- Rol kontrolü ≠ sahiplik kontrolü. İkisi de gerekir
- Yetki kontrolü client'ta **tekrarlanabilir** (UX için) ama otorite backend'dir
- Parola: modern KDF (argon2id / bcrypt), uygun maliyet parametresi. MD5/SHA1 yasak
- Token: kısa ömür, yenileme rotasyonu, iptal (revoke) mekanizması
- Yönetim uçları ayrıca korunur (ek yetki + hız sınırı + denetim izi)

## Girdi

- Doğrulama **sınırda** yapılır (şema), iş doğrulaması ayrıca domain'de
- Allowlist tercih edilir, denylist değil
- Boyut sınırı her yerde: gövde, dosya, dizi uzunluğu, string uzunluğu
- Dosya yükleme: tip (magic byte), boyut, ad temizleme, izole depolama
- Yol geçişi (path traversal): kullanıcı girdisi dosya yoluna doğrudan girmez
- SSRF: dış URL alan her yer allowlist ile korunur, iç ağ adresleri engellenir

## Enjeksiyon

- SQL: **her zaman** parametreli sorgu. String birleştirme yasak
- Komut çalıştırma: kullanıcı girdisi shell'e geçmez; geçmesi gerekiyorsa
  argüman dizisi kullan, shell=false
- Şablon: otomatik kaçış açık; kapatılıyorsa gerekçe + sanitizasyon
- XSS: `innerHTML` / `dangerouslySetInnerHTML` / `v-html` kaçınılır; kullanılırsa sanitize
- Deserializasyon: güvenilmeyen veri için güvenli parser (`yaml.safe_load`, `pickle` yasak)

## Çıktı ve sızıntı

- Hata yanıtında: stack trace, SQL, dosya yolu, sürüm bilgisi, iç IP **yok**
- Log'da maskelenir: şifre, token, API anahtarı, kart numarası, kimlik numarası,
  e-posta (kısmi), sağlık verisi
- Kullanıcı numaralandırma (enumeration) engellenir: "kullanıcı yok" ve "şifre yanlış"
  aynı yanıtı döner
- Zamanlama saldırısı: kimlik doğrulama karşılaştırmaları sabit zamanlı

## Veri koruma

- Aktarımda TLS zorunlu (HSTS)
- Hassas alanlar durağanda şifreli
- Kişisel veri minimizasyonu: toplanmayan veri sızmaz
- Saklama süresi tanımlı, silme mekanizması var
- Yedekler şifreli ve erişimi kısıtlı
- Test/geliştirme ortamına üretim verisi **anonimleştirilmeden** kopyalanmaz

## Yapılandırma

- Secret repoda **yok**. `.env` versiyonlanmaz
- Güvenlik başlıkları: HSTS, CSP, X-Content-Type-Options, Referrer-Policy, X-Frame-Options
- CORS: allowlist. `*` + `credentials: true` **yasak**
- Varsayılan hesap/parola yok
- Debug modu üretimde kapalı
- Dizin listeleme kapalı

## Kriptografi

- Kendi şifreleme algoritmanı **yazma** — standart kütüphane kullan
- Rastgelelik: kriptografik güvenli kaynak (`crypto.randomBytes`, `secrets`)
  — `Math.random()` güvenlik için **yasak**
- Yasak: MD5, SHA1 (güvenlik amaçlı), DES, ECB modu, sabit IV

## Bağımlılık

- Lock dosyası mevcut ve commit'li
- Bilinen açık taraması pipeline'da
- Yeni bağımlılık ADR gerektirir (bakım durumu, lisans, boyut, güvenlik geçmişi)

## Suistimal koruması

- Kimlik doğrulama uçlarında brute-force koruması (hız sınırı + hesap kilidi)
- Pahalı uçlarda hız sınırı ve kaynak sınırı
- Denetim izi (audit log): kim, ne zaman, ne yaptı — değiştirilemez

## Yasaklar

- Secret'ı ekrana basmak, log'lamak veya commit'lemek
- Güvenlik kontrolünü "geçici olarak" kapatmak
- Yetkilendirmeyi "zaten iç ağda" diye atlamak
- Exploit kodu veya saldırı aracı üretmek
- Üretim sistemine karşı güvenlik testi çalıştırmak (izin olmadan)
