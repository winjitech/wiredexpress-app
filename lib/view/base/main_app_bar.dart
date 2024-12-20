import 'package:flutter/material.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  // Navigator.pushNamed(context, Routes.getMainRoute()),
                  child: Provider.of<SplashProvider>(context).baseUrls != null
                      ? Consumer<SplashProvider>(
                          builder: (context, splash, child) =>
                              FadeInImage.assetNetwork(
                                  placeholder: Images.loading,
                                  image:
                                      '${splash.baseUrls!.storeImageUrl}/${splash.configModel!.storeLogo}',
                                  width: 120,
                                  height: 80))
                      : SizedBox(),
                ),
              ),
              // MenuBar(),
            ],
          )),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
