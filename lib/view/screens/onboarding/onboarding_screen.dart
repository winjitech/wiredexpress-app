import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/onboarding_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/auth/login_social_account_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false)
        .initBoardingList(context);

    List tips = [
      {
        'index': 0,
        'title': getTranslated('tip_1', context),
        'image': Images.diet_tip_1,
      },
      {
        'index': 1,
        'title': getTranslated('tip_2', context),
        'image': Images.diet_tip_2,
      },
      {
        'index': 2,
        'title': getTranslated('tip_3', context),
        'image': Images.diet_tip_3,
      },
      {
        'index': 3,
        'title': getTranslated('tip_4', context),
        'image': Images.diet_tip_3,
      },
    ];
    return Scaffold(
      backgroundColor: ColorResources.SCAFFOLD_COLOR,
      // backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: Consumer<OnBoardingProvider>(
          builder: (context, onBoardingList, child) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // onBoardingList.selectedIndex != tips.length - 1
                //     ? Align(
                //         alignment: Alignment.topRight,
                //         child: TextButton(
                //             onPressed: () {
                //               // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MyDietPlan(mealType: 'meal_1', mealNo: 0)));
                //             },
                //             child: Text(
                //               getTranslated('skip', context),
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .headline3!
                //                   .copyWith(
                //                       color: Theme.of(context)
                //                           .textTheme
                //                           .bodyText1!
                //                           .color),
                //             )),
                //       )
                //     : SizedBox(),
                Positioned(
                  top: 130,
                  right: 60,
                  left: 60,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: Colors.grey[850]),
                    child: Center(child: Text("logo")),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 360,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                      child: PageView.builder(
                        itemCount: tips.length,
                        controller: _pageController,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  getTranslated(
                                      'find_your_perfect_electronic', context),
                                  textAlign: TextAlign.justify,
                                  style: rubikMedium.copyWith(
                                    fontSize: 35,
                                  ),
                                )),
                                Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Text(tips[index]['title']),

                                  // child: Image.asset(tips[index]['image']),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _pageIndicators(tips, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        onBoardingList.selectedIndex !=
                                                tips.length - 1
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  LoginScreen()));
                                                    },
                                                    child: Text(
                                                      getTranslated(
                                                          'skip', context),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
                                                    )),
                                              )
                                            : SizedBox(),
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorResources.SCAFFOLD_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                            onPressed: () {
                                              onBoardingList.selectedIndex == 3
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              LoginScreen()))
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (BuildContext
                                                  //         context) =>
                                                  //             LoginSocialAccountScreen()))
                                                  : _pageController.nextPage(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      curve: Curves.ease);
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: ColorResources.COLOR_WHITE,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          onBoardingList.changeSelectIndex(index);
                        },
                      ),
                    ),
                  ),
                ),

                // Column(
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: _pageIndicators(tips, context),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(
                //           left: 60, right: 60, top: 50, bottom: 22),
                //       child: Text(
                //         onBoardingList.selectedIndex == 0
                //             ? tips[0]['title']
                //             : onBoardingList.selectedIndex == 1
                //                 ? tips[1]['title']
                //                 : tips[2]['title'],
                //         style: Theme.of(context)
                //             .textTheme
                //             .headline3!
                //             .copyWith(
                //                 fontSize: 24.0,
                //                 color: Theme.of(context)
                //                     .textTheme
                //                     .bodyText1!
                //                     .color),
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //     Container(
                //       padding: EdgeInsets.all(
                //           onBoardingList.selectedIndex == 2 ? 0 : 22),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           onBoardingList.selectedIndex == 0 ||
                //                   onBoardingList.selectedIndex == 2
                //               ? SizedBox.shrink()
                //               : TextButton(
                //                   onPressed: () {
                //                     _pageController.previousPage(
                //                         duration: Duration(seconds: 1),
                //                         curve: Curves.ease);
                //                   },
                //                   child: Text(
                //                     getTranslated('previous', context),
                //                     style: Theme.of(context)
                //                         .textTheme
                //                         .headline3!
                //                         .copyWith(
                //                             color: ColorResources
                //                                 .getGrayColor(context)),
                //                   )),
                //           onBoardingList.selectedIndex == 2
                //               ? SizedBox.shrink()
                //               : TextButton(
                //                   onPressed: () {
                //                     _pageController.nextPage(
                //                         duration: Duration(seconds: 1),
                //                         curve: Curves.ease);
                //                   },
                //                   child: Text(
                //                     getTranslated('next', context),
                //                     style: Theme.of(context)
                //                         .textTheme
                //                         .headline3!
                //                         .copyWith(
                //                             color: ColorResources
                //                                 .getGrayColor(context)),
                //                   )),
                //         ],
                //       ),
                //     ),
                //     onBoardingList.selectedIndex == 2
                //         ? Padding(
                //             padding: EdgeInsets.all(
                //                 Dimensions.PADDING_SIZE_LARGE),
                //             child: CustomButton(
                //               text:
                //                   getTranslated('lets_start', context),
                //               onTap: () async {
                //                 SharedPreferences prefs =
                //                     await SharedPreferences.getInstance();
                //                 prefs.setInt('diet_tips_screen', 1);
                //                 onBoardingList.changeSelectIndex(0);
                //                 // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> MyDietPlan(mealType: 'meal_1', mealNo: 0)));
                //               },
                //             ))
                //         : SizedBox.shrink()
                //   ],
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex
              ? 7
              : 7,
          height: 7,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                ? ColorResources.SCAFFOLD_COLOR
                : ColorResources.getGrayColor(context),
            borderRadius:
                i == Provider.of<OnBoardingProvider>(context).selectedIndex
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
