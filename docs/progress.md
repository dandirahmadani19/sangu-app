# progress.md — Sangu

> Dibaca `/session-start`, diupdate `/session-end`. Biar gampang lanjut walau lama tak dikerjakan.

## Status sekarang
- **Fase:** Belum mulai coding. File konteks (CLAUDE.md + docs) selesai dibuat.
- **Minggu roadmap:** belum masuk Minggu 0.
- **Health:** CI belum ada (belum init project).

## Langkah berikutnya (paling atas = paling prioritas)
1. Mulai **Minggu 0 — Setup & Harness** (lihat `docs/MVP.md`):
   - Init project Flutter + struktur folder feature-first.
   - Pasang `analysis_options.yaml`, `lefthook`, CI, slash commands.
   - Setup Firebase + App Check + `firebase_ai`, tes panggilan "hello" ke Gemini.
2. Finalisasi nama model Gemini (cek Firebase console).

## Blocker
- Belum ada.

## Keputusan pending
- Lihat "Pertanyaan terbuka" di `docs/DECISIONS.md` (hex warna, font, badge, model Gemini).

## Riwayat sesi
| Tanggal | Yang dikerjakan | Hasil |
|---|---|---|
| 2026-07-04 | Planning + buat 6 file konteks (CLAUDE.md, ARCHITECTURE, DESIGN, MVP, DECISIONS, progress) | Selesai. Semua keputusan besar terkunci di DECISIONS.md |

---
### Cara pakai file ini
- **Mulai sesi:** jalankan `/session-start` → Claude baca file ini, ringkas posisi, usul langkah.
- **Akhir sesi:** jalankan `/session-end` → Claude update "Status sekarang", "Langkah berikutnya", dan tambah baris "Riwayat sesi".
- **Isi manual** kapan saja kalau mengerjakan tanpa Claude.
