import 'package:booking_system_flutter/component/shimmer_widget.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      physics: AlwaysScrollableScrollPhysics(),
      child: AnimatedWrap(
        key: key,
        runSpacing: 16,
        spacing: 16,
        itemCount: 16,
        listAnimationType: ListAnimationType.None,
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 15,left: 15,right: 15),
            child: Row(
              children: [
                Center(
                  child: ShimmerWidget(
                    width: 40,
                    height: 40,
                  ),
                ),
                20.width,
                ShimmerWidget(height: 20,width: 50)
              ],
            ),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Color(0xffEBEBEB), width: 1.5)),
          );
        },
      ),
    );
  }
}
