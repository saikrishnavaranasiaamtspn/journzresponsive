import 'package:flutter/material.dart';

import 'package:journz_web/NewHomePage/Components/home_body_center_pane_article_section.dart';
import 'package:journz_web/NewHomePage/Components/home_page_body_center_pane_subtype_header.dart';
import 'package:journz_web/NewHomePage/Components/left_pane_profile.dart';

import 'package:velocity_x/velocity_x.dart';

import 'home_page_body_right_pane.dart';

class BodyCenterPane extends StatefulWidget {
  /* final ShowCurrentlySelectedSubtypeCubit showCurrentSubtypeNameCubit; */
  const BodyCenterPane({
    Key? key,
    /* required this.showCurrentSubtypeNameCubit */
  }) : super(key: key);

  @override
  _BodyCenterPaneState createState() => _BodyCenterPaneState();
}

class _BodyCenterPaneState extends State<BodyCenterPane> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      /*  padding: EdgeInsets.only(
        top: context.screenHeight * 0.0075,
        left: context.screenWidth * 0.005,
        right: context.screenWidth * 0.005,
      ), */
      duration: Duration(milliseconds: 300),
     // width: context.screenWidth * 0.55,
      //height: context.screenHeight * 0.865,
      //color: Colors.grey.shade50,
      child: SingleChildScrollView(
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //LeftPaneBySai(),

            LeftPaneProfile(),
            (context.screenWidth>1000)?
            SizedBox(
                width: context.screenWidth*0.01
            ):SizedBox()
            ,

            Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
               // crossAxisAlignment: CrossAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BodyCenterPaneSubtypeHeader(
                      /*  showCurrentSubtypeNameCubit:
                          widget.showCurrentSubtypeNameCubit */
                      ),
                  SizedBox(height: context.screenHeight * 0.05),
                  BodyCenterPaneArticleSection()
                ],
              ),
            )

            ,
            (context.screenWidth>1000)?
            SizedBox(
                width: context.screenWidth*0.01
            ):SizedBox()
            ,

            BodyRightPane()
          ],
        ),
      ),
    );
  }
}
