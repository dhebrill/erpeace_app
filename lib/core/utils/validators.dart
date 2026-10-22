/// Form validation helpers used by every form in ERPeace.
abstract final class Validators {
  const Validators._();

  static String? required(String? value, {String field = 'Kolom ini'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email wajib diisi';
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!pattern.hasMatch(text)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Kata sandi wajib diisi';
    if (text.length < 6) return 'Kata sandi minimal 6 karakter';
    return null;
  }

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Nama wajib diisi';
    if (text.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Nilai'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$field wajib diisi';
    final parsed = double.tryParse(
      text.replaceAll('.', '').replaceAll(',', '.'),
    );
    if (parsed == null) return '$field harus berupa angka';
    if (parsed <= 0) return '$field harus lebih besar dari 0';
    return null;
  }

  static String? nonNegativeNumber(String? value, {String field = 'Nilai'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$field wajib diisi';
    final parsed = double.tryParse(
      text.replaceAll('.', '').replaceAll(',', '.'),
    );
    if (parsed == null) return '$field harus berupa angka';
    if (parsed < 0) return '$field tidak boleh negatif';
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!RegExp(r'^[0-9+\-\s()]{6,20}$').hasMatch(text)) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  static String? optionalEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return email(text);
  }
}
