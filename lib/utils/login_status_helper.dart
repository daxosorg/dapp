import 'package:dapp/constants/local_storate_keys.dart';
import 'package:get_storage/get_storage.dart';

class LoginStatusHelper {
  static bool isUserLoggedIn() => GetStorage().read(LocalStorageKeys.loggedInStatus) ?? false;

  static setLoginStatus({required bool isUserLoggedIn}) async => await GetStorage().write(LocalStorageKeys.loggedInStatus, isUserLoggedIn);
}
