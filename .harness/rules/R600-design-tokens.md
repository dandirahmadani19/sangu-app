# R600 — Design Tokens

Token desain untuk Sangu. Fondasi: **Material 3** + **M3E manual**
(ADR-010). Nuansa **warm-earthy-editorial**, bukan biru fintech dingin.
Rujukan lengkap: `docs/DESIGN.md`.

## R600.1 — Lokasi token

Semua token desain (warna, tipografi, spacing, radius, motion) MUST
tinggal di `lib/core/theme/`. MUST NOT menyebar nilai magic di widget.

## R600.2 — `ColorScheme.fromSeed`, tanpa warna hardcode

- Warna MUST berasal dari `ColorScheme` (di-seed lewat
  `ColorScheme.fromSeed`), bukan ungu default Material.
- Widget MUST NOT memakai `Color(0xFF...)` hardcode. Ambil dari
  `Theme.of(context).colorScheme` atau token terpusat.

## R600.3 — Token warna semantik

Pakai peran semantik, bukan nama warna mentah (arah di `DESIGN.md`,
hex difinalisasi saat implementasi UI):

| Token | Peran |
|---|---|
| primary | aksi utama, brand (hijau tua hangat) |
| secondary | aksen (terracotta) |
| surface | latar kartu (krem / abu hangat gelap) |
| positive | pemasukan — SELALU dipasangkan ikon ↑ + tanda + (R602.2) |
| negative | pengeluaran — SELALU dipasangkan ikon ↓ + tanda − (R602.2) |
| warning | mendekati/lewat budget (amber) |

`positive`/`negative` MUST NOT berdiri sendiri sebagai warna (lihat
R602.2).

## R600.4 — Spacing, radius, elevation

- Spacing MUST dari skala token konsisten (mis. 4/8/12/16/24), bukan
  angka acak.
- Radius/shape MUST konsisten via theme (R600.6).
- Elevation SHOULD hemat; utamakan surface tint M3.

## R600.5 — Dark mode via ColorScheme

- Light & dark MUST didesain berbarengan lewat `ColorScheme`. Tidak
  ada cabang warna hardcode per mode.
- Surface gelap MUST pakai abu hangat, MUST NOT hitam murni (sesuai
  nuansa earthy).

## R600.6 — Shape organik

Kartu & tombol utama MUST pakai bentuk squircle/rounded organik (nuansa
M3E), konsisten via `ThemeData.shape`. MUST NOT mencampur banyak radius
berbeda tanpa alasan.
