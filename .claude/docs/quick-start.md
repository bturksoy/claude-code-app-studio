# Hızlı Başlangıç

## 1. Projeyi başlat

```bash
git init
```

Claude Code'da:

```
/kickoff "Küçük işletmeler için stok ve fatura takip uygulaması"
```

CEO iş hedeflerini soracak, proje ölçeğini seçeceksin, kadro ve inceleme modu
belirlenecek. ~5 dakika.

## 2. Projeyi detaylandır

```
/discovery
```

Product Owner ve Business Analyst **paralel** çalışır, farklı merceklerden bakar.
Anlaşmazlıkları ve açık soruları sana karar olarak sunar.

```
/prd            → ürün gereksinim dokümanı
/requirements   → test edilebilir gereksinimler (REQ-*, NFR-*)
/roadmap        → fazlandırma: MVP → v1 → v2
```

## 3. Tasarla

```
/architecture   → CTO yığını seçer, mimar sistemi tasarlar
/adr "<konu>"   → kritik kararları kayda geçir
/data-model     → ER + şema + migration
/api-contract   → OpenAPI sözleşmesi
/ux-flow        → akışlar ve ekranlar
/design-system  → token + komponentler
```

## 4. Planla ve geliştir

```
/epics                  → değer bazlı epic kırılımı
/stories <epic>         → görev paketleri (en kritik adım)
/sprint-plan            → görev dağılımı, paralel bantlar
/dev-task <story>       → tek story implement et
/team-feature <epic>    → tüm ekiple dikey dilim
```

## 5. Kalite ve yayın

```
/code-review
/qa-run
/dod-check
/security-review
/release v1.0.0
/retro
```

---

## Her oturuma böyle başla

```
/status
```

Nerede kaldığını, neyin bloke olduğunu ve tek bir sonraki adımı söyler.
Agent çağırmaz — bedava.

---

## İlk sprintte ne bekle

| Adım | Süre | Agent çağrısı |
|---|---|---|
| `/kickoff` | ~5 dk | 1 |
| `/discovery` | ~5 dk | 2 |
| `/prd` | ~5 dk | 1 |
| `/requirements` | ~10 dk | 1-2 |
| `/roadmap` | ~5 dk | 1-2 |
| `/architecture` | ~10 dk | 2-3 |
| `/epics` + `/stories` | ~15 dk | 4-5 |
| `/sprint-plan` | ~5 dk | 1 |

Faz 1-3 toplamı: yaklaşık **15 agent çağrısı**.
Geliştirme fazında story başına 1-2 çağrı.

---

## Maliyeti düşürmek istersen

1. `product/review-mode.txt` → `solo` yaz (kapılar kapanır)
2. `/kickoff`'ta ölçek olarak `Prototip` seç (kadro daralır)
3. Fazları küçük tut — `/requirements` ve `/stories` faz bazlı çalıştır
4. Sprint sonlarında `/context-compact` çalıştır
5. Bir oturumda bir faz yürüt, sonra yeni oturuma geç

## Kaliteyi artırmak istersen

1. `product/review-mode.txt` → `full`
2. `/threat-model`, `/perf-check`, `/security-review` ekle
3. `/roundtable` ile zor kararları çok mercekten geçir
4. `/dod-check` çıktısında kanıtı gerçekten oku

---

## Sorun giderme

| Belirti | Neden | Çözüm |
|---|---|---|
| Geliştirici agent çok dosya okuyor | Story görev paketi eksik | `/assign <story>` ile tamamla |
| Aynı story'de 3+ tur oluyor | Kabul kriterleri belirsiz | `/requirements` ile netleştir |
| Sprint sürekli kayıyor | Bağımlılık zinciri uzun | `/sprint-plan` bantları gözden geçir |
| Token tüketimi yüksek | Kapı modu `full` | `lean`'e düşür |
| Agent kapsam dışına çıkıyor | Story'de "Kapsam DIŞI" boş | `/stories` tekrar çalıştır |
| Ne yapacağımı bilmiyorum | — | `/status` |
