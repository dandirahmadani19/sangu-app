# Plan — T-009: Setup Firebase + App Check + firebase_ai, tes "hello" Gemini

**Status:** DRAFT — menunggu approval developer sebelum eksekusi.
**Rule dasar:** R900 (advisor-only), R400.1, R400.2, R500.7, R500.8,
R300.8, ADR-007.
**Spec asal:** `docs/MVP.md#T-009` (Deps: T-003 · Est: M · Zona: runtime).

## 1. Restate task

Sambungkan app ke Firebase (project + App Check), pasang SDK
`firebase_ai`, lalu buat satu pemanggilan "hello" ke Gemini yang
berhasil dengan App Check aktif — tanpa API key Gemini di client, tanpa
hardcode nama model (harus dari Remote Config, R500.7).

## 2. Asumsi yang perlu dikonfirmasi dulu

1. **Platform target M0/M1: Android saja.** `android/` dan `ios/`
   berdua sudah ada dari scaffold Flutter, tapi tak ada ADR yang
   mengunci platform. Setup iOS (register app kedua, `GoogleService-Info.plist`,
   APNs untuk App Check) butuh Mac + Apple ID developer — di luar
   scope task ini kalau developer belum siap. **Usul: fokus Android
   dulu, iOS jadi task susulan (T-009b) kalau/saat dibutuhkan.**
2. **App Check provider Android: Play Integrity** (bukan debug provider
   permanen). Untuk development di emulator/device tanpa Play Store
   sign-in, dipakai **debug provider** App Check sementara (token
   didaftarkan manual di Firebase console) — ini praktik resmi Firebase
   untuk dev, bukan pelanggaran R400.2.
3. **Nama model awal:** karena R500.7 mewajibkan Remote Config (bukan
   hardcode), langkah "cek Firebase console" (dari `docs/DECISIONS.md`
   pertanyaan terbuka) dilakukan developer saat setup — agent tak bisa
   akses console.

Kalau asumsi 1 atau 2 salah, **stop, koreksi dulu** sebelum lanjut
eksekusi (R000.3).

## 3. File yang disentuh + zona

| Path | Aksi | Zona | Alasan |
|---|---|---|---|
| Firebase Console (project baru) | CREATE (eksternal) | runtime (aksi developer, bukan file repo) | Prasyarat semua langkah lain |
| `pubspec.yaml` | MODIFY (tambah `firebase_core`, `firebase_ai`, `firebase_app_check`, `firebase_remote_config`) | **runtime** (R900.9) | Dependency baru (ADR-007) |
| `android/app/google-services.json` | CREATE | **runtime**, tapi **git-ignored** (R400.1) | Config Firebase Android, sensitif |
| `lib/firebase_options.dart` | CREATE (hasil `flutterfire configure`) | **runtime**, **git-ignored** (R400.1 — memuat App ID/Project ID) | Config init Firebase |
| `android/app/build.gradle.kts` | MODIFY (tambah Google services plugin) | **runtime** | Wajib untuk Firebase Android |
| `android/build.gradle.kts` | MODIFY (tambah classpath Google services) | **runtime** | idem |
| `lib/main.dart` | MODIFY (tambah `Firebase.initializeApp()` + `FirebaseAppCheck.instance.activate()` sebelum `runApp`) | **runtime** | Inisialisasi wajib sebelum app jalan |
| `lib/core/ai/gemini_client.dart` | CREATE | **runtime** | Wrapper `firebase_ai` + ambil nama model dari Remote Config (R500.7) |
| `lib/core/ai/gemini_client_test.dart` atau smoke test manual | CREATE (test) | **runtime** | Verifikasi minimal, tapi **tidak memanggil Gemini asli** (R300.8) |
| `.gitignore` | MODIFY (pastikan `google-services.json`, `firebase_options.dart`, `GoogleService-Info.plist` masuk) | **runtime** (config, bukan `.md`) | R400.1 |
| `docs/DECISIONS.md` | MODIFY (isi baris "Nama model Gemini spesifik" di Pertanyaan Terbuka, kalau developer sudah cek console) | **doc** (R900.8), editan tabel non-ADR = trivial | Menutup pertanyaan terbuka |
| `docs/progress.md` | MODIFY (log sesi T-009) | **doc** (R900.8) | R900.10 trivial (log sesi) |
| `docs/MVP.md` | MODIFY (tandai T-009 ✓ setelah verify sukses) | **doc** (R900.8) | R900.10 trivial (tandai task ✓) |

**Tidak disentuh:** `lib/features/**` (belum relevan di T-009),
`ios/**` (lihat asumsi 1).

**Dependency baru:** `firebase_core`, `firebase_ai`,
`firebase_app_check`, `firebase_remote_config` (semua official
FlutterFire, dicatat alasan per R400.7 — ADR-007 sudah mengunci
pilihan Firebase AI Logic, jadi tidak perlu ADR baru, cukup catatan di
`ARCHITECTURE.md` bagian dependency list bila belum ada).

## 4. Urutan pengerjaan (aman, tanpa dependency dulu)

1. **[Developer, eksternal]** Buat project Firebase di console
   (nama: `sangu-app` atau serupa). **Tidak butuh file repo.**
2. **[Developer, eksternal]** Di project itu, aktifkan **App Check**
   (provider Play Integrity untuk Android; debug provider untuk lokal
   dev) dan **Remote Config**. Aktifkan Gemini API (Firebase AI Logic)
   di console — pilih model Flash terbaru yang tersedia (catat nama
   model persis, akan dipakai di langkah 6).
3. **[Developer, CLI]** Register app Android via `flutterfire configure`
   (setelah install `flutterfire_cli` — ini CLI global, bukan
   dependency Dart di `pubspec.yaml`, jadi aman dijalankan developer
   tanpa melanggar R900 karena bukan agent yang jalankan).
   - **Verify:** `lib/firebase_options.dart` dan
     `android/app/google-services.json` muncul.
4. **PROPOSAL (agent):** `.gitignore` — tambah
   `android/app/google-services.json`, `lib/firebase_options.dart`,
   `ios/Runner/GoogleService-Info.plist` (R400.1).
   - **Verify:** `git status` tidak menampilkan file-file itu sebagai
     untracked-tapi-akan-di-commit.
5. **PROPOSAL (agent):** `pubspec.yaml` — tambah 4 dependency di atas
   (versi via `flutter pub add`, bukan pin manual — pelajaran T-002 di
   `docs/progress.md`).
   - **Verify:** `flutter pub get` sukses, tidak ada conflict versi.
6. **PROPOSAL (agent):** `lib/main.dart` — tambah
   `WidgetsFlutterBinding.ensureInitialized()`,
   `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`,
   `await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug)`
   sebelum `runApp(SanguApp())`. `main()` jadi `Future<void> main() async`.
   - **Verify:** `flutter run` tidak crash saat start, tidak ada log
     error App Check di console.
7. **PROPOSAL (agent):** `android/build.gradle.kts` +
   `android/app/build.gradle.kts` — tambah Google services Gradle
   plugin (`com.google.gms.google-services`) sesuai instruksi
   `flutterfire configure` (biasanya sudah otomatis ditambahkan CLI di
   langkah 3 — agent hanya verifikasi, propose kalau ada yang kurang).
8. **PROPOSAL (agent):** `lib/core/ai/gemini_client.dart` — class
   `GeminiClient` (lihat struktur di §5) yang:
   - Ambil `FirebaseRemoteConfig.instance`, fetch nilai key
     `gemini_model_name` (default value = model yang dicatat di langkah
     2, sebagai fallback bila fetch remote gagal — **bukan** hardcode
     pemanggilan Gemini, hanya default lokal Remote Config, sesuai izin
     R500.7).
   - Method `Future<String> sayHello()` yang panggil
     `FirebaseAI.googleAI().generativeModel(model: modelName)`, kirim
     prompt fix `"Balas dengan satu kata: halo"`, kembalikan teks
     respons.
9. **PROPOSAL (agent):** test minimal (§6) — **tidak** memanggil
   Gemini asli (R300.8). Fokus: `GeminiClient` bisa dikonstruksi,
   Remote Config default value terpasang benar (mock
   `FirebaseRemoteConfig`).
10. **[Developer, manual]** Jalankan app di emulator/device Android,
    trigger `sayHello()` (mis. lewat tombol sementara di layar debug
    atau `print` di `main()` untuk uji cepat — **bukan** bagian
    permanen UI), konfirmasi teks balasan Gemini muncul di log/UI.
11. **[Agent, doc-zone]** Setelah developer lapor sukses: update
    `docs/DECISIONS.md` (isi nama model final di tabel pertanyaan
    terbuka), `docs/progress.md` (log sesi), `docs/MVP.md` (tandai
    T-009 ✓).

Tiap langkah 4–9 = satu batch proposal, tunggu konfirmasi developer
sebelum proposal berikutnya (R900.4).

## 5. Struktur `lib/core/ai/gemini_client.dart` (rencana, bukan kode)

```
class GeminiClient {
  GeminiClient(this._remoteConfig);
  final FirebaseRemoteConfig _remoteConfig;

  // Nama model dari Remote Config (R500.7). Default value = fallback
  // lokal, dipasang saat setRemoteConfigSettings, BUKAN hardcode di
  // titik panggilan API.
  String get _modelName => _remoteConfig.getString('gemini_model_name');

  Future<String> sayHello() async {
    // build GenerativeModel dari FirebaseAI.googleAI(), kirim prompt
    // fix, tangani error kuota/network dengan pesan jelas (R500.8),
    // JANGAN throw mentah ke UI (R400.6 fail closed).
  }
}
```

Tidak ada `responseSchema`/structured output di task ini (baru
dibutuhkan mulai fitur parse struk/insight, task lanjutan) — cukup teks
biasa untuk uji konektivitas.

## 6. Test minimal (R300)

- `test/core/ai/gemini_client_test.dart` (mirror `lib/core/ai/`, R300.5):
  - `'GeminiClient pakai nama model dari Remote Config, bukan hardcode'`
    — mock `FirebaseRemoteConfig`, set default value, assert
    `_modelName` (via getter yang di-expose untuk test atau lewat
    behavior publik) sama dengan default itu.
  - **Tidak ada test yang memanggil Gemini asli** (R300.8) — pemanggilan
    nyata hanya diverifikasi manual oleh developer di langkah 10.

## 7. Edge case yang perlu dihandel di `GeminiClient`

- Remote Config fetch gagal (offline saat pertama buka app) → fallback
  ke default value lokal, MUST NOT crash (R400.6).
- App Check token belum siap saat app baru pertama kali dibuka → SDK
  `firebase_ai` biasanya menunggu; kalau ada race, tangkap exception dan
  tampilkan pesan "AI belum siap, coba lagi" — bukan throw mentah.
- Kuota/rate-limit Gemini free tier terlampaui → catch spesifik,
  pesan jelas ke user, tidak retry tanpa batas (R500.8).
- Nama model dari Remote Config kosong/typo → validasi non-empty
  sebelum panggil API, fallback ke default value.

## 8. Verify (perintah persis)

```bash
flutter pub get
flutter analyze          # harus 0 warning/error (R100.1)
flutter test             # test baru harus hijau, tidak ada network call asli
flutter run              # manual: konfirmasi Firebase.initializeApp jalan,
                          # tidak ada error App Check di log
```

**Expected:**
- `flutter analyze`: 0 issues (atau hanya info yang sudah ada sebelumnya).
- `flutter test`: semua lolos termasuk test `GeminiClient` baru.
- `flutter run` + trigger manual `sayHello()`: teks balasan Gemini
  muncul (bukti App Check + Firebase AI Logic jalan end-to-end).

## 9. Risks / Unknowns

- **iOS belum di-setup** (lihat asumsi 1) — kalau developer butuh iOS
  segera, task ini harus diperluas atau dipecah jadi T-009b.
- **Kuota free tier Gemini** bisa berubah kebijakan; kalau "hello" test
  gagal karena kuota, itu bukan bug kode, cek dashboard Firebase.
- **Versi `firebase_ai`/`firebase_app_check`** di pub.dev bisa naik
  cepat (SDK masih relatif baru) — pakai `flutter pub add` supaya
  resolusi otomatis, jangan pin manual (pelajaran T-002).
- Trigger manual `sayHello()` di langkah 10 butuh titik panggil
  sementara (tombol debug/print) — agent akan usulkan cara paling
  minimal, developer boleh hapus setelah verifikasi.

## 10. Rollback

- Kalau `flutter pub get`/`analyze`/`test` gagal setelah satu batch
  proposal: developer revert file yang diubah di batch itu saja
  (`git diff`/`git checkout -- <file>` sebelum commit apa pun — belum
  ada commit dibuat di tengah proses ini, R900.1 melarang agent commit).
- Kalau App Check/Firebase setup di console salah konfigurasi:
  perbaiki di console, tidak perlu ubah kode.
