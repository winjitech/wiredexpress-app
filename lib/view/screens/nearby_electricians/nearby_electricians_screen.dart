import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/area_model.dart';
import 'package:wired_express/data/model/response/electrician_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyElectriciansScreen extends StatefulWidget {
  final List<ElectricianModel> electricians;

  const NearbyElectriciansScreen({super.key, required this.electricians});

  @override
  State<NearbyElectriciansScreen> createState() =>
      _NearbyElectriciansScreenState();
}

class _NearbyElectriciansScreenState extends State<NearbyElectriciansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final splashProvider =
      Provider.of<SplashProvider>(context, listen: false);
    });
  }

  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchMaps(double lat, double long) async {
    Uri launchUri;

    if (Platform.isIOS) {
      // Apple Maps URL scheme
      launchUri = Uri(
        scheme: 'https',
        host: 'maps.apple.com',
        path: '/',
        queryParameters: {
          'q': '$lat,$long',
          'z': '15', // Zoom level (optional)
        },
      );
    } else {
      // Default to Google Maps
      launchUri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: '/maps/@$lat,$long,15z',
      );
    }

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title:  'nearby_electricians', showBackButton: true),
          Expanded(
            child: Consumer<CustomAuthProvider>(
              builder: (context, auth, child) {
                return Column(
                  children: [
                    Expanded(
                      child: Consumer2<CustomAuthProvider, SplashProvider>(
                        builder: (context, auth, splashProvider, child) {
                          return Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    itemCount: widget.electricians.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      ElectricianModel electrician = widget.electricians[index];
                                      AreaModel area = electrician.area!;
                                      return Container(
                                        padding: EdgeInsets.all(15.r),
                                        margin: EdgeInsets.only(bottom: 15.h),
                                        decoration: BoxDecoration(
                                          color: ColorResources.getTextFieldFillColor(context),
                                          borderRadius: BorderRadius.circular(15.r)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.r),
                                                  child: CachedNetworkImage(
                                                    height: 80.h,
                                                    width: 80.w,
                                                    fit: BoxFit.cover,
                                                    imageUrl: "${splashProvider.configModel?.baseUrls?.electricianImageUrl}/${electrician.image}",
                                                    cacheKey: "${splashProvider.configModel?.baseUrls?.electricianImageUrl}/${electrician.image}",
                                                  ),
                                                ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        electrician.name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: AppTextStyles.h5(context).copyWith(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Text(
                                                        area.name!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: AppTextStyles.h6(context).copyWith(
                                                          color: ColorResources.getTextColor(context).withOpacity(0.6),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        children: [
                                                          Expanded(child: ElevatedButton.icon(
                                                            icon: Icon(
                                                              Icons.phone,
                                                              color: ColorResources.getScaffoldBackgroundColor(context), size: 18.sp,
                                                            ),
                                                            label: Text(
                                                              getTranslated('call_now', context),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppTextStyles.h4(context, fontSize: 15.sp).copyWith(
                                                                color: ColorResources.getScaffoldBackgroundColor(context),
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: ColorResources.getPrimaryColor(context),
                                                              padding: EdgeInsets.symmetric(horizontal: 10.w ,vertical: 5.h),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.r),
                                                              ),
                                                            ),
                                                            onPressed: () => _launchCaller(electrician.phone!),
                                                          ),),

                                                          SizedBox(width: 5.w),
                                                          Expanded(child:   ElevatedButton.icon(
                                                            icon: Icon(Icons.navigation, color: ColorResources.getScaffoldBackgroundColor(context), size: 18.sp,),
                                                            label: Text(
                                                              getTranslated('navigate', context),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppTextStyles.h4(context, fontSize: 15.sp).copyWith(
                                                                color: ColorResources.getScaffoldBackgroundColor(context),
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: ColorResources.getTextColor(context).withOpacity(0.6),
                                                              padding: EdgeInsets.symmetric(horizontal: 10.w ,vertical: 5.h),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(10.r),
                                                              ),
                                                            ),
                                                            onPressed: () => _launchMaps(double.parse(electrician.latitude!), double.parse(electrician.longitude!)),
                                                          ),)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}