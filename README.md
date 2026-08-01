# Claude Code App Studio

Uygulama projelerini uçtan uca yürüten sanal yazılım şirketi.
CEO'dan test mühendisine 19 rol, 38 iş akışı, gerçek bir yazılım şirketinin
süreçleriyle çalışır.

---

## Ne yapar?

Bir cümlelik proje fikri verirsin:

```
/kickoff "Küçük işletmeler için stok ve fatura takip uygulaması"
```

Sistem sırayla şunları yapar:

1. **CEO + Product Owner** iş hedeflerini ve başarı metriklerini netleştirir
2. **Product Owner + Business Analyst** kafa kafaya verir (round-table), projeyi
   detaylandırır: persona, problem, kapsam, gereksinimler, kabul kriterleri
3. **Product Owner** projeyi fazlara böler (MVP → v1 → v2), yol haritası çıkarır
4. **CTO + Solution Architect** teknoloji yığınını ve mimariyi belirler, ADR yazar
5. **UX + UI Designer** akışları ve tasarım sistemini kurar
6. **Delivery Manager** epic → story kırılımı ve **görev dağılımı** yapar
7. **FE / BE / SQL / DevOps** geliştiriciler koordineli, paralel çalışır
8. **QA Lead + Test Engineer + Code Reviewer + Security** kalite kapılarını işletir
9. **DevOps + CEO** yayın kararını verir

Her adımda **sana seçenek sunulur ve onayın alınır**. Otopilot değildir.

---

## Kurulum

Bu dizin zaten hazır. Yeni bir proje için:

```bash
git init
```

Sonra Claude Code'da:

```
/start
```

`/start` mevcut durumu tespit eder ve nereden devam edeceğini söyler.

---

## Temel komutlar

| Komut | Ne yapar |
|---|---|
| `/start` | Durum tespiti + sonraki adım |
| `/help` | Tüm komutlar, faza göre |
| `/kickoff "<fikir>"` | Yeni proje başlat |
| `/onboard` | Mevcut kod tabanını sisteme al |
| `/status` | Proje durum panosu |
| `/team-feature <epic>` | Bir özelliği tüm ekiple uçtan uca yap |

Tam liste: [`.claude/docs/workflow-catalog.md`](.claude/docs/workflow-catalog.md)

---

## Roller

**Yönetim** `ceo` · `cto`
**Ürün** `product-owner` · `business-analyst` · `solution-architect` · `delivery-manager`
**Tasarım** `ux-designer` · `ui-designer`
**Geliştirme** `frontend-developer` · `backend-developer` · `sql-developer` · `data-engineer` · `devops-engineer`
**Kalite** `qa-lead` · `test-engineer` · `code-reviewer` · `security-engineer` · `performance-engineer`
**Destek** `tech-writer`

Detay: [`.claude/docs/agent-roster.md`](.claude/docs/agent-roster.md)

---

## Token maliyetini kontrol etme

Bu sistem çok-agent'lı çalışır. Maliyeti üç ayarla kontrol edersin:

**1. İnceleme modu** — `product/review-mode.txt`

| Mod | Kapılar | Ne zaman |
|---|---|---|
| `solo` | Yok | Kişisel proje, prototip |
| `lean` | Faz geçişleri (varsayılan) | Çoğu proje |
| `full` | Hepsi | Kurumsal, regüle, kritik sistem |

**2. Proje ölçeği** — `/kickoff` sırasında seçilir; kadroyu daraltır.

**3. Görev paketi disiplini** — Story dosyaları kendi kendine yeterlidir; geliştirici
agent 8 dosya yerine 1 dosya okur. En büyük tasarruf buradan gelir.

Detay: [`.claude/docs/token-budget.md`](.claude/docs/token-budget.md)

---

## Nasıl özelleştirilir?

| İstediğin | Yapacağın |
|---|---|
| Rol ekle/çıkar | `.claude/agents/` altına `.md` ekle, `agent-roster.md`'yi güncelle |
| Yeni iş akışı | `.claude/skills/<ad>/SKILL.md` oluştur |
| Kodlama standardı | `.claude/rules/` altındaki ilgili dosyayı düzenle |
| Doküman şablonu | `.claude/templates/` |
| Otomatik denetim | `.claude/hooks/` + `settings.json` |

---

## Tasarım ilkeleri

- **Tek gerçek kaynağı** — Her bilgi tek dosyada yaşar, kopyalanmaz
- **İzlenebilirlik** — story → gereksinim → hedef zinciri kopmaz
- **Kanıtsız bitti yoktur** — Her story tipinin zorunlu kanıtı vardır
- **Kapsam disiplini** — Agent kendi alanı dışına çıkmaz, escalate eder
- **Kullanıcı karar verir** — Agent seçenek sunar, onay ister

---

*İlham: [claude-code-game-studios](https://github.com/donchitos/claude-code-game-studios)*
