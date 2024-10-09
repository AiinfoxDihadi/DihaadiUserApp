import 'package:booking_system_flutter/component/shimmer_widget.dart';
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
          return ShimmerWidget(
            child: GridView.builder(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffDADAED).withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        height:
                        MediaQuery.sizeOf(context).height * 0.14,
                        width: double.infinity,
                        child: SizedBox.shrink()
                        ),
                      10.height,
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color(0xffEBEBEB), width: 1.5)),
                );
              },
            )
          );
        },
      ),
    );
  }
}
