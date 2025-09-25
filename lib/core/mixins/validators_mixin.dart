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
}
