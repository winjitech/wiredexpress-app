import 'package:flutter/material.dart';
import 'package:wired_express/utill/Images.dart';

class PaymentMethodsWiget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              width: 200,
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.masterCard),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Master Card',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            width: 200,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.masterCard),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Master Card',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            width: 200,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.masterCard),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Master Card',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            width: 200,
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.masterCard),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Master Card',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
