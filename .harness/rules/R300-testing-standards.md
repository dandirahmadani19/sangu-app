# R300 — Testing Standards (realistis untuk MVP)

Testing untuk Sangu bersifat **realistis**, bukan full pyramid.
Fokus ke jalur yang gampang salah dan sering dipakai. Bukan mengejar
100% coverage.

## Scope

Berlaku untuk `test/**`. Test dijalankan CI sebagai gate (R300.7).

## R300.1 — Filosofi: jalur kritis dulu

Prioritas test (dari paling wajib):

1. Logika perhitungan uang: saldo, total per kategori, progress budget.
2. Mapper parse hasil AI → model (`Transaction`, insight).
3. Aturan kata kunci kategori lokal (fallback offline).
4. Validasi form transaksi (widget test).
5. Keamanan parse output AI (tidak crash saat JSON rusak).

MUST menulis test untuk 1–3 sebelum menandai fitur terkait selesai.
Coverage 100% BUKAN target.

## R300.2 — Unit test logika uang & mapper

- Perhitungan saldo/budget MUST punya unit test dengan kasus batas
  (nol, negatif tak boleh, pembulatan int Rupiah per R100.3).
- Mapper `json → model` MUST dites untuk input lengkap dan input
  minimal (field opsional null).

**Contoh (benar):**
```dart
test('saldo = pemasukan - pengeluaran', () {
  final saldo = hitungSaldo([income(100000), expense(40000)]);
  expect(saldo, 60000);
});
```

## R300.3 — Widget test form transaksi

Form input transaksi MUST punya widget test yang memverifikasi:
- Input valid tersimpan dengan nilai benar (amount `int`).
- Input invalid (amount kosong/nol) memunculkan pesan validasi.

## R300.4 — Parse-safety test AI

Untuk tiap schema AI (parse transaksi, insight), MUST ada test bahwa
JSON rusak/tak sesuai schema menghasilkan **state error**, MUST NOT
membuat app crash (sejalan R500.4).

**Contoh:**
```dart
test('json rusak → failure, bukan throw', () {
  final r = parseTransaction('{bukan json}');
  expect(r.isFailure, true);
});
```

## R300.5 — Organisasi & lokasi

- `test/` MUST me-mirror struktur `lib/` (mis.
  `test/features/transactions/...`).
- Nama file test: `<subjek>_test.dart`.

## R300.6 — Penamaan test

Deskripsi test MUST menyatakan perilaku, bukan implementasi.

**Benar:** `'budget terlewat → warning muncul'`
**Salah:** `'test fungsi checkBudget'`

## R300.7 — CI gate

`flutter test` MUST hijau di CI sebelum merge (Ratchet: sekali hijau,
tetap hijau). Pre-commit lokal juga menjalankan test (lihat
`lefthook.yml`).

## R300.8 — Test tidak menyentuh jaringan asli

Test MUST NOT memanggil Firebase/Gemini asli. Panggilan AI di-mock
atau pakai fixture JSON. Alasan: test harus deterministik, cepat, dan
tidak makan kuota/biaya.
