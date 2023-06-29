import 'package:dapp/constants/string_constants.dart';
import 'package:get_storage/get_storage.dart';

class LoginStatusHelper {
  static bool getLoginStatus() => GetStorage().read(StringConstants.isUserLoggedIn) ?? false;
  static setLoginStatus(bool isUserLoggedIn) async => await GetStorage().write(StringConstants.isUserLoggedIn, isUserLoggedIn);
}
