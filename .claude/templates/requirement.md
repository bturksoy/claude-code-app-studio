### REQ-<ALAN>-<NNN>: <başlık>

**Kaynak:** GOAL-<NN> / PRD §<bölüm> / FEAT-<NN>
**Öncelik:** Zorunlu | Yüksek | Orta | Düşük
**Aktör:** <rol>
**Tetikleyici:** <ne başlatır>

**Davranış**

<Sistemin ne yapacağı. Tek paragraf, belirsizlik yok.
"Bu tanımla iki farklı sistem yazılabilir mi?" testinden geçmeli.>

**İş kuralları**

- **BR-1:** <kural>
- **BR-2:** <kural>

**Kabul kriterleri**

- **AC-1:** <kriter>
  - Given: <önkoşul>
  - When: <eylem>
  - Then: <gözlemlenebilir, ölçülebilir sonuç>
- **AC-2:** <kriter>
  - Given: <...>
  - When: <...>
  - Then: <...>

**Hata ve sınır durumları**

*En az 2 senaryo zorunlu. Sadece mutlu yol yazılmaz.*

| Durum | Beklenen davranış | Kullanıcıya mesaj |
|---|---|---|
| <boş girdi> | | |
| <yetkisiz erişim> | | |
| <eşzamanlı işlem> | | |

**Yetki**

| Rol | Yapabilir | Yapamaz |
|---|---|---|

**Bağımlılıklar:** <REQ-* / dış sistem / Yok>
**Varsayımlar:** <varsa>
**Açık sorular:** <soru — sahip — bloke edici mi>
