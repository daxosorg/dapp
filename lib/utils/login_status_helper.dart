import 'package:dapp/constants/string_constants.dart';
import 'package:get_storage/get_storage.dart';

class LoginStatusHelper {
  static bool isUserLoggedIn() => GetStorage().read(StringConstants.loggedInStatus) ?? false;

  static setLoginStatus({required bool isUserLoggedIn}) async => await GetStorage().write(StringConstants.loggedInStatus, isUserLoggedIn);
}
