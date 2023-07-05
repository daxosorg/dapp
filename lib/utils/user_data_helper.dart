import 'package:dapp/constants/string_constants.dart';
import 'package:get_storage/get_storage.dart';

class UserDataHelper {
  static String? getUserId() => GetStorage().read(StringConstants.userId);
  static setUserId({required String userId}) async => await GetStorage().write(StringConstants.userId, userId);

  static String? getUserName() => GetStorage().read(StringConstants.userName);
  static setUserName({required String userName}) async => await GetStorage().write(StringConstants.userName, userName);

  static String? getUserPhone() => GetStorage().read(StringConstants.userPhone);
  static setUserPhone({required String phoneNumber}) async => await GetStorage().write(StringConstants.userPhone, phoneNumber);

  static String? getUserAddress() => GetStorage().read(StringConstants.userAddress);
  static setUserAddress({required String userAddress}) async => await GetStorage().write(StringConstants.userAddress, userAddress);
}
