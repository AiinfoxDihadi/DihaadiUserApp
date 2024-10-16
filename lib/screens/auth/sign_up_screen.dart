import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/selected_item_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:booking_system_flutter/utils/validators/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;
  final String? uid;
  final int? tokenForOTPCredentials;

  SignUpScreen({Key? key, this.phoneNumber, this.isOTPLogin = false, this.countryCode, this.uid, this.tokenForOTPCredentials}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isAcceptedTc = false;

  bool isFirstTimeValidation = true;
  ValueNotifier _valueNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.phoneNumber != null) {
      selectedCountry = Country.parse(widget.countryCode.validate(value: selectedCountry.countryCode));

      mobileCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      passwordCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      userNameCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Logic
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  Future<void> registerWithOTP() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      // if (isAcceptedTc == false) {
        formKey.currentState!.save();
        appStore.setLoading(true);

        UserData userResponse = UserData()
          ..username = widget.phoneNumber.validate().trim()
          ..loginType = LOGIN_TYPE_OTP
          ..contactNumber = buildMobileNumber()
          ..email = emailCont.text.trim()
          ..firstName = fNameCont.text.trim()
          ..lastName = lNameCont.text.trim()
          ..userType = USER_TYPE_USER
          ..uid = widget.uid.validate()
          ..password = widget.phoneNumber.validate().trim();

        /// Link OTP login with Email Auth
        if (widget.tokenForOTPCredentials != null) {
          try {
            AuthCredential credential = PhoneAuthProvider.credentialFromToken(widget.tokenForOTPCredentials!);
            UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

            AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: emailCont.text.trim(), password: DEFAULT_FIREBASE_PASSWORD);
            userCredential.user!.linkWithCredential(emailAuthCredential);
          } catch (e) {
            print(e);
          }
        }

        await createUsers(tempRegisterData: userResponse);
      }
    }
  // }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: language.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  void registerUser() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      // if (isAcceptedTc) {
        appStore.setLoading(true);
        /// Create a temporary request to send
        UserData tempRegisterData = UserData()
          ..contactNumber = '+91-${emailCont.text.trim()}'
          ..firstName = fNameCont.text.trim()
          ..lastName = ''
          ..loginType = LOGIN_TYPE_USER
          ..userType = USER_TYPE_USER
          ..username = userNameCont.text.trim()
          ..email = "${emailCont.text.trim()}@gmail.com"
          ..gender = 'male'
          ..age = 18
          ..password = '12345678';
          appStore.setContactNumber(emailCont.text.trim());
        createUsers(tempRegisterData: tempRegisterData);
      // } else {
      //   toast(language.termsConditionsAccept);
      // }
    } else {
      isFirstTimeValidation = false;
      setState(() {});
    }
  }

  Future<void> createUsers({required UserData tempRegisterData}) async {
    appStore.setLoading(true);

    try {
      var registerResponse = await createUser(tempRegisterData.toJson());
      registerResponse.userData!.password = passwordCont.text.trim();

      UserCredential userCredential;

      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: registerResponse.userData?.email ?? '',
          password: '12345678',
        );
        print('User signed in: $userCredential');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: registerResponse.userData?.email ?? '',
            password: '12345678',
          );
          print('User created: $userCredential');

          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'first_name': registerResponse.userData?.firstName ?? "",
            'email': registerResponse.userData?.email ?? '',
            'uid': userCredential.user?.uid,
            'profile_image' : registerResponse.userData?.profileImage ?? ''
          });
        } else {
          throw e;
        }
      }

      if (userCredential.user != null) {
        appStore.setLoading(false);
        print("User successfully logged in/registered: ${tempRegisterData.email}");
        await appStore.setLoginType(tempRegisterData.loginType!);
        finish(context);
      }
    } catch (e) {
      appStore.setLoading(false);
      if(e.toString() == 'The email has already been taken.') {
        toast("The Phone is already taken.");
      } else {
        toast('Something went wrong');
      }

      print("Error during user creation: $e");
    } finally {
      appStore.setLoading(false);
    }
  }


  //endregion

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
          child: ic_profile2.iconImage(color: Colors.white),
          decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
        ),
        16.height,
        Text(language.lblHelloUser, style: boldTextStyle(size: 22)).center(),
        16.height,
        Text(language.lblSignUpSubTitle, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center).center().paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    setState(() {});
    return Column(
      children: [
        32.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintFirstNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // AppTextField(
        //   textFieldType: TextFieldType.NAME,
        //   controller: lNameCont,
        //   focus: lNameFocus,
        //   nextFocus: userNameFocus,
        //   errorThisFieldRequired: language.requiredText,
        //   decoration: inputDecoration(context, labelText: language.hintLastNameTxt),
        //   suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        // ),
        // 16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintUserNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.PHONE,
          controller: emailCont,
          focus: emailFocus,
          validator: Validator.phoneNumberValidate,
          decoration: inputDecoration(context, labelText: language.hintContactNumberTxt),
          suffix: ic_calling.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     // Country code ...
        //     Container(
        //       height: 48.0,
        //       decoration: BoxDecoration(
        //         color: context.cardColor,
        //         borderRadius: BorderRadius.circular(12.0),
        //       ),
        //       child: Center(
        //         child: ValueListenableBuilder(
        //           valueListenable: _valueNotifier,
        //           builder: (context, value, child) => Row(
        //             children: [
        //               Text(
        //                 "+${selectedCountry.phoneCode}",
        //                 style: primaryTextStyle(size: 12),
        //               ),
        //               Icon(
        //                 Icons.arrow_drop_down,
        //                 color: textSecondaryColorGlobal,
        //               )
        //             ],
        //           ).paddingOnly(left: 8),
        //         ),
        //       ),
        //     ).onTap(() => changeCountry()),
        //     10.width,
        //     // Mobile number text field...
        //     AppTextField(
        //       textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
        //       controller: mobileCont,
        //       focus: mobileFocus,
        //       errorThisFieldRequired: language.requiredText,
        //       nextFocus: passwordFocus,
        //       isValidationRequired: false,
        //       decoration: inputDecoration(context, labelText: "${language.hintContactNumberTxt}").copyWith(
        //         hintText: '${language.lblExample}: ${selectedCountry.example}',
        //         hintStyle: secondaryTextStyle(),
        //       ),
        //       maxLength: 15,
        //       suffix: ic_calling.iconImage(size: 10).paddingAll(14),
        //     ).expand(),
        //   ],
        // ),
        // 8.height,
        // if (!widget.isOTPLogin)
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       4.height,
        //       AppTextField(
        //         textFieldType: TextFieldType.PASSWORD,
        //         controller: passwordCont,
        //         focus: passwordFocus,
        //         readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
        //         suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
        //         suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
        //         errorThisFieldRequired: language.requiredText,
        //         decoration: inputDecoration(context, labelText: language.hintPasswordTxt),
        //         onFieldSubmitted: (s) {
        //           // if (widget.isOTPLogin) {
        //           //   registerWithOTP();
        //           // } else {
        //           //   registerUser();
        //           // }
        //         },
        //       ),
        //       20.height,
        //     ],
        //   ),
        // _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: language.signUp.toUpperCase(),
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
              if(formKey.currentState!.validate()) {
                registerUser();

            }
          },
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${language.lblAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: language.lblTermsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(appConfigurationStore.termConditions, launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.privacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(appConfigurationStore.privacyPolicy, launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${language.alreadyHaveAccountTxt} ? ", style: secondaryTextStyle()),
            TextSpan(
              text: language.signIn,
              style: boldTextStyle(color: primaryColor, size: 16),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.scaffoldBackgroundColor,
          leading: BackWidget(iconColor: context.iconColor),
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Form(
                key: formKey,
                autovalidateMode: isFirstTimeValidation ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    20.height,
                    _buildTopWidget(),
                    _buildFormWidget(),
                    8.height,
                    _buildFooterWidget(),
                  ],
                ).paddingAll(16),
              ),
              Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
