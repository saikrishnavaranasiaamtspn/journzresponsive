import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journz_web/HiveArticlesModel/ArticleModel/hive_article_data.dart';
import 'package:journz_web/NewHomePage/Cubits/CheckUserLoginedCubit/checkuserlogined_cubit.dart';
import 'package:journz_web/NewHomePage/LocalDatabase/HiveBoxes/hive_boxes.dart';
import 'package:journz_web/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class BodyRightPane extends StatefulWidget {
  const BodyRightPane({Key? key}) : super(key: key);

  @override
  _BodyRightPaneState createState() => _BodyRightPaneState();
}

class _BodyRightPaneState extends State<BodyRightPane> {
  List<HiveArticleData> listOfArticles = [];
  List<HiveArticleData> listOfArticles2 = [];
  List<HiveArticleData> listOfArticles3 = [];
  @override
  Widget build(BuildContext context) {
    return
      (context.screenWidth>1000)?
      Container(
      //padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.02),
      width: context.screenWidth * 0.225,
      height: context.screenHeight * 0.9,
      //color: Colors.blue.shade50,
      child: BlocBuilder<CheckuserloginedCubit, CheckuserloginedState>(
          builder: (context, state) {
        return Column(
          children: [
            !state.isLoggined!
                ? Text('Create Account To Have Personalized Favourite Categories. \n\nClick Sign Up Button Above')
                    .text
                    .xl
                    .make()
                    .box
                    .p20
                    .alignCenter
                    .blue200
                    .width(context.screenWidth * 0.2)
                    .height(context.screenHeight * 0.25)
                    .make()
                : Container(),
            Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 2)),
                    child: Column(children: [
                      state.isLoggined!
                          ? Text('Favourite Categories')
                              .text
                              .xl
                              .semiBold
                              .align(TextAlign.start)
                              .make()
                              .box
                              .p12
                              .alignCenterLeft
                              .make()
                          : Container(),
                      BlocBuilder<CheckuserloginedCubit, CheckuserloginedState>(
                        builder: (context, userState) {
                          return userState.isLoggined!
                              ? userState.favCategories!.isNotEmpty
                                  ? GridView.builder(
                                      itemCount:
                                          userState.favCategories!.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 3,
                                              crossAxisSpacing: 4,
                                              mainAxisSpacing: 4,
                                              crossAxisCount: 2),
                                      itemBuilder: (context, index) {
                                        return Text(
                                                userState.favCategories![index])
                                            .text
                                            .semiBold
                                            .make()
                                            .box
                                            .p8
                                            .alignCenter
                                            .customRounded(
                                                BorderRadius.circular(10))
                                            .width(context.screenWidth * 0.09)
                                            .height(context.screenHeight * 0.01)
                                            .blue200
                                            .make();
                                      },
                                    )
                                      .box
                                      .width(context.screenWidth * 0.2)
                                      .height(context.screenHeight * 0.21)
                                      .make()
                                  : Center(
                                          child:
                                              "Double Tap on the categories to Add it in Favourite List"
                                                  .text
                                                  .semiBold
                                                  .xl
                                                  .make())
                                      .box
                                      .width(context.screenWidth * 0.2)
                                      .height(context.screenHeight * 0.21)
                                      .make()
                              : Container();
                        },
                      ),
                    ]))
                .box
                .customRounded(BorderRadius.circular(10))
                // .withDecoration(BoxDecoration(
                //   border: Border.all(width: 5, color: Colors.black)))
                .neumorphic(color: Colors.white, elevation: 8)
                .make(),
            SizedBox(height: context.screenHeight * 0.015),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 255), width: 2)),
                child: Column(children: [
                  "Advertisement"
                      .text
                      .xl
                      .semiBold
                      .make()
                      .box
                      .px12
                      .alignCenterLeft
                      .make(),
                  Container(
                    width: context.screenWidth * 0.2,
                    height: context.screenHeight * 0.24,
                    color: Colors.blue.shade100,
                    alignment: Alignment.topLeft,
                  )
                ])),
            SizedBox(height: context.screenHeight * 0.015),
            Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 2)),
                    child: Column(children: [
                      "Popular Articles"
                          .text
                          .xl
                          .semiBold
                          .make()
                          .box
                          .px12
                          .alignCenterLeft
                          .make(),
                      Container(
                        width: context.screenWidth * 0.2,
                        height: context.screenHeight * 0.25,
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.topLeft,
                        child: ValueListenableBuilder<Box<HiveArticleData>>(
                            valueListenable:
                                Boxes.getArticleFromCloud().listenable(),
                            builder: (context, value, _) {
                              listOfArticles2 =
                                  value.values.toList().cast<HiveArticleData>();
                              listOfArticles = listOfArticles2.sortedBy(
                                  (b, a) => a.noOfViews.compareTo(b.noOfViews));

                              return listOfArticles.isNotEmpty
                                  ? CarouselSlider.builder(
                                      itemCount: 5,
                                      itemBuilder: (context, index, realIndex) {
                                        return InkWell(
                                          onTap: () {
                                            context.vxNav.push(
                                                Uri(
                                                    path: MyRoutes.homeRoute,
                                                    queryParameters: {
                                                      "Page": "/Articles",
                                                      "id":
                                                          listOfArticles[index]
                                                              .documentId
                                                    }),
                                                params: listOfArticles[index]);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            color: Colors.blue.shade100,
                                            child: Column(
                                              children: [
                                                /* listOfArticles[index].articlePhotoUrl !=
                                              "WithoutImage"
                                          ? Image.network(listOfArticles[index]
                                                  .articlePhotoUrl)
                                              .box
                                              .width(context.screenWidth)
                                              .alignCenterLeft
                                              .height(
                                                  context.screenHeight * 0.125)
                                              .make()
                                          : Container(), */
                                                Text(listOfArticles[index]
                                                        .articleTitle!)
                                                    .text
                                                    .semiBold
                                                    .maxLines(2)
                                                    .align(TextAlign.left)
                                                    .overflow(
                                                        TextOverflow.ellipsis)
                                                    .make()
                                                    .box
                                                    .alignCenterLeft
                                                    .make(),
                                                Html(
                                                        data: listOfArticles[
                                                                index]
                                                            .articleDescription)
                                                    /*  .text
                                          .semiBold
                                          .maxLines(2)
                                          .align(TextAlign.left)
                                          .overflow(TextOverflow.ellipsis)
                                          .make() */
                                                    .box
                                                    .width(context.screenWidth *
                                                        0.225)
                                                    .height(
                                                        context.screenHeight *
                                                            0.128)
                                                    .alignCenterLeft
                                                    .make(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                          enlargeCenterPage: true))
                                  : Container();
                            }),
                      )
                    ]))
                .box
                .customRounded(BorderRadius.circular(10))
                // .withDecoration(BoxDecoration(
                //   border: Border.all(width: 5, color: Colors.black)))
                .neumorphic(color: Colors.white, elevation: 8)
                .make(),
          ],
        );
      }),
    ):Container();
  }
}
