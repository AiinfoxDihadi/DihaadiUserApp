import 'package:booking_system_flutter/aiinfox/mockdata/categorydata.dart';
import 'package:booking_system_flutter/aiinfox/screens/service_providers.dart';
import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryNewWidget extends StatelessWidget {
  const CategoryNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Services',
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
      body: GridView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        shrinkWrap: true,
        itemCount: categotyData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () {
              ServiceProvidersNew(name: categotyData[i].name.toString())
                  .launch(context);
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffDADAED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    width: double.infinity,
                    child: Image.asset(
                      categotyData[i].icon.toString(),
                      scale: 5,
                    ),
                  ),
                  10.height,
                  Text(
                    categotyData[i].name ?? '',
                    style: boldTextStyle(),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffEBEBEB))),
            ),
          );
        },
      ),
    );
  }
}
