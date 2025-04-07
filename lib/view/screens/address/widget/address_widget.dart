import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/map_widget.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel? addressModel;
  final int? index;
  AddressWidget({@required this.addressModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: GestureDetector(
        onTap: () {
          if (addressModel != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MapWidget(address: addressModel)));
          }
        },
        child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          height: 80,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Provider.of<ThemeProvider>(context).darkTheme
                    ? Colors.black.withOpacity(0.4)
                    : Colors.grey[300]!,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Icon(
                      addressModel!.addressType!.toLowerCase() == "home"
                          ? Icons.home_outlined
                          : addressModel!.addressType!.toLowerCase() ==
                                  "workplace"
                              ? Icons.work_outline
                              : Icons.list_alt_outlined,
                      color: Provider.of<ThemeProvider>(context).darkTheme
                          ? Colors.white54
                          :ColorResources.getTextColor(context)
                              .withOpacity(.45),
                      size: 25,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(addressModel!.addressType!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white54
                                          : ColorResources.getTextColor(context)
                                              .withOpacity(.45),
                                    )),
                            Text(
                              addressModel!.address!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: 15,
                                      color: Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? Colors.white
                                          : ColorResources.getTextColor(context)),
                            ),
                          ]),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: [
                      Consumer<CustomAuthProvider>(
                          builder: (context, customAuthProvider, child) {
                        return IconButton(
                          onPressed: () {
                            print(addressModel!.id!);
                            customAuthProvider.saveUserAddressId(
                                addressModel!.id!.toString());
                            print('selectedAddress.id ${addressModel!.id!}');
                          },
                          icon: Icon(
                            customAuthProvider.getUserAddressId() ==
                                    addressModel!.id.toString()
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        );
                      }),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ColorResources.getScaffoldBackgroundColor(
                                context),
                            border: Border.all(
                              width: 1,
                              color:
                                  Provider.of<ThemeProvider>(context).darkTheme
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          child: Icon(
                            Icons.map,
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(width: 9.0),
                  // Image.asset(Images.menu)
                  Positioned(
                    right: -10,
                    top: 0,
                    bottom: 0,
                    child: PopupMenuButton<String>(
                      color: Colors.grey[300],
                      iconColor: Provider.of<ThemeProvider>(context).darkTheme
                          ? Colors.white
                          : Colors.black,
                      padding: EdgeInsets.all(0),
                      onSelected: (String result) {
                        if (result == 'delete') {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => CustomCircularIndicator(color:ColorResources.getScaffoldColor(context)));
                          Provider.of<LocationProvider>(context, listen: false)
                              .deleteUserAddressByID(addressModel!.id!, index!,
                                  (bool isSuccessful, String message) {
                            showCustomSnackBar(message, context,
                                isError: !isSuccessful);
                            Navigator.pop(context);
                          });
                          Provider.of<CustomAuthProvider>(context,
                                  listen: false)
                              .clearUserAddressId();
                        } else {
                          Provider.of<LocationProvider>(context, listen: false)
                              .updateInitialPosition(LatLng(
                                  double.parse(addressModel!.latitude!),
                                  double.parse(addressModel!.longitude!)));
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AddNewAddressScreen(
                                isEnableUpdate: true, address: addressModel!),
                          ));
                        }
                      },
                      itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(getTranslated('edit', context),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(getTranslated('delete', context),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
