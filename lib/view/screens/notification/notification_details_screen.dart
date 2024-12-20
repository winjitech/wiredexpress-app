// import 'package:flutter/material.dart';
// import 'package:wired_express/data/model/response/notification_model.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/app_constants.dart';
// import 'package:provider/provider.dart';
//
// class NotificationDetailsScreen extends StatefulWidget {
//   final NotificationModel? notification;
//   NotificationDetailsScreen({@required this.notification});
//
//   @override
//   State<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
// }
//
// class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('', style: TextStyle(color: Colors.black87)),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context!).pop();
//           },
//           icon: Icon(Icons.close_rounded, color: Colors.black87),
//         ),
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) => SafeArea(
//           child: Scrollbar(
//             child: SingleChildScrollView(
//               //padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//               physics: BouncingScrollPhysics(),
//               child:SizedBox(
//               width: MediaQuery.of(context).size.width,
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     widget.notification!.image!=null?
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             // borderRadius: BorderRadius.circular(10),
//                             child: FadeInImage.assetNetwork(
//                               placeholder: Images.placeholder_rectangle,
//                               image: '${AppConstants.BASE_URL}/public/storage/${widget.notification!.image!.fileFolder}/${widget.notification!.image!.uid}.${widget.notification!.image!.fileExtension}',
//                               height: 300,
//                               fit: BoxFit.cover,
//                               width: 300,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ): SizedBox(),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 24),
//                       child: Text('${widget.notification!.title}',
//                           style: TextStyle(
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16
//                           )),
//                     ),
//                     const SizedBox(height: 7),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 24),
//                       child: Text('${widget.notification!.description}',
//                           style: TextStyle(
//                               color: Colors.black54,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final NotificationModel? notification;
  NotificationDetailsScreen({@required this.notification});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(
        title: '',
      ),
      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              //padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.notification!.image != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(children: [
                              Expanded(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                          placeholder:
                                              Images.placeholder_rectangle,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${widget.notification!.image!}',
                                          // image: '${AppConstants.BASE_URL}/public/storage/${widget.notification!.image!}',  .fileFolder}/${widget.notification!.image!.uid}.${widget.notification!.image!.fileExtension}',
                                          height: 300,
                                          fit: BoxFit.cover,
                                          width: 300)))
                            ]),
                          )
                        : SizedBox(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text('${widget.notification!.title}',
                          style: TextStyle(
                              color: ColorResources.getTextColor(context),
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text('${widget.notification!.description}',
                          style: TextStyle(
                              color:
                                  Provider.of<ThemeProvider>(context).darkTheme
                                      ? Colors.white54
                                      : Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
