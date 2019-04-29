import 'dart:async';

class Validators {

  // Email validator
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@') && email.contains('.')) {
        sink.add(email);
      }
      else {
        sink.addError('Merci de renseigner un email valide');
      }
    }
  );

  // Password validator
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (
        (password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[a-z]')))
        &&
        (password.length > 8 && password.length < 24)
        ) {
        sink.add(password);
      }
      else {
        sink.addError('Le mot de passe doit contenir A,a et doit être de 8-24 caractères');
      }
    }
  );

  final validateConfirm = StreamTransformer<String, String>.fromHandlers(
    handleData: (confirmPassword, sink) {
      if (confirmPassword.length > 0) {
        sink.add(confirmPassword);
      }
      else {
        sink.addError('Les mots de passe ne correspondent pas');
      }
    }
  );

  final validateSame = StreamTransformer<dynamic, bool>.fromHandlers(
    handleData: (same, sink) {
      if (same) {
        sink.add(same);
      }
      else {
        sink.addError('Les mots de passe ne correspondent pas');
      }
    }
  );
}