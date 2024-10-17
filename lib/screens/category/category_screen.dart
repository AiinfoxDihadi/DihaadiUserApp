import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/category_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/category/shimmer/category_shimmer.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../utils/constant.dart';
import '../service/view_all_service_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryData>> future;
  List<CategoryData> categoryList = [];

  int page = 1;
  bool isLastPage = false;
  bool isApiCalled = false;

  UniqueKey key = UniqueKey();

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCategoryListWithPagination(page, categoryList: categoryList,
        lastPageCallBack: (val) {
      isLastPage = val;
    });
    if (page == 1) {
      key = UniqueKey();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.category,
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
      body: Stack(
        children: [
          SnapHelperWidget<List<CategoryData>>(
            initialData: cachedCategoryList,
            future: future,
            loadingWidget: CategoryShimmer(),
            onSuccess: (snap) {
              if (snap.isEmpty) {
                return NoDataWidget(
                  title: language.noCategoryFound,
                  imageWidget: EmptyStateWidget(),
                );
              }

              return AnimatedScrollView(
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                children: [
                  10.height,
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.length,itemBuilder: (c,i) {
                    CategoryData data = snap[i];
                    return GestureDetector(
                    onTap: () {
                      ViewAllServiceScreen(
                          categoryId: data.id.validate(),
                          categoryName: data.name,
                          isFromCategory: true)
                          .launch(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(bottom: 15,left: 15,right: 15),
                          child: Row(
                            children: [
                              snap[i]
                                  .categoryImage
                                  .validate()
                                  .endsWith('svg')
                                  ? SvgPicture.network(
                                snap[i].categoryImage.validate(),
                                height: 40,
                                width: 40,
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : data.color
                                    .validate(value: '000')
                                    .toColor(),
                                placeholderBuilder: (context) =>
                                    PlaceHolderWidget(
                                        height: 40,
                                        width: 40,
                                        color: transparentColor),
                              )
                                  : Center(
                                child: CachedImageWidget(
                                  url: (snap[i].categoryImage).validate(),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  radius: 8,
                                  color:  appStore.isDarkMode ? Colors.white : Colors.black,
                                  circle: true,
                                  placeHolderImage: '',
                                ),
                              ),
                              20.width,
                              Text(
                                snap[i].name ?? '',
                                style: boldTextStyle(),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: context.dividerColor, width: 1.5)),
                        ),
                        Positioned(
                          right: 0,
                          top:25,
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
                    ),
                  );}),
                  // GridView.builder(
                  //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: snap.length,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 2,
                  //       mainAxisSpacing: 15,
                  //       crossAxisSpacing: 15),
                  //   itemBuilder: (BuildContext context, int i) {
                  //     CategoryData data = snap[i];
                  //     return GestureDetector(
                  //       onTap: () {
                  //         ViewAllServiceScreen(
                  //                 categoryId: data.id.validate(),
                  //                 categoryName: data.name,
                  //                 isFromCategory: true)
                  //             .launch(context);
                  //       },
                  //       child: Container(
                  //         child: Column(
                  //           children: [
                  //             Container(
                  //               decoration: BoxDecoration(
                  //                   color: Color(0xffDADAED).withOpacity(0.3),
                  //                   borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(10),
                  //                       topRight: Radius.circular(10))),
                  //               height:
                  //                   MediaQuery.sizeOf(context).height * 0.14,
                  //               width: double.infinity,
                  //               child: snap[i]
                  //                       .categoryImage
                  //                       .validate()
                  //                       .endsWith('svg')
                  //                   ? SvgPicture.network(
                  //                       snap[i].categoryImage.validate(),
                  //                       height: CATEGORY_ICON_SIZE,
                  //                       width: CATEGORY_ICON_SIZE,
                  //                       color: appStore.isDarkMode
                  //                           ? Colors.white
                  //                           : data.color
                  //                               .validate(value: '000')
                  //                               .toColor(),
                  //                       placeholderBuilder: (context) =>
                  //                           PlaceHolderWidget(
                  //                               height: CATEGORY_ICON_SIZE,
                  //                               width: CATEGORY_ICON_SIZE,
                  //                               color: transparentColor),
                  //                     )
                  //                   : Center(
                  //                       child: CachedImageWidget(
                  //                         url: (snap[i].categoryImage)
                  //                             .validate(),
                  //                         fit: BoxFit.cover,
                  //                         width: 90,
                  //                         height: 90,
                  //                         radius: 8,
                  //                         circle: true,
                  //                         placeHolderImage: '',
                  //                       ),
                  //                     ),
                  //             ),
                  //             10.height,
                  //             Text(
                  //               snap[i].name ?? '',
                  //               style: boldTextStyle(),
                  //             )
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             border: Border.all(
                  //                 color: Color(0xffEBEBEB), width: 1.5)),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ),
          Observer(
              builder: (BuildContext context) =>
                  LoaderWidget().visible(appStore.isLoading.validate())),
        ],
      ),
    );
  }
}
