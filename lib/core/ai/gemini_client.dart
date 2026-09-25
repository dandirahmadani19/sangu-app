import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Fallback nama model lokal, dipakai HANYA kalau Remote Config belum
/// sempat fetch sama sekali (mis. app baru pertama kali dibuka
/// offline). Nama model yang dipakai untuk memanggil Gemini selalu
/// diambil dari Remote Config (R500.7), bukan hardcode di titik
/// panggilan API — supaya bisa diganti tanpa rilis ulang bila Google
/// mematikan model lama (ADR-007).
const _fallbackModelName = 'gemini-3.8-flash';

/// Key parameter Remote Config untuk nama model Gemini (R500.7).
const _modelNameKey = 'gemini_model_name';

/// Pilih nama model dari nilai Remote Config, fallback ke default
/// lokal kalau kosong. Diekstrak jadi fungsi murni (tanpa instance
/// Firebase) supaya bisa dites tanpa memanggil layanan asli (R300.8).
String resolveModelName(String remoteConfigValue) =>
    remoteConfigValue.isEmpty ? _fallbackModelName : remoteConfigValue;

/// Wrapper tipis di atas `firebase_ai` untuk memanggil Gemini lewat
/// Firebase AI Logic (ADR-007). Dipakai di T-009 untuk uji konektivitas
/// "hello"; fitur AI lain (parse struk, insight) akan pakai
/// `responseSchema` terpisah, bukan lewat class ini.
class GeminiClient {
  /// Buat [GeminiClient] dari instance [FirebaseRemoteConfig] yang
  /// sudah diinisialisasi (lihat [GeminiClient.create]).
  GeminiClient(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  /// Inisialisasi Remote Config (default value + fetch) lalu buat
  /// [GeminiClient]. Fetch yang gagal (offline) tidak melempar error —
  /// fallback ke default value lokal (fail closed, R400.6).
  static Future<GeminiClient> create() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await remoteConfig.setDefaults({_modelNameKey: _fallbackModelName});
    try {
      await remoteConfig.fetchAndActivate();
    } on Exception {
      // Offline atau Remote Config belum siap saat app pertama dibuka.
      // Biarkan; getString() di bawah tetap kembalikan default value.
    }
    return GeminiClient(remoteConfig);
  }

  /// Nama model Gemini aktif, dari Remote Config (fallback ke default
  /// lokal kalau key kosong/belum ter-fetch).
  String get modelName =>
      resolveModelName(_remoteConfig.getString(_modelNameKey));

  /// Kirim satu prompt tetap ke Gemini untuk uji konektivitas
  /// (App Check + Firebase AI Logic jalan end-to-end). Tidak melempar
  /// exception ke pemanggil — error kuota/network dikembalikan sebagai
  /// teks pesan (fail closed, R400.6, R500.8).
  Future<String> sayHello() async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(model: modelName);
      final response = await model.generateContent([
        Content.text('Balas dengan satu kata: halo'),
      ]);
      final text = response.text;
      return (text == null || text.isEmpty) ? '(respons kosong)' : text;
    } on Exception catch (e) {
      return 'Gagal panggil Gemini ($modelName): $e';
    }
  }
}
