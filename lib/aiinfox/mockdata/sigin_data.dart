import 'package:mobx/mobx.dart';

part 'sigin_data.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  @observable
  bool isPhoneVisible = true;

  @observable
  bool isOTPVisible = false;

  @observable
  String phoneNumber = '';

  @observable
  String otp = '';

  @action
  void toggleVisibility() {
    isPhoneVisible = !isPhoneVisible;
    isOTPVisible = !isOTPVisible;
  }

  @action
  void setPhoneNumber(String value) {
    phoneNumber = value;
  }

  @action
  void setOTP(String value) {
    otp = value;
  }

  // Mock function to simulate phone number verification
  @action
  bool verifyPhoneNumber() {
    // Simulate a successful login
    return phoneNumber == '9876543210';
  }

  // Mock function to simulate OTP verification
  @action
  bool verifyOTP() {
    // Simulate a successful OTP verification
    return otp == '1234';
  }
}

