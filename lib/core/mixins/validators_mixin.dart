mixin ValidatorsMixin {
  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta gerekli';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Geçerli bir e-posta adresi girin';
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }
    return null;
  }

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ad Soyad gerekli';
    }
    return null;
  }

  String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı gerekli';
    }
    if (value != password) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }
}
