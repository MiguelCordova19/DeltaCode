import 'package:flutter/foundation.dart';

class MonedasNotifier extends ChangeNotifier {
  static final MonedasNotifier _instance = MonedasNotifier._internal();
  
  factory MonedasNotifier() {
    return _instance;
  }
  
  MonedasNotifier._internal();

  void notificarCambio() {
    notifyListeners();
  }
}
