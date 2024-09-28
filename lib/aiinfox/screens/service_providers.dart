import 'package:booking_system_flutter/aiinfox/mockdata/servicedata.dart';
import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceProvidersNew extends StatelessWidget {
  final String name;
  const ServiceProvidersNew({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        name,
        textColor: Colors.white,
        textSize: APP_BAR_TEXT_SIZE,
        color: primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.light,
            statusBarColor: context.primaryColor),
        showBack: Navigator.canPop(context),
        backWidget: BackWidget(),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        shrinkWrap: true,
        itemCount: serviceData.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                ),
                20.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceData[index].name ?? '',
                      style: boldTextStyle(size: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          serviceData[index].rating ?? '',
                          style: primaryTextStyle(size: 12),
                        ),
                        10.width,
                        RatingBarIndicator(
                          itemCount: 5,
                          itemSize: 15.0,
                          unratedColor: Colors.amber.withAlpha(90),
                          rating: serviceData[index].rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xffEBEBEB))),
          );
        },
      ),
    );
  }
}
