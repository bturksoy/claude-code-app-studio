# Frontend Kod Kuralları

**Kapsam:** `src/frontend/**`, `src/web/**`, `src/app/**`, `**/*.tsx`, `**/*.vue`, `**/*.svelte`

---

## Sözleşme ve tipler

- API tipleri `docs/api/openapi.yaml`'dan **türetilir**, elle yazılmaz
- Sözleşme yanlışsa değiştirme → `solution-architect`'e escalate et
- `any` yasak. Bilinmeyen tip için `unknown` + daraltma kullan

## Stil ve tasarım sistemi

- Ham renk/boşluk/font değeri yazma. Sadece anlamsal token
  ✗ `color: #3B82F6` · `margin: 13px`
  ✓ `color: var(--action-primary)` · `margin: var(--space-3)`
- Yeni komponent yazmadan önce `docs/design/system/components/` kontrol et
- Komponent spesifikasyonundaki **tüm durumları** implement et

## Durum eksiksizliği

Veri çeken her ekran için **dördü de zorunlu**:
```
loading  → skeleton veya spinner, layout shift olmadan
empty    → açıklayıcı mesaj + birincil eylem
error    → ne olduğu + ne yapılacağı + tekrar dene
success  → veri
```
Biri eksikse story bitmemiştir.

## Erişilebilirlik

- Semantik HTML: `<button>` yerine `<div onClick>` yasak
- Her form alanı `<label>` ile bağlı (`htmlFor`/`id`)
- Hata mesajı `aria-describedby` ile alana bağlı, `aria-live="polite"` ile duyurulur
- Klavye: tüm etkileşimli öğeler Tab ile erişilebilir, `focus-visible` görünür
- Modal: odak tuzağı, Esc ile kapanma, açılınca odak içeri, kapanınca tetikleyiciye
- Görsel: anlamlı `alt`, dekoratif için `alt=""`
- Renk tek başına bilgi taşımaz (ikon veya metin desteği)

## İş mantığı

- **Otorite backend'dir.** Fiyat, indirim, yetki, stok hesabı client'ta yapılmaz
- Client doğrulama UX içindir, güvenlik için değil — backend her zaman tekrar doğrular
- Hassas veri (token, kişisel bilgi) `localStorage`'a yazılmaz; log'lanmaz

## Durum yönetimi

- Sunucu durumu ≠ client durumu. Sunucudan gelen veriyi global store'a kopyalama;
  veri katmanı (query cache) kullan
- Türetilebilir değeri state'te tutma, render sırasında hesapla
- Global state son çare. Önce props, sonra context, en son global

## Performans

- Liste anahtarı kararlı kimlik olmalı (`item.id`), index **yasak**
- 1000+ satırlı listede sanallaştırma
- Rota bazlı kod bölme; ana paket < 200 KB gzip
- Görseller: boyut belirtilmiş (CLS önleme), lazy loading, modern format
- Memoizasyon **ölçtükten sonra**; önce profil çıkar

## Hata yönetimi

- Ağ hatası, zaman aşımı ve 4xx/5xx ayrı ayrı ele alınır
- Kullanıcıya gösterilen hata **ne yapacağını söyler**
  ✗ "Bir hata oluştu"
  ✓ "Sipariş kaydedilemedi. Bağlantını kontrol edip tekrar dene."
- Ham hata mesajı / stack trace kullanıcıya gösterilmez

## Test

- Komponent testi: render + kullanıcı etkileşimi + erişilebilirlik assert'i
- Seçici olarak `data-testid` veya erişilebilir rol/etiket kullan; CSS sınıfı kullanma
- Her `AC-N` için en az bir test, test adında `AC-N` geçsin
- Test dosyası: `tests/frontend/<alan>/<slug>.test.*`

## Yasaklar

- `console.log` üretim kodunda
- Yorum satırına alınmış kod
- Sahipsiz `TODO` (sahip ve issue referansı zorunlu)
- Yeni kütüphane eklemek (ADR gerekir)
- `dangerouslySetInnerHTML` / `v-html` (kaçınılmazsa sanitize + kod incelemesi notu)
