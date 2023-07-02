import 'package:dapp/constants/string_constants.dart';
import 'package:get_storage/get_storage.dart';

class UserDataHelper {
  static String? getUserName() => GetStorage().read(StringConstants.userId);
  static setUserName({required String userName}) async => await GetStorage().write(StringConstants.userId, userName);

  static String? getUserPhone() => GetStorage().read(StringConstants.userPhone);
  static setUserPhone({required String phoneNumber}) async => await GetStorage().write(StringConstants.userPhone, phoneNumber);

  static String? getUserAddress() => GetStorage().read(StringConstants.userAddress);
  static setUserAddress({required String userAddress}) async => await GetStorage().write(StringConstants.userAddress, getUserAddress);
}
