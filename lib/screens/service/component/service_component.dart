import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/disabled_rating_bar_widget.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/component/price_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/screens/newDashboard/dashboard_4/component/service_dashboard_component_4.dart';
import 'package:booking_system_flutter/screens/service/service_detail_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../newDashboard/dashboard_1/component/service_dashboard_component_1.dart';
import '../../newDashboard/dashboard_2/component/service_dashboard_component_2.dart';
import '../../newDashboard/dashboard_3/component/service_dashboard_component_3.dart';

class ServiceComponent extends StatefulWidget {
  final ServiceData serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromDashboard;
  final bool isFromViewAllService;
  final bool isFromServiceDetail;

  ServiceComponent({
    required this.serviceData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
    this.isFromDashboard = false,
    this.isFromViewAllService = false,
    this.isFromServiceDetail = false,
  });

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildServiceComponent() {
      return Observer(builder: (context) {
        if (appConfigurationStore.userDashboardType == DASHBOARD_1) {
          return ServiceDashboardComponent1(
            serviceData: widget.serviceData,
            width: widget.width != null
                ? widget.width
                : widget.isFromViewAllService
                    ? null
                    : 280,
            isFavouriteService: widget.isFavouriteService,
            isBorderEnabled: widget.isBorderEnabled,
            isFromDashboard: widget.isFromDashboard,
            onUpdate: () {
              widget.onUpdate?.call();
            },
          );
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_2) {
          return ServiceDashboardComponent2(
            serviceData: widget.serviceData,
            width: widget.width != null
                ? widget.width
                : widget.isFromViewAllService
                    ? null
                    : 280,
            isFavouriteService: widget.isFavouriteService,
            isBorderEnabled: widget.isBorderEnabled,
            isFromDashboard: widget.isFromDashboard,
            onUpdate: () {
              widget.onUpdate?.call();
            },
          );
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_3) {
          return ServiceDashboardComponent3(
            serviceData: widget.serviceData,
            isFavouriteService: widget.isFavouriteService,
            isBorderEnabled: widget.isBorderEnabled,
            isFromDashboard: widget.isFromDashboard,
            width: widget.width != null
                ? widget.width
                : widget.isFromViewAllService
                    ? null
                    : 280,
            onUpdate: () {
              widget.onUpdate?.call();
            },
          );
        } else if (appConfigurationStore.userDashboardType == DASHBOARD_4) {
          return ServiceDashboardComponent4(
            serviceData: widget.serviceData,
            isFavouriteService: widget.isFavouriteService,
            isBorderEnabled: widget.isBorderEnabled,
            width: widget.width != null
                ? widget.width
                : widget.isFromViewAllService
                    ? null
                    : 280,
            isFromDashboard: widget.isFromDashboard,
            onUpdate: () {
              widget.onUpdate?.call();
            },
          );
        } else {
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                height: 100,
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(),
                  backgroundColor: context.cardColor,
                  border: widget.isBorderEnabled.validate(value: false)
                      ? appStore.isDarkMode
                          ? Border.all(color: context.dividerColor)
                          : null
                      : null,
                ),
                width: widget.width,
                child: Row(
                  children: [
                    15.width,
                    ImageBorder(
                      galley: false,
                        src: widget.serviceData.providerImage.validate(),
                        height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.serviceData.providerName
                            .validate()
                            .isNotEmpty)
                          Text(
                            widget.serviceData.providerName.validate(),
                            style: boldTextStyle(size: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text((widget.serviceData.name).validate(),
                            style: secondaryTextStyle(
                                size: 12,
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : appTextSecondaryColor)),
                        4.height,
                        DisabledRatingBarWidget(
                            rating: widget.serviceData.totalRating.validate(),
                            size: 14),
                      ],
                    ).paddingSymmetric(horizontal: 16),

                  ],
                ),
              ),
              Positioned(
                  right: 0,
                  top:35,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: RotatedBox(quarterTurns: 2,
                        child: Icon(Icons.arrow_back_ios_new_sharp,size: 15,color: Colors.white,)),
                  ))
            ],
          );
        }
      });
    }

    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
          serviceId: widget.isFavouriteService
              ? widget.serviceData.serviceId.validate().toInt()
              : widget.serviceData.id.validate(),
        ).launch(context).then((value) {
          setStatusBarColor(context.primaryColor);
          widget.onUpdate?.call();
        });
      },
      child: buildServiceComponent(),
    );
  }
}
