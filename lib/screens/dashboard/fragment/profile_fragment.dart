import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/about_screen.dart';
import 'package:booking_system_flutter/screens/auth/edit_profile_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/blog/view/blog_list_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/customer_rating_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/service/favourite_service_screen.dart';
import 'package:booking_system_flutter/screens/setting_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_configuration.dart';
import '../../bankDetails/view/bank_details.dart';
import '../../favourite_provider_screen.dart';
import '../component/wallet_history.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<num>? futureWalletBalance;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  Future<void> init() async {
    if (appStore.isLoggedIn) {
      appStore.setUserWalletAmount();
      userDetailAPI();
    }
  }

  Future<void> userDetailAPI() async {
    await getUserDetail(appStore.userId, forceUpdate: false)
        .then((value) async {
      await saveUserData(value, forceSyncAppConfigurations: false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.profile,
        textColor: white,
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 0.0,
        color: context.primaryColor,
        showBack: false,
        actions: [
          IconButton(
            icon: ic_setting.iconImage(color: white, size: 20),
            onPressed: () async {
              SettingScreen().launch(context);
            },
          ),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                padding: EdgeInsets.only(bottom: 32),
                crossAxisAlignment: CrossAxisAlignment.center,
                onSwipeRefresh: () async {
                  await removeKey(LAST_USER_DETAILS_SYNCED_TIME);
                  init();
                  setState(() {});
                  return 1.seconds.delay;
                },
                children: [
                  if (appStore.isLoggedIn)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        24.height,
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: boxDecorationDefault(
                                border:
                                    Border.all(color: primaryColor, width: 3),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: boxDecorationDefault(
                                  border: Border.all(
                                      color: context.scaffoldBackgroundColor,
                                      width: 4),
                                  shape: BoxShape.circle,
                                ),
                                child: CachedImageWidget(
                                  url: appStore.userProfileImage,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  radius: 60,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 8,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(6),
                                decoration: boxDecorationDefault(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                  border: Border.all(
                                      color: context.cardColor, width: 2),
                                ),
                                child: Icon(AntDesign.edit,
                                    color: white, size: 18),
                              ).onTap(() {
                                EditProfileScreen().launch(context);
                              }),
                            ),
                          ],
                        ),
                        16.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(appStore.userFullName,
                                style: boldTextStyle(
                                    color: primaryColor, size: 16)),
                          ],
                        ),
                        24.height,
                      ],
                    ).center(),
                  Observer(builder: (context) {
                    return SettingSection(
                      title: Text(language.lblGENERAL,
                          style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.1)),
                      divider: Offstage(),
                      items: [
                        // if (appStore.isLoggedIn && appConfigurationStore.isEnableUserWallet)
                        //   SettingItemWidget(
                        //     leading: ic_un_fill_wallet.iconImage(size: SETTING_ICON_SIZE),
                        //     title: language.walletBalance,
                        //     titleTextStyle: primaryTextStyle(),
                        //     onTap: () {
                        //       if (appConfigurationStore.onlinePaymentStatus) {
                        //         // UserWalletBalanceScreen().launch(context);
                        //       }
                        //     },
                        //     trailing: Text(
                        //       appStore.userWalletAmount.toPriceFormat(),
                        //       style: boldTextStyle(color: Colors.green),
                        //     ),
                        //   ),
                        // 16.height,
                        // if (appStore.isLoggedIn &&
                        //     appConfigurationStore.isEnableUserWallet)
                        //   SettingItemWidget(
                        //     leading:
                        //         ic_document.iconImage(size: SETTING_ICON_SIZE),
                        //     title: language.walletHistory,
                        //     titleTextStyle: primaryTextStyle(),
                        //     trailing: trailing,
                        //     onTap: () {
                        //       UserWalletHistoryScreen().launch(context);
                        //     },
                        //   ),
                        // if (appStore.isLoggedIn)
                        //   SettingItemWidget(
                        //     leading:
                        //         ic_document.iconImage(size: SETTING_ICON_SIZE),
                        //     title: language.lblBankDetails,
                        //     titleTextStyle: primaryTextStyle(),
                        //     trailing: trailing,
                        //     onTap: () {
                        //       BankDetails().launch(context);
                        //     },
                        //   ),
                        SettingItemWidget(
                          leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblFavorite,
                          titleTextStyle: primaryTextStyle(),
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteServiceScreen().launch(context);
                            });
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                          title: language.favouriteProvider,
                          titleTextStyle: primaryTextStyle(),
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              FavouriteProviderScreen().launch(context);
                            });
                          },
                        ),
                        if (appConfigurationStore.blogStatus)
                          SettingItemWidget(
                            leading:
                                ic_document.iconImage(size: SETTING_ICON_SIZE),
                            title: language.blogs,
                            titleTextStyle: primaryTextStyle(),
                            trailing: trailing,
                            onTap: () {
                              BlogListScreen().launch(context);
                            },
                          ),
                        SettingItemWidget(
                          leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                          title: language.rateUs,
                          titleTextStyle: primaryTextStyle(),
                          trailing: trailing,
                          onTap: () async {
                            if (isAndroid) {
                              if (getStringAsync(CUSTOMER_PLAY_STORE_URL)
                                  .isNotEmpty) {
                                commonLaunchUrl(
                                    getStringAsync(CUSTOMER_PLAY_STORE_URL),
                                    launchMode: LaunchMode.externalApplication);
                              } else {
                                commonLaunchUrl(
                                    '${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}',
                                    launchMode: LaunchMode.externalApplication);
                              }
                            } else if (isIOS) {
                              if (getStringAsync(CUSTOMER_APP_STORE_URL)
                                  .isNotEmpty) {
                                commonLaunchUrl(
                                    getStringAsync(CUSTOMER_APP_STORE_URL),
                                    launchMode: LaunchMode.externalApplication);
                              } else {
                                commonLaunchUrl(IOS_LINK_FOR_USER,
                                    launchMode: LaunchMode.externalApplication);
                              }
                            }
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                          title: language.myReviews,
                          titleTextStyle: primaryTextStyle(),
                          trailing: trailing,
                          onTap: () async {
                            doIfLoggedIn(context, () {
                              CustomerRatingScreen().launch(context);
                            });
                          },
                        ),
                      ],
                    );
                  }),
                  SettingSection(
                    title: Text(language.lblAboutApp.toUpperCase(),
                        style: boldTextStyle(color: primaryColor)),
                    headingDecoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1)),
                    divider: Offstage(),
                    items: [
                      8.height,
                      SettingItemWidget(
                        leading: ic_about_us.iconImage(size: SETTING_ICON_SIZE),
                        title: language.lblAboutApp,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          AboutScreen().launch(context);
                        },
                      ),
                      SettingItemWidget(
                        leading:
                            ic_shield_done.iconImage(size: SETTING_ICON_SIZE),
                        title: language.privacyPolicy,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          checkIfLink(
                              context, appConfigurationStore.privacyPolicy,
                              title: language.privacyPolicy);
                        },
                      ),
                      SettingItemWidget(
                        leading: ic_document.iconImage(size: SETTING_ICON_SIZE),
                        title: language.termsCondition,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          checkIfLink(
                              context, appConfigurationStore.termConditions,
                              title: language.termsCondition);
                        },
                      ),
                      SettingItemWidget(
                        leading: ic_document.iconImage(size: SETTING_ICON_SIZE),
                        title: language.refundPolicy,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          checkIfLink(
                              context, appConfigurationStore.refundPolicy,
                              title: language.refundPolicy);
                        },
                      ),
                      if (appConfigurationStore.helpAndSupport.isNotEmpty)
                        SettingItemWidget(
                          leading: ic_helpAndSupport.iconImage(
                              size: SETTING_ICON_SIZE),
                          title: language.helpSupport,
                          titleTextStyle: primaryTextStyle(),
                          onTap: () {
                            if (appConfigurationStore
                                .helpAndSupport.isNotEmpty) {
                              checkIfLink(
                                  context, appConfigurationStore.helpAndSupport,
                                  title: language.helpSupport);
                            } else {
                              checkIfLink(context,
                                  appConfigurationStore.inquiryEmail.validate(),
                                  title: language.helpSupport);
                            }
                          },
                        ),
                      if (appConfigurationStore.helplineNumber.isNotEmpty)
                        SettingItemWidget(
                          leading:
                              ic_calling.iconImage(size: SETTING_ICON_SIZE),
                          title: language.lblHelplineNumber,
                          titleTextStyle: primaryTextStyle(),
                          onTap: () {
                            launchCall(appConfigurationStore.helplineNumber
                                .validate());
                          },
                        ),
                      SettingItemWidget(
                        leading: Icon(MaterialCommunityIcons.logout,
                            color: context.iconColor, size: SETTING_ICON_SIZE),
                        title: language.signIn,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          SignInScreen().launch(context);
                        },
                      ).visible(!appStore.isLoggedIn),
                    ],
                  ),
                  SettingSection(
                    title: Text(language.lblDangerZone.toUpperCase(),
                        style: boldTextStyle(color: redColor)),
                    headingDecoration:
                        BoxDecoration(color: redColor.withOpacity(0.08)),
                    divider: Offstage(),
                    items: [
                      8.height,
                      SettingItemWidget(
                        leading: ic_delete_account.iconImage(
                            size: SETTING_ICON_SIZE),
                        paddingBeforeTrailing: 4,
                        title: language.lblDeleteAccount,
                        titleTextStyle: primaryTextStyle(),
                        onTap: () {
                          showConfirmDialogCustom(
                            context,
                            negativeText: language.lblCancel,
                            positiveText: language.lblDelete,
                            onAccept: (_) {
                              ifNotTester(() {
                                appStore.setLoading(true);

                                deleteAccountCompletely().then((value) async {
                                  try {
                                    await userService
                                        .removeDocument(appStore.uid);
                                    await userService.deleteUser();
                                  } catch (e) {
                                    print(e);
                                  }

                                  appStore.setLoading(false);

                                  await clearPreferences();
                                  toast(value.message);

                                  push(DashboardScreen(),
                                      isNewTask: true,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Fade);
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                  toast(e.toString());
                                });
                              });
                            },
                            dialogType: DialogType.DELETE,
                            title: language.lblDeleteAccountConformation,
                          );
                        },
                      ).paddingOnly(left: 4),
                      64.height,
                      TextButton(
                        child: Text(language.logout,
                            style:
                                boldTextStyle(color: primaryColor, size: 16)),
                        onPressed: () {
                          logout(context);
                        },
                      ).center(),
                    ],
                  ).visible(appStore.isLoggedIn),
                  30.height.visible(!appStore.isLoggedIn),
                  SnapHelperWidget<PackageInfoData>(
                    future: getPackageInfo(),
                    onSuccess: (data) {
                      return TextButton(
                        child: VersionInfoWidget(
                            prefixText: 'v', textStyle: secondaryTextStyle()),
                        onPressed: () {
                          showAboutDialog(
                            context: context,
                            applicationName: APP_NAME,
                            applicationVersion: data.versionName,
                            applicationIcon: Image.asset(appLogo, height: 50),
                          );
                        },
                      ).center();
                    },
                  ),
                ],
              ),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          );
        },
      ),
    );
  }
}
