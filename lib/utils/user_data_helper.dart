import 'package:dapp/constants/local_storate_keys.dart';
import 'package:get_storage/get_storage.dart';

class UserDataHelper {
  static String? getUserId() => GetStorage().read(LocalStorageKeys.userId);
  static setUserId({required String userId}) async => await GetStorage().write(LocalStorageKeys.userId, userId);

  static String? getUserName() => GetStorage().read(LocalStorageKeys.userName);
  static setUserName({required String userName}) async => await GetStorage().write(LocalStorageKeys.userName, userName);

  static String? getUserPhone() => GetStorage().read(LocalStorageKeys.userPhone);
  static setUserPhone({required String phoneNumber}) async => await GetStorage().write(LocalStorageKeys.userPhone, phoneNumber);

  static String? getUserAddress() => GetStorage().read(LocalStorageKeys.userAddress);
  static setUserAddress({required String userAddress}) async => await GetStorage().write(LocalStorageKeys.userAddress, userAddress);
}
