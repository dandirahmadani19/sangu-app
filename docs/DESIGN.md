# DESIGN.md — Sangu

## Identitas
- **Nama:** Sangu (bekal/uang saku). Hangat, lokal, sesuai filosofi slow-living.
- **Arah visual:** warm-earthy-editorial. Bukan biru fintech dingin. Nuansa tenang, dewasa, tepercaya.

## Fondasi teknis
- **Material 3** sebagai dasar (first-class & default di Flutter, stabil). `ColorScheme.fromSeed`, bukan ungu default.
- **Material 3 Expressive kita implement manual** (spring motion, shape organik, tipografi editorial, haptics), karena Flutter core belum menyediakannya native. Pakai skill `Mic-360/material3-expressive-flutter` sebagai panduan pola. Opsional: skill `hamen/material-3-skill` untuk audit aksesibilitas WCAG AA (jadikan gate pre-PR).

## Hierarki visual trust-first
Urutan layar utama (home), dari paling menonjol:
1. **Saldo** (hero, angka besar, kontras tinggi).
2. **Kartu AI insight** (ringkasan minggu ini).
3. **Item butuh perhatian** (mendekati/lewat budget).
4. **Transaksi terakhir**.
5. **Streak & progress** (ringan, di bawah).

Prinsip: info paling penting terbaca tanpa scroll. Angka uang selalu pakai **tabular figures** (lebar digit seragam) biar rapi.

## Microinteraction (feedback fungsional, bukan hiasan)
| Momen | Feedback |
|---|---|
| Transaksi tersimpan | animasi konfirmasi singkat + haptic ringan |
| Scan/parse struk | progress → reveal hasil form pre-filled |
| Target budget tercapai | animasi rayakan + haptic sukses |
| Budget terlewat | feedback peringatan (warna + ikon), haptic beda |
| Streak bertambah | angka streak "naik" dengan spring |

Semua motion pakai **spring (fisika)**, bukan durasi tetap. Library: `flutter_animate` + `HapticFeedback`.

## Dark mode (standar, bukan opsional)
- Light & dark didesain berbarengan lewat `ColorScheme`. Tidak ada warna hardcode di widget.
- Surface gelap pakai abu hangat (bukan hitam murni) supaya nyaman & sesuai nuansa earthy.

## Aksesibilitas
- Kontras minimal **WCAG AA** (4.5:1 teks normal).
- **Untung/rugi jangan hanya warna merah/hijau.** Pakai *dual-encoding*: ikon (↑/↓) + tanda (+/−) + warna. Teman-teman buta warna tetap paham.
- Target sentuh minimal 48dp. Dukung teks besar (jangan kunci font size).

## Design tokens

### Warna (arah, finalisasi hex saat implementasi)
| Token | Light | Dark | Peran |
|---|---|---|---|
| primary | hijau tua hangat | hijau lembut | aksi utama, brand |
| secondary | terracotta | terracotta lembut | aksen |
| surface | krem/off-white | abu hangat gelap | latar kartu |
| positive | hijau (+ ikon ↑) | hijau terang | pemasukan |
| negative | merah bata (+ ikon ↓) | merah lembut | pengeluaran |
| warning | amber | amber | mendekati budget |

Catatan: positive/negative **selalu** dipasangkan ikon + tanda, tidak berdiri sendiri sebagai warna.

### Tipografi (editorial)
- Headline hero (saldo): besar, tegas, tabular figures.
- Body: font readable, ukuran nyaman.
- Satu skala tipografi konsisten via `TextTheme`.

### Motion
- Spring "spatial" untuk perpindahan posisi/layout.
- Spring "effects" untuk fade/scale.
- Hindari durasi tetap; pakai token motion yang sama di seluruh app.

### Shape
- Squircle/rounded organik untuk kartu & tombol utama (nuansa M3E).
- Konsisten via `ThemeData.shapeTheme`.
