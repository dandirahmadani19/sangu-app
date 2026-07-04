# MVP.md — Sangu

Sumber kebenaran untuk scope & roadmap. Prioritas: MoSCoW.

## Scope MoSCoW

### Must (tanpa ini bukan produk)
| Fitur | Manfaat |
|---|---|
| Catat transaksi manual (data lengkap: kategori, sub-kategori, deskripsi, merchant opsional) | Fondasi semua fitur |
| Penyimpanan lokal offline-first (Drift) | Data aman & instan tanpa internet |
| Taksonomi kategori + sub-kategori (seed, bisa ditambah) | Dasar auto-kategori & chart |
| Dashboard trust-first (saldo, insight, transaksi terakhir) | Jawab "duitku gimana" dalam 1 detik |
| **Input suara & natural language** ("isi pertalite 40rb" → form pre-filled) | Input tercepat, terasa pintar |
| **OCR foto struk** (Gemini vision → JSON → konfirmasi) | Pilar pembeda, kurangi friksi |
| **Share-sheet dari mana saja** (struk email/e-wallet → Sangu) | Nilai jual utama, tanpa server |
| **AI weekly insight + rapikan kategori** (Firebase AI Logic) | Centerpiece portfolio AI-native |
| Gamifikasi ringan (streak, 3-5 badge, progress ring budget) | Bentuk kebiasaan, app lengket |
| Budget bulanan sederhana (total) | Bikin progress & microinteraction bermakna |

### Should
- Budget per kategori.
- Chart analitik (pie per kategori, tren bulanan) — `fl_chart`.
- Export CSV.

### Could
- Deteksi clipboard (nominal disalin → quick-add).
- Widget home screen quick-add.
- Reminder notifikasi streak.
- Multi-dompet eksplisit.

### Won't (v1)
- Auto-scan email otomatis (butuh OAuth/verifikasi Google/server).
- Baca SMS/notifikasi bank (dibatasi Play Store).
- Leaderboard sosial / perbandingan publik.
- Sync antar-device, akun keluarga, tracking investasi, versi web/desktop.
- AI on-device (masa depan).

## Metode input (rekap)
Share-sheet (Must) · Foto struk (Must) · Suara + natural language (Must) · Deteksi clipboard (Could) · Widget (Could).

---

## Roadmap 6 minggu (solo, part-time malam/weekend)

> Estimasi longgar. Kalau mepet, geser Should/Could, jangan korbankan Must.

### Minggu 0 — Setup & Harness (fondasi)
- Init project Flutter, struktur folder feature-first.
- Pasang harness: `analysis_options.yaml`, `lefthook`, CI GitHub Actions, slash commands (lihat ARCHITECTURE.md).
- Setup Firebase project + App Check + `firebase_ai`.
- Pasang dependency inti (riverpod, drift, freezed, go_router, dio).
- **Verify:** `flutter analyze` bersih, CI hijau, panggilan Gemini "hello" berhasil.

### Minggu 1 — Data & transaksi manual
- Skema Drift (Transaction, Category, SubCategory) + seed taksonomi.
- Repository + Riverpod provider.
- Form input manual lengkap + list transaksi.
- **Verify:** bisa tambah/edit/hapus transaksi, data persist setelah restart.

### Minggu 2 — Dashboard & budget & gamifikasi dasar
- Home trust-first (saldo, transaksi terakhir).
- Budget bulanan + progress ring.
- Streak counter + badge dasar.
- **Verify:** saldo & progress akurat, streak naik saat catat harian.

### Minggu 3 — Input pintar (suara + natural language)
- Integrasi `speech_to_text` + parse Gemini → form pre-filled.
- Aturan kata kunci lokal untuk auto-kategori instan (fallback offline).
- **Verify:** ucapan "isi pertalite 40rb" mengisi form dengan benar.

### Minggu 4 — OCR & share-sheet
- Kamera + `google_mlkit_text_recognition` + Gemini vision → JSON.
- `receive_sharing_intent`: terima struk dari app lain → parse → form.
- Antrian AI offline (`pending_ai_jobs`).
- **Verify:** foto struk & share dari email menghasilkan transaksi benar.

### Minggu 5 — AI weekly insight
- Agregasi mingguan → Gemini (schema B) → kartu insight + rapikan kategori.
- Tampilkan insight di dashboard.
- **Verify:** insight muncul, kategori uncategorized ikut dirapikan.

### Minggu 6 — Polish, Should items, rilis
- Chart analitik + export CSV (bila sempat).
- Dark mode final, microinteraction, aksesibilitas (audit WCAG).
- Siapkan store listing / APK / TestFlight.
- **Verify:** audit aksesibilitas lolos, app stabil dipakai harian.

---

## Scope testing (realistis untuk MVP)
- **Unit test:** logika penting saja — perhitungan saldo/budget, mapper parse AI → model, aturan kategori lokal.
- **Widget test:** form transaksi (validasi input).
- **Tidak** kejar 100% coverage. Fokus ke jalur yang gampang salah & sering dipakai.
- CI menjalankan semua test sebagai gate.
