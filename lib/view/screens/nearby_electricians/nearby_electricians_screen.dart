import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/area_model.dart';
import 'package:wired_express/data/model/response/electrician_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
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

  void _launchMaps(double lat, double long) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: 'maps/@$lat,$long,15z',
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      appBar: CustomAppBar(title: getTranslated('nearby_electricians', context)),
      body: SafeArea(
        child: Consumer<CustomAuthProvider>(
          builder: (context, auth, child) {
            return Column(
              children: [
                Expanded(
                  child: Consumer2<CustomAuthProvider, SplashProvider>(
                    builder: (context, auth, splashProvider, child) {
                      return Scrollbar(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(25),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                itemCount: widget.electricians.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  ElectricianModel electrician = widget.electricians[index];
                                  AreaModel area = electrician.area!;
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      color: ColorResources.getTextFieldFillColor(context),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                                imageUrl: "${splashProvider.configModel?.baseUrls?.electricianImageUrl}/${electrician.image}",
                                                cacheKey: "${splashProvider.configModel?.baseUrls?.electricianImageUrl}/${electrician.image}",
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    electrician.name!,maxLines: 1,  overflow: TextOverflow.ellipsis ,
                                                    style: TextStyle(
                                                      color: ColorResources.getTextColor(context),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    area.name!,maxLines: 1,  overflow: TextOverflow.ellipsis ,
                                                    style: TextStyle(
                                                      color: ColorResources.getTextColor(context).withOpacity(0.6),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      ElevatedButton.icon(
                                                        icon: Icon(
                                                          Icons.phone,
                                                          color: ColorResources.getScaffoldBackgroundColor(context),
                                                        ),
                                                        label: Text(
                                                          getTranslated('call_now', context),
                                                          style: TextStyle(
                                                            color: ColorResources.getScaffoldBackgroundColor(context),
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: ColorResources.getPrimaryColor(context),
                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                        onPressed: () => _launchCaller(electrician.phone!),
                                                      ),

                                                      SizedBox(width: 15,),
                                                      ElevatedButton.icon(
                                                        icon: Icon(Icons.navigation, color: ColorResources.getScaffoldBackgroundColor(context)),
                                                        label: Text(getTranslated('navigate', context) ,
                                                          style: TextStyle(
                                                              color: ColorResources.getScaffoldBackgroundColor(context),
                                                              fontSize: 15 , fontWeight: FontWeight.w500
                                                          ),),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: ColorResources.getTextColor(context).withOpacity(0.6),
                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                        onPressed: () => _launchMaps(double.parse(electrician.latitude!), double.parse(electrician.longitude!)),
                                                      ),
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
    );
  }
}