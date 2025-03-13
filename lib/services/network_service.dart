import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkService with ChangeNotifier {
  bool _isConnected = true;

  NetworkService();

  bool get isConnected => _isConnected;

  Future<bool> checkConnection() async {
    return _isConnected;
  }

  void toggleConnection() {
    _isConnected = !_isConnected;
    notifyListeners();
  }
}
