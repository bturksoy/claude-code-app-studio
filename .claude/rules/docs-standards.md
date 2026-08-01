# Dokümantasyon Standartları

**Kapsam:** `docs/**`, `product/**`, `*.md`

---

## Genel

- **Tek gerçek kaynağı.** Bir bilgi tek dosyada yaşar. Kopya yerine link ver.
  İstisna: story dosyalarındaki bilinçli kopyalar (görev paketi ilkesi).
- **Kaynaksız iddia yazma.** Bir davranış anlatılıyorsa kaynağı belirtilir
  (`REQ-*`, `ADR-*`, story). Kaynak yoksa `AÇIK:` işaretlenir.
- **Aktif çatı, kısa cümle, tek fikir.**
- **Tarih formatı:** `YYYY-MM-DD`. Göreli tarih yazma ("geçen hafta" yasak).

## Kimlikler

Her doküman öğesi bir kimlik taşır ve zincire bağlanır:

```
GOAL-NN → REQ-<ALAN>-NNN → story-NNN → TC-<REQ>-NN
                ↓
            ADR-NNNN
```

Kimliksiz gereksinim, hedefe bağlanmayan story yazılmaz.

## Boyut limitleri

| Dosya | Limit | Aşarsa |
|---|---|---|
| `docs/CONTEXT.md` | 200 satır | `/context-compact` |
| `docs/DECISIONS.md` | 300 satır | arşivle |
| `product/risks.md` | 100 satır | kapananları arşivle |
| `CLAUDE.md` | 150 satır | detayı `.claude/docs/`'a taşı |

## Index dosyaları

Her koleksiyon dizininde `index.md` bulunur ve güncel tutulur:
`adr/`, `epics/`, `sprints/`, `test-cases/`, `bugs/`

Index, agent'ların tek dosya okuyup koleksiyona bakmasını sağlar.

## Diyagramlar

- Mermaid kullan — metin, versiyonlanabilir, ucuz
- Görsel dosya (png/jpg) yerine metin spesifikasyonu tercih et
- Her diyagramın altında **tek cümlelik açıklama** bulunur

## Tablolar

- Başlık satırı zorunlu
- Boş hücre yerine `—` yaz
- 6 sütunu geçen tablo bölünür

## Kod blokları

- Dil etiketi zorunlu (` ```sql `, ` ```ts `)
- Çalıştırılabilir komutlar ` ```bash ` etiketli ve **tek komut** içerir

## Değişmezlik

- `docs/DECISIONS.md` ve `CHANGELOG.md` **append-only** — eski girdiler düzenlenmez
- Bir ADR değiştirildiğinde eski ADR silinmez; durumu `Değiştirildi (ADR-MMMM ile)` olur
- Kapatılan hata, risk ve story silinmez; `archive/` veya `deferred/` altına taşınır

## Yasaklar

- Pazarlama dili ("güçlü", "sorunsuz", "devrim niteliğinde")
- Aynı bilgiyi iki dosyada tam metin olarak tutmak
- Ekran görüntüsü ile metin spesifikasyonunu değiştirmek
- Kaynağı belirtilmemiş sayısal iddia
- Ölçülemeyen kabul kriteri veya NFR
