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
      child:  AnimatedListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 16, top: 16, right: 8, left: 8),
        itemCount: 5,
        shrinkWrap: true,
        listAnimationType: ListAnimationType.None,
        itemBuilder: (_, index) {
          return Container(
            width: context.width(),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: context.scaffoldBackgroundColor, border: Border.all(color: context.dividerColor), borderRadius: radius()),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(height: 50, width: 50),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(borderRadius: radius(20), color: Colors.transparent),
                              child: ShimmerWidget(height: 20, width: context.width() * 0.24),
                            ).flexible(),
                            8.width,
                            ShimmerWidget(height: 20, width: 50),
                          ],
                        ),
                        4.height,
                        ShimmerWidget(height: 20, width: context.width()),
                        4.height,
                        ShimmerWidget(height: 20, width: context.width()),
                      ],
                    ).expand(),
                  ],
                ).paddingAll(8),
              ],
            ).paddingAll(8),
          );
        },
      ),
    );
  }
}
