import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';

class UpdateAppScreen extends StatefulWidget {
  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {


  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  bool? _isLoggedIn;

  Future<bool> _onWillPop() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop'); return false;

  }

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
    return WillPopScope(child: Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      key: _scaffoldKey,

      body: _isLoggedIn!
          ? Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return profileProvider.userInfoModel != null
              ? Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(
                        Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: 300),

                            Padding(padding: EdgeInsets.only(left: 15, right: 15),
                                child: Center(
                                  child: Text(
                                    getTranslated('old_version', context),
                                    style: TextStyle(
                                        color: ColorResources
                                            .getHintColor(context)),
                                  ),
                                )
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              !profileProvider.isLoading
                  ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL),
                  child: CustomButton(
                    text: getTranslated(
                        'update_now', context),
                    onTap: () async {
                      //LaunchReview.launch();
                      setState(() {

                      });
                    },
                  ),
                ),
              )
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ],
          )
              : Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)));
        },
      )
          : NotLoggedInScreen(),
    ), onWillPop: _onWillPop);
  }
}
