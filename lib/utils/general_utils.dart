import 'package:connectivity/connectivity.dart';

class GeneralUtils {

  Future<bool> checkConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    } else {
      return false;
    }
  }
}