# Plan — Minggu 0: Setup & Harness

**Status:** Draft — menunggu approval untuk eksekusi.
**Disusun:** 2026-07-04 oleh Claude (Opus 4.7, effort: high).
**Fase yang dieksekusi sesi ini:** Fase 1 + Fase 2 + Fase 2.5. **Fase 3 (Firebase + AI) ditunda** ke sesi terpisah.
**Referensi:** `docs/MVP.md` (Roadmap Minggu 0), `docs/ARCHITECTURE.md` (Struktur & Harness), `docs/DECISIONS.md` (D-01 … D-19).

---

## Tujuan sesi ini

1. Project Flutter siap dikembangkan: dependency inti terpasang, lint ketat aktif, struktur folder feature-first ada.
2. Harness bekerja: `dart format` + `flutter analyze` + `flutter test` semua hijau.
3. Pre-commit gate (`lefthook`) menolak commit yang tidak lolos harness.
4. Repo di-push ke GitHub (private) dan CI GitHub Actions hijau pada push pertama.
5. Skip: Firebase, AI, halaman "Tes AI" (ditunda ke Minggu 0-lanjutan).

---

## Prinsip

- Claude memberi instruksi, developer menjalankan (D-17).
- Setiap file yang dibuat/diubah dijelaskan barisnya.
- Ratchet: setelah Gate hijau, harus **tetap** hijau (tidak boleh regresi).
- File hasil generate (`*.g.dart`, `*.freezed.dart`) **di-commit** — CI tidak wajib jalan `build_runner`, tapi tetap dijalankan sebagai jaring pengaman.

---

## Fase 1 — Konfigurasi dasar (tanpa dependency eksternal)

### 1.1 Update `analysis_options.yaml`

**Path:** `analysis_options.yaml`

**Isi (final):**
```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "lib/firebase_options.dart"  # akan di-generate FlutterFire di sesi Fase 3
```

**Kenapa:**
- `very_good_analysis` = lint ketat, sesuai D-16.
- File generate tidak perlu di-lint (bikin noise, bukan salah kita).
- `firebase_options.dart` sudah pasti melanggar lint ketat (multi-line long string, ignored types); kita pre-emptively exclude walau belum ada.

### 1.2 Update `pubspec.yaml`

**Path:** `pubspec.yaml`

**Yang dihapus dari versi saat ini:**
- `flutter_lints` di `dev_dependencies` (diganti `very_good_analysis`).

**Yang ditambahkan — `dependencies`:**
| Paket | Peran | Referensi keputusan |
|---|---|---|
| `flutter_riverpod` | State (runtime) | D-02 |
| `riverpod_annotation` | Anotasi codegen Riverpod | D-02 |
| `drift` | ORM SQLite | D-03 |
| `drift_flutter` | Bridge Drift ↔ Flutter (path DB) | D-03 |
| `sqlite3_flutter_libs` | Native SQLite | D-03 |
| `path_provider` | Cari folder document | D-03 |
| `path` | Manipulasi path | D-03 |
| `freezed_annotation` | Anotasi freezed | D-04 |
| `json_annotation` | Anotasi json_serializable | D-04 |
| `go_router` | Routing | D-05 |
| `dio` | HTTP client | D-06 |
| `uuid` | ID transaksi | D-15 |
| `intl` | Format tanggal & angka | umum |
| `flutter_animate` | Motion primitives | D-11 (dipakai Minggu 2+, dipasang sekarang untuk sekali pub get) |

**Yang ditambahkan — `dev_dependencies`:**
| Paket | Peran |
|---|---|
| `very_good_analysis` | Lint ketat (D-16) |
| `build_runner` | Runner codegen |
| `riverpod_generator` | Codegen provider Riverpod |
| `custom_lint` | Framework lint kustom (dipakai riverpod_lint) |
| `riverpod_lint` | Lint spesifik Riverpod |
| `drift_dev` | Codegen tabel Drift |
| `freezed` | Codegen freezed |
| `json_serializable` | Codegen JSON |

**Firebase deferred:** `firebase_core`, `firebase_ai`, `firebase_app_check` **tidak ditambah sekarang** — ditunda ke sesi Fase 3.

**Cara eksekusi (dev):**
```bash
flutter pub add \
  flutter_riverpod riverpod_annotation \
  drift drift_flutter sqlite3_flutter_libs path_provider path \
  freezed_annotation json_annotation \
  go_router dio uuid intl flutter_animate

flutter pub add --dev \
  very_good_analysis build_runner \
  riverpod_generator custom_lint riverpod_lint \
  drift_dev freezed json_serializable

flutter pub remove flutter_lints
```
Biarkan `flutter pub add` yang menentukan versi terbaru — jangan pin manual.

### 1.3 Update `.gitignore`

**Path:** `.gitignore`

**Yang ditambahkan (kalau belum ada) — di bagian akhir:**
```
# Env dev
.env
.env.local

# FlutterFire
firebase-debug.log
.firebase/
```

**Yang TIDAK di-ignore (biar ikut commit):**
- `*.g.dart`
- `*.freezed.dart`
- `lib/firebase_options.dart` (nanti setelah Fase 3)

### 1.4 Bikin folder skeleton

**Perintah:**
```bash
mkdir -p \
  lib/core/db lib/core/ai lib/core/router lib/core/theme lib/core/utils \
  lib/shared/widgets \
  lib/features/dashboard/presentation lib/features/dashboard/data \
  lib/features/transactions/presentation lib/features/transactions/data \
  lib/features/receipts/presentation lib/features/receipts/data \
  lib/features/insights/presentation lib/features/insights/data \
  lib/features/gamification/presentation lib/features/gamification/data
```

**Tambah `.gitkeep`** di tiap folder daun (16 file) supaya struktur folder ikut ke git.

### 1.5 Ganti `lib/main.dart`

**Path:** `lib/main.dart`

**Isi (final untuk Minggu 0):**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: SanguApp()));
}

class SanguApp extends StatelessWidget {
  const SanguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sangu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sangu')),
      body: const Center(
        child: Text('Sangu siap. Fitur menyusul.'),
      ),
    );
  }
}
```

**Kenapa segini saja:**
- `ProviderScope` = root Riverpod (harus paling atas).
- `MaterialApp` (bukan `.router`) — belum ada rute kedua, go_router baru dipakai Minggu 1.
- Placeholder home cukup untuk tes smoke.
- Palet warna & tipografi masih default M3 — pending #1 & #2 di DECISIONS.

### 1.6 Ganti `test/widget_test.dart`

**Path:** `test/widget_test.dart`

**Isi:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sangu/main.dart';

void main() {
  testWidgets('App menampilkan judul Sangu', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SanguApp()));

    expect(find.text('Sangu'), findsOneWidget);
    expect(find.text('Sangu siap. Fitur menyusul.'), findsOneWidget);
  });
}
```

Menggantikan counter test bawaan yang sudah tidak relevan (widget counter tidak ada lagi di `main.dart`).

### 1.7 Update `README.md`

**Path:** `README.md`

Isi minimal:
- Nama project, 1-baris deskripsi (ambil dari CLAUDE.md).
- Command harian.
- Link ke `docs/`.

Ini opsional untuk Gate 1 tapi enak dikerjakan sekarang mumpung sedang isi file. Kalau mepet, skip.

### GATE 1 — Verify Fase 1

Perintah dev, harus semua hijau:
```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter run   # visual check: halaman "Sangu siap. Fitur menyusul." muncul
```

Kalau `flutter analyze` merah karena aturan very_good_analysis:
- Perbaiki di sumbernya (jangan ignore/loose lint di skala global).
- Aturan yang terlalu bising boleh dicatat, tapi jangan longgarkan di sesi ini kecuali sudah dibahas.

---

## Fase 2 — Harness pre-commit + CI

### 2.1 `lefthook.yml`

**Path:** `lefthook.yml` (root)

**Isi:**
```yaml
pre-commit:
  parallel: false
  commands:
    format:
      run: dart format --set-exit-if-changed .
    analyze:
      run: flutter analyze
    test:
      run: flutter test
```

**Pasang (dev, sekali):**
```bash
dart pub global activate lefthook
lefthook install
```

Alternatif: `brew install lefthook`. Pilih salah satu yang dev sudah punya toolingnya.

### 2.2 `.github/workflows/ci.yml`

**Path:** `.github/workflows/ci.yml`

**Isi:**
```yaml
name: ci

on:
  push:
    branches: ['**']
  pull_request:
    branches: ['**']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze
      - run: flutter test
```

**Catatan:**
- `build_runner build` di CI tetap dijalankan sebagai jaring pengaman walau file generate sudah di-commit.
- Belum ada langkah Firebase — tidak ada secrets yang perlu diset di GitHub sekarang.

### GATE 2 — Verify Fase 2 (lokal)

```bash
lefthook run pre-commit
```
Harus semua hijau.

Coba negatif-test: rusak format satu file → jalankan `lefthook run pre-commit` → harus menolak.

---

## Fase 2.5 — Push ke GitHub

Prasyarat dev:
- `gh` (GitHub CLI) sudah terpasang & sudah `gh auth login`.
- `git` sudah `git config --global user.name` & `user.email`.

Cek dulu:
```bash
git status                    # apakah ini sudah repo git?
gh auth status                # apakah sudah login gh?
```

### 2.5.a Kalau `git status` bilang belum ada repo

```bash
cd /Users/dandirahmadani/Own-Projects/sangu-app
git init -b main
git add .
git commit -m "chore: initial commit — Flutter scaffold + harness (Minggu 0)"
```

### 2.5.b Kalau sudah repo

Cukup:
```bash
git add .
git status                    # verifikasi apa yang akan di-commit
git commit -m "chore: bootstrap Minggu 0 — harness + folder feature-first"
```

### 2.5.c Buat repo remote & push

```bash
gh repo create sangu-app \
  --private \
  --source=. \
  --remote=origin \
  --push \
  --description "Aplikasi pencatatan keuangan pribadi berbasis Flutter (Sangu)."
```

### GATE 3 — Verify CI GitHub

- Buka `https://github.com/<username>/sangu-app/actions` → workflow `ci` harus hijau.
- Kalau merah: baca log, fix root cause, commit lagi. **Jangan** longgarkan aturan lint hanya untuk lolos CI.

---

## Urutan pengerjaan aman

1. §1.1 lint config
2. §1.2 pubspec — `flutter pub add ...`
3. §1.3 .gitignore
4. §1.4 folder skeleton + `.gitkeep`
5. §1.5 `lib/main.dart`
6. §1.6 `test/widget_test.dart`
7. §1.7 README (opsional)
8. **GATE 1** — analyze + test hijau
9. §2.1 `lefthook.yml` + install
10. §2.2 `.github/workflows/ci.yml`
11. **GATE 2** — `lefthook run pre-commit` hijau
12. §2.5 git commit + push GitHub
13. **GATE 3** — CI GitHub hijau
14. Update `docs/progress.md` via `/session-end`

---

## Edge case & jawaban siap

| Edge case | Aksi |
|---|---|
| `flutter pub get` konflik versi antar codegen (`analyzer`, `source_gen`) | `flutter pub upgrade --major-versions` untuk paket dev; kalau masih rusak, pin versi paket yang paling ribet ke rilis terbaru yang kompatibel. Jangan asal downgrade lain. |
| `very_good_analysis` marahi widget test | Perbaiki di test file (import ordering, trailing comma, dsb). Aturan lint jangan dilonggarkan global. |
| Nama package di `pubspec.yaml` = `sangu`, tapi impor test pakai `package:sangu/...` | Sudah cocok (`name: sangu` di pubspec.yaml). Kalau nanti developer rename package, ingat update import. |
| `lefthook install` gagal karena permission | Coba `sudo dart pub global activate lefthook`, atau pindah ke `brew install lefthook`. |
| `gh repo create` menolak karena nama sudah dipakai | Ganti ke `sangu-app-<inisial>` atau nama lain yang free. Update `README.md` bila sudah ditulis. |
| Repo GitHub public vs private | Rencana: **private**. Karena project pribadi & belum public-ready. Bisa diubah nanti via `gh repo edit --visibility public`. |
| CI GitHub gagal karena versi Flutter default berbeda dengan lokal | Pin channel di `subosito/flutter-action`: sudah pakai `stable`. Kalau masih beda, tambahkan `flutter-version: '3.35.x'` sesuai versi lokal. |
| File `.gitkeep` malah dilint | `.gitkeep` bukan file Dart, tidak akan disentuh `flutter analyze`. Aman. |

---

## Test minimal

Ditulis di sesi ini:

1. **`test/widget_test.dart`** — smoke test `SanguApp` (§1.6).

Total: **1 test**. Cukup untuk gate CI hijau. Test unit repository, model, dsb menunggu Minggu 1 (saat kode aslinya lahir).

---

## Yang **tidak** dikerjakan sesi ini (ditunda)

| Item | Ditunda ke |
|---|---|
| Firebase project + App Check + FlutterFire | Sesi Fase 3 (setelah user siap buat Firebase project) |
| `firebase_core`, `firebase_ai`, `firebase_app_check` di pubspec | Sesi Fase 3 |
| `GeminiClient` + halaman "Tes AI" | Sesi Fase 3 |
| Firebase Remote Config nama model Gemini | Minggu 5 (saat AI insight) |
| `go_router` config | Minggu 1 (saat ada halaman kedua) |
| Palet warna final + font | Minggu 2 / Minggu 6 |
| Skema Drift + repository | Minggu 1 |
| Slash commands custom di `.claude/commands/` | Dicek pas eksekusi. Kalau kosong, ikuti ARCHITECTURE.md §Harness. Kalau sudah ada, lewati. |

---

## Definisi "selesai" (Definition of Done Minggu 0 versi ringkas)

- [ ] `flutter analyze` hijau tanpa warning.
- [ ] `flutter test` hijau (1 test).
- [ ] `dart format --set-exit-if-changed .` hijau.
- [ ] `lefthook run pre-commit` hijau; commit dengan file rusak-format ditolak.
- [ ] Struktur folder `lib/core/**` + `lib/features/**` sesuai ARCHITECTURE.md.
- [ ] Repo `sangu-app` ada di GitHub (private), branch `main` ter-push.
- [ ] Workflow `ci` di GitHub Actions hijau pada push pertama.
- [ ] `docs/progress.md` di-update: status = "Minggu 0 Fase 1+2 selesai, Fase 3 (Firebase) tertunda".

---

## Catatan revisi

- **2026-07-04** — Draft awal. Fase 3 (Firebase) di-scope-out atas permintaan user; ganti dengan Fase 2.5 (push GitHub). File generate diputuskan **di-commit**.
