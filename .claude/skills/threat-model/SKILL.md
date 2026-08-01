---
name: threat-model
description: STRIDE tabanlı güvenlik tehdit modeli üretir. Varlıkları, güven sınırlarını ve tehditleri belirler, her tehdide önlem ve doğrulama yöntemi atar. SEC-THREAT kapısını işletir.
---

# /threat-model

Sahip: `security-engineer`. Çıktı: `docs/security/threat-model.md`

Ön koşul: `ARCHITECTURE.md` (+ varsa `openapi.yaml`).
`full` modda zorunlu; `lean` modda kullanıcı isterse; `solo` modda atlanır.

---

## 1. Girdi

- Mimari: konteynerler, güven sınırları, dış sistemler
- API: endpoint listesi + auth şemaları (tam YAML değil)
- Veri: hangi varlıklar hassas (kişisel veri, finansal, sağlık, kimlik bilgisi)
- Uyumluluk gereksinimleri (KVKK/GDPR/PCI vb. — `NFR.md`'den)
- Kullanıcı rolleri ve yetki matrisi

## 2. `security-engineer` çağır

```
<BAĞLAM BLOĞU>

Görev: STRIDE tehdit modeli üret.

1. Varlık envanteri
   | Varlık | Hassasiyet | Nerede saklanır | Kim erişir | Yasal statü |

2. Güven sınırları (Mermaid) — her sınır geçişi bir kontrol noktasıdır

3. Tehdit tablosu — her güven sınırı için STRIDE'ın 6 kategorisini uygula:
   Spoofing, Tampering, Repudiation, Information disclosure,
   Denial of service, Elevation of privilege
   | # | Sınır | STRIDE | Tehdit senaryosu | Etki | Olasılık | Risk | Önlem | Doğrulama |
   Tehdit senaryosu SOMUT olmalı: "saldırgan X yaparsa Y elde eder"

4. Her YÜKSEK/KRİTİK risk için:
   - Zorunlu önlem (uygulanabilir, kod/config düzeyinde)
   - Doğrulama yöntemi (test kimliği veya kontrol adımı)
   - Hangi REQ/ADR'ye bağlanacağı

5. Kabul edilmesi önerilen riskler (önlem maliyeti > risk) — gerekçeli

6. Güvenlik gereksinim önerileri: NFR.md'ye eklenmesi gereken maddeler

Kurallar:
- Saldırı aracı veya exploit kodu ÜRETME — senaryo tarif et
- Sömürü senaryosu yazamadığın şey bulgu değildir, teorik endişedir
- Bu projenin ölçeğine uygun ol; 10 kullanıcılı iç araca APT modeli yazma

Yanıtına "SEC-THREAT: ONAY|ŞARTLI|RET" satırıyla başla.
```

## 3. Sun

```
## Tehdit Modeli
Varlık: <N> | Güven sınırı: <M> | Tehdit: <K>

Risk dağılımı: Kritik <a> | Yüksek <b> | Orta <c> | Düşük <d>

Zorunlu önlemler (Kritik/Yüksek):
| # | Tehdit | Önlem | Nereye bağlanacak |

Kabul önerilen riskler: <liste>
NFR önerileri: <liste>

Kapı: SEC-THREAT <verdikt>
```

`AskUserQuestion` ile kabul edilecek riskleri kullanıcıya onaylat — bu bir
**iş kararıdır**, güvenlik mühendisi tek başına veremez.

## 4. Yaz

- `docs/security/threat-model.md`
- Zorunlu önlemleri **NFR olarak** `business-analyst`'e öner (raporda listele —
  sen `NFR.md`'yi değiştirmezsin)
- Kabul edilen riskleri `product/risks.md`'ye ekle (sahip + gözden geçirme tarihi)
- `.state/gates.jsonl`

## 5. Kapat

```
✓ Tehdit modeli → docs/security/threat-model.md
  <K> tehdit | <a> kritik/yüksek önlem gerekiyor

⚠ Şu önlemler story'lere dönüşmeli: <liste>
   /epics çalıştırırken bunları dahil et.

▶ Sonraki: /epics
```

---

## Token notu

- **1 agent çağrısı.**
- Proje ölçeğine uygun derinlik — küçük projede 60 tehdit üretme, 15 yeter.
- API'nin tamamını gömme; endpoint listesi + auth şeması yeter.
