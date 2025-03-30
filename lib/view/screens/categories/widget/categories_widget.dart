import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class CategoriesWidget extends StatelessWidget implements PreferredSizeWidget {
  final items, title;
  const CategoriesWidget({super.key, this.items, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.transparent),
        height: 200,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Text(
                      title!,
                      maxLines: 2,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      items,
                      style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 60);
}
