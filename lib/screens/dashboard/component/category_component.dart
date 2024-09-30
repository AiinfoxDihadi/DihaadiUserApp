import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/screens/category/category_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryComponent extends StatefulWidget {
  final List<CategoryData>? categoryList;
  final bool isNewDashboard;

  CategoryComponent({this.categoryList, this.isNewDashboard = false});

  @override
  CategoryComponentState createState() => CategoryComponentState();
}

class CategoryComponentState extends State<CategoryComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label:
              widget.isNewDashboard ? language.lblCategory : language.category,
          list: widget.categoryList!,
          trailingTextStyle: widget.isNewDashboard
              ? boldTextStyle(color: primaryColor, size: 12)
              : null,
          onTap: () {
            CategoryScreen().launch(context).then((value) {
              setStatusBarColor(Colors.transparent);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        GridView.builder(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.categoryList?.length ?? 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
          itemBuilder: (BuildContext context, int i) {
            return GestureDetector(
              onTap: () {},
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
                      child: CachedImageWidget(
                        url: (widget.categoryList?[i].categoryImage).validate(),
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        radius: 8,
                        circle: true,
                        placeHolderImage: '',
                      ),
                    ),
                    10.height,
                    Text(
                      widget.categoryList?[i].name ?? '',
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
      ],
    );
  }
}
