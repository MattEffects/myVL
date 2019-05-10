class Validators {

  String validateEmail (String value) {
    // Return null if valid
    // Otherwise string (with error message) if invalid
    if (!((value.contains('@')) && (value.contains('.')))) {
      return 'Merci de renseigner un email valide';
    }
    return null;
  }

  String validatePassword (String value) {
    if (value.length == 0 || value == null) {
      return 'Merci de renseigner un mot de passe';
    }
    if (
      (value.length < 8 && value.length > 24)
      ||
      !(value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[a-z]')))
    ) {
      return '8-24 caractères, majuscules et minuscules';
    }
    return null;
  }

}