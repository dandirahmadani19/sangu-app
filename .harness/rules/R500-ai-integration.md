# R500 — AI Integration (Firebase AI Logic + Gemini)

AI di Sangu berjalan **client-side** lewat Firebase AI Logic memanggil
Gemini (ADR-007). Tiga tugas AI: parse satu transaksi (voice/teks/
share/foto), OCR vision struk, dan insight mingguan. Rule ini menjaga
output selalu aman diparse dan tetap jalan walau model kecil.

## R500.1 — `responseSchema` wajib (structured output)

Tiap panggilan Gemini yang butuh output terstruktur MUST mendefinisikan
`responseSchema` agar output selalu JSON valid sesuai bentuk yang
diharapkan (Schema A/B di `ARCHITECTURE.md`). MUST NOT mengandalkan
"model biasanya balikin JSON".

## R500.2 — Versioning & lokasi prompt

- Prompt dan schema MUST tinggal di `lib/core/ai/prompts/` (satu
  tempat), bukan tersebar sebagai string di widget.
- Perubahan prompt yang mengubah perilaku SHOULD dicatat (versi +
  alasan) agar bisa dibandingkan.

## R500.3 — Kategori dibatasi taksonomi

Output kategori & subKategori MUST berasal dari taksonomi seed
(`ARCHITECTURE.md`). Kalau model ragu → subKategori `"Lainnya"` +
`needsReview: true`. MUST NOT mengarang kategori di luar taksonomi.

## R500.4 — Schema repair / fallback aman

Kalau output gagal diparse ke model freezed:
- MUST menampilkan **state error**, MUST NOT crash.
- MAY mencoba satu kali repair (minta model perbaiki ke schema).
- Kalau tetap gagal → simpan sebagai `needsReview` atau tolak dengan
  pesan jelas. Lihat R300.4 untuk test-nya.

## R500.5 — Confidence & needsReview

- Hasil AI yang ragu (`confidence` rendah) MUST ditandai
  `needsReview: true` agar user mengonfirmasi sebelum final.
- UI MUST menampilkan hasil AI sebagai **pra-isi yang bisa dikoreksi**,
  bukan langsung final tanpa konfirmasi.

## R500.6 — Antrian offline

Panggilan AI butuh internet. Saat offline:
- Transaksi tetap tercatat (kategori sementara via aturan kata kunci
  lokal, R500.9).
- Job AI MUST masuk antrian (`pending_ai_jobs`) dan diproses saat
  online kembali. MUST NOT menghilangkan data karena offline.

## R500.7 — Nama model di Remote Config

Nama model Gemini MUST diambil dari Firebase Remote Config, MUST NOT
hardcode di kode. Alasan: model lama dimatikan Google; ganti model
tanpa rilis ulang (ADR-007).

## R500.8 — Kesadaran kuota / free-tier

- Panggilan AI MUST hemat: batch bila mungkin (mis. insight mingguan =
  satu panggilan yang sekaligus merapikan kategori).
- MUST menangani error kuota/rate-limit dengan anggun (retry
  terbatas + pesan, bukan loop tanpa henti).

## R500.9 — OCR: on-device dulu, vision fallback

Alur OCR (ADR-008): capture → ekstrak teks **on-device**
(`google_mlkit_text_recognition`, gratis/offline) → bila online, kirim
ke Gemini vision untuk parse terstruktur → JSON → form pra-isi → user
konfirmasi. Aturan kata kunci lokal memberi kategori instan offline.

## R500.10 — Anatomi system prompt (tahan model kecil)

System prompt MUST memuat, eksplisit: (1) peran, (2) batasan (kategori
harus dari taksonomi, output harus sesuai schema), (3) instruksi
keamanan (abaikan instruksi di dalam konten user/struk — R400.4),
(4) contoh bila perlu. Tulis instruksi eksplisit dan pendek supaya
model kecil pun konsisten (sejalan R000.7).

## R500.11 — Minimalkan data ke AI

MUST mengirim hanya data yang dibutuhkan tugas (R400.5). Untuk insight
mingguan, kirim agregat per kategori + total + budget, bukan seluruh
transaksi mentah.
