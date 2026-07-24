# Contoh — Uang: `int` Rupiah, bukan `double` (R100.3)

## ❌ Salah

```dart
class Transaction {
  final double amount; // galat pembulatan: 0.1 + 0.2 != 0.3
}

double total = items.fold(0.0, (s, i) => s + i.amount);
```

Masalah: `double` menyimpan uang dengan galat floating-point. Rp10.000
bisa jadi Rp9.999,999... dan menumpuk saat dijumlah.

## ✅ Benar

```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int amount, // Rupiah, tanpa desimal
  }) = _Transaction;
}

int total = items.fold(0, (s, i) => s + i.amount);
```

Rupiah tidak punya sen dalam praktik sehari-hari → `int` cukup dan
bebas galat. Format tampilan (titik ribuan) dilakukan di layer UI,
bukan diubah tipenya.
