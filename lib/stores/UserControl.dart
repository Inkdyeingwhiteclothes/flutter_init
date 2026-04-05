import 'package:get/get.dart';
import 'package:hm_shop/viewmodels/user.dart';

class UserController extends GetxController {
  var user = UserInfo.fromJSON({}).obs;

  updateUserInfo(UserInfo userInfo) {
    user.value = userInfo;
  }
}