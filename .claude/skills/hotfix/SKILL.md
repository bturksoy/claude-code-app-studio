---
name: hotfix
description: Üretimdeki acil sorunu hızlı yoldan çözer — etki analizi, kök neden, minimum düzeltme, regresyon testi ve hızlandırılmış yayın. Normal sprint akışını atlar ama kaliteyi atlamaz.
---

# /hotfix "<sorun>"

Koordinasyon: `delivery-manager`. **Hızlı yol, kestirme yol değil.**

---

## 1. Etki tespiti (önce bu — agent çağırmadan)

`AskUserQuestion` ile tek turda sor:
- **Şu an ne oluyor:** `Sistem tamamen çalışmıyor` / `Ana akış bozuk` /
  `Bazı kullanıcılar etkileniyor` / `Veri bozuluyor veya sızıyor`
- **Ne zaman başladı:** `Son deploy'dan sonra` / `Kademeli olarak` / `Bilinmiyor`
- **Geçici çözüm var mı:** `Var, kullanıcılara duyurulabilir` / `Yok`

**Veri bozulması veya güvenlik sızıntısı ise:** önce **durdurma** önlemini öner
(özelliği kapat, trafiği kes, erişimi kısıtla) — düzeltmeden önce kanamayı durdur.

## 2. Kök neden analizi

Son deploy'dan sonra başladıysa: değişiklikleri incele (`git log`, son sürüm notu).

İlgili geliştirici agent'ı çağır (etkilenen alana göre):

```
ACİL — üretim sorunu.
Belirti: <sorun>
Etki: <cevap>
Başlangıç: <cevap>
Son değişiklikler: <git log --oneline son 10 veya sürüm notu>
İlgili kod: <Grep ile bulunan ilgili bölüm>
Loglar/hata: <varsa kullanıcının verdiği>

Görev:
1. En olası 2 kök neden hipotezi + her birinin nasıl DOĞRULANACAĞI
2. MİNİMUM düzeltme — sorunu çözen en küçük değişiklik.
   Refactor YAPMA, iyileştirme YAPMA, sadece kanamayı durdur.
3. Bu düzeltmenin yan etkileri
4. Geri alma seçeneği düzeltmeden daha güvenli mi? Dürüst cevap ver.
5. Düzeltmeyi doğrulayacak test (önce başarısız olmalı)

Kısa ve hızlı ol.
```

## 3. Geri alma vs ileri düzeltme

Agent "geri alma daha güvenli" derse **kullanıcıya sun**:

```
Seçenek A — Geri al (rollback)
  Süre: <hızlı> | Risk: <düşük> | Yan etki: <son sürümün özellikleri kaybolur>
Seçenek B — İleri düzelt (hotfix)
  Süre: <daha uzun> | Risk: <orta> | Yan etki: <...>

Öneri: <A veya B> — <gerekçe>
```

## 4. Düzeltmeyi uygula ve doğrula

1. **Önce başarısız olan testi yaz** (regresyon testi) — istisna yok
2. Düzeltmeyi uygula
3. Testi çalıştır — artık geçmeli
4. Regresyon paketini çalıştır — başka bir şeyi kırmadığını doğrula

## 5. Hızlandırılmış inceleme

`code-reviewer` çağır — **sadece BLOKE seviyesi**:

```
<DIFF>
Görev: ACİL hotfix incelemesi. Sadece şunlara bak:
1. Düzeltme sorunu gerçekten çözüyor mu
2. Yeni hata/güvenlik açığı getiriyor mu
3. Kapsam minimum mu (gereksiz değişiklik var mı)
Sadece BLOKE seviyesi bulgu ver. Stil ve iyileştirme yazma.
"CR-CODE: ONAY|RET" ile başla.
```

## 6. Yayın

`devops-engineer` çağır:
```
Hotfix: <özet>
Değişen: <dosyalar>
Görev: Hızlandırılmış yayın planı.
1. Deploy adımları (minimum, sadece bu değişiklik)
2. Geri alma adımı (hotfix'in kendisi geri alınabilir olmalı)
3. Yayın sonrası doğrulama: ilk 15 dakikada hangi metrik izlenecek
```

Deploy'u **çalıştırma** — komutu göster, kullanıcı çalıştırsın.

## 7. Kayıt ve takip

- `docs/qa/bugs/BUG-NNN.md` — hata kaydı (geriye dönük oluştur)
- `CHANGELOG.md` — PATCH sürüm girdisi
- `docs/ops/release-<sürüm>.md` — hotfix yayın kaydı
- `product/risks.md` — bu sorunun tekrar etmemesi için ne gerekiyor

**Zorunlu takip:** Hotfix bir açığı gösterdi. Backlog'a story ekle:
- Neden testler yakalamadı → test boşluğu
- Neden inceleme yakalamadı → kontrol listesi boşluğu
- Neden izleme uyarmadı → alarm boşluğu

## 8. Kapat

```
✓ Hotfix uygulandı: <özet>
  Kök neden: <tek cümle>
  Regresyon testi: <dosya> ✓
  İnceleme: CR-CODE <verdikt>

⚠ Deploy komutu ÇALIŞTIRILMADI — hazır olduğunda sen çalıştır.

Takip story'leri backlog'a eklendi:
  - <test/inceleme/izleme boşluğu>

▶ Sonraki: yayın sonrası doğrulama → /retro (bu olay için)
```

---

## Token notu

- **3 agent çağrısı** (geliştirici + inceleyici + devops). Hızlı yol, dar kapsam.
- Etki tespiti kullanıcıya sorulur — bedava ve en kritik bilgi.
- İnceleme kapsamı bilinçli olarak dar: sadece BLOKE.
