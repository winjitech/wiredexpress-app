import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';

class StandardScreen extends StatefulWidget {
  @override
  _StandardScreenState createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'title',
      ),
      body: Consumer<CustomAuthProvider>(
        builder: (context, customAuthProvider, child) {
          return Scrollbar(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(child: Column()),
            ),
          );
        },
      ),
    );
  }
}
