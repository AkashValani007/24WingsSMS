import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  bool hasInternet = true;
  StreamSubscription? _subscription;
  final StreamController<bool> _onConnectivityChanged = StreamController.broadcast();

  static final instance = ConnectivityUtils._();

  ConnectivityUtils._();

  Stream<bool> get onConnectivityChanged => _onConnectivityChanged.stream;

  void init() {
    Connectivity().checkConnectivity().then(_onConnectivityChange);
    _subscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChange);
  }

  void _onConnectivityChange(ConnectivityResult result) {
    hasInternet = result != ConnectivityResult.none;
    _onConnectivityChanged.add(hasInternet);
  }

  void dispose() {
    _subscription?.cancel();
    _onConnectivityChanged.close();
  }
}
