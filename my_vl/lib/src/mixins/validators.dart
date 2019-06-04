// Classe de validation des champs de saisie
// Référencie différentes fonctions pour la validation
// Ces fonctions prennent comme arguments l'entrée de l'utilisateur
// et retournent null si l'entrée est conforme
// ou bien un String d'erreur si ce n'est pas le cas

class Validators {

  String validateEmail (String value) {
    // Renvoie null si l'email est valide
    // A l'inverse, renvoie un String avec le msg d'erreur si l'email est invalide
    if (value.length == 0 || value == null) {
      return 'Merci de renseigner un email';
    }
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

  String validateFirstName (String value) {
    if (value.length == 0 || value == null) {
      return 'Merci de renseigner un prénom';
    }
    return null;
  }

  String validateLastName (String value) {
    if (value.length == 0 || value == null) {
      return 'Merci de renseigner un nom';
    }
    return null;
  }

  String validateSchool (int value) {
    if (value == null) {
      return 'Merci de renseigner un établissement';
    }
    return null;
  }

  String validateClassroom (int value) {
    if (value == null) {
      return 'Merci de renseigner une classe';
    }
    return null;
  }
}