import 'package:connectivity/connectivity.dart';

///Mixin to check internet connectivity
mixin Connection {
  Future<bool> isConnected() async =>
      await Connectivity().checkConnectivity() != ConnectivityResult.none;
}
