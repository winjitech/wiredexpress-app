import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';

class RateAppScreen extends StatefulWidget {
  final bool? fromHome;
  final int? rating;
  RateAppScreen({@required this.fromHome, @required this.rating});
  @override
  _RateAppScreenState createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool? _isLoggedIn;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('rate_review_app', context)),
      body: _isLoggedIn!
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: profileProvider.loadingAppReview
                              ? CustomCircularIndicator(color:ColorResources.getScaffoldColor(context))
                              : Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 100),
                                        widget.fromHome!
                                            ? SizedBox()
                                            : SizedBox(
                                                height: 30,
                                                child: ListView.builder(
                                                  itemCount: 5,
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, i) {
                                                    return GestureDetector(
                                                      child: Icon(
                                                        profileProvider
                                                                    .appRating <
                                                                (i + 1)
                                                            ? Icons.star_border
                                                            : Icons.star,
                                                        //  Icons.star,
                                                        size: 25,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      onTap: () {
                                                        profileProvider
                                                            .setAppRating(
                                                                i + 1);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        Text(
                                          getTranslated(
                                              'share_your_opinion', context),
                                          style: rubikMedium.copyWith(
                                              color: ColorResources
                                                  .getGreyBunkerColor(context)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        CustomTextField(
                                          maxLines: 5,
                                          capitalization:
                                              TextCapitalization.sentences,
                                          controller: _controller,
                                          hintText: getTranslated(
                                              'write_your_review_here',
                                              context),
                                          fillColor: ColorResources.getSearchBg(
                                              context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    !profileProvider.loadingAppReview
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: CustomButton(
                                text: getTranslated('submit', context),
                                onTap: () async {
                                  String _review;
                                  String rating;
                                  if (_controller.text.trim().isEmpty) {
                                    _review = '';
                                  } else {
                                    _review = _controller.text.trim();
                                  }
                                  if (widget.rating != null) {
                                    rating = widget.rating.toString();
                                  } else {
                                    rating =
                                        profileProvider.appRating.toString();
                                  }
                                  ResponseModel _responseModel =
                                      await profileProvider.sendAppReview(
                                    _review,
                                    rating,
                                  );
                                  if (_responseModel.isSuccess) {
                                    profileProvider.getUserInfo(context);
                                    showCustomSnackBar(
                                        getTranslated(
                                            'updated_successfully', context),
                                        context,
                                        isError: false);
                                    Navigator.pop(context);
                                    // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                  } else {
                                    showCustomSnackBar(
                                        _responseModel.message, context);
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        : Center(child: SizedBox()),
                  ],
                );
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
