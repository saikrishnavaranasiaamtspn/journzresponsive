import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:journz_web/HiveArticlesModel/ArticleModel/hive_article_data.dart';
import 'package:journz_web/NewHomePage/Components/user_profile_screen.dart';
import 'package:journz_web/NewHomePage/Cubits/CheckUserLoginedCubit/checkuserlogined_cubit.dart';
import 'package:journz_web/NewHomePage/Cubits/check_favourite_categories_cubit/check_favourite_categories_cubit.dart';
import 'package:journz_web/NewHomePage/LocalDatabase/HiveArticleSubtypeModel/hive_article_subtype_model.dart';
import 'package:journz_web/NewHomePage/LocalDatabase/HiveBoxes/hive_boxes.dart';
import 'package:journz_web/utils/routes.dart';
import 'package:universal_html/html.dart';
import 'package:velocity_x/velocity_x.dart';

class LeftPaneProfile extends StatefulWidget {
  const LeftPaneProfile({Key? key}) : super(key: key);

  @override
  _LeftPaneProfileState createState() => _LeftPaneProfileState();
}

class _LeftPaneProfileState extends State<LeftPaneProfile> {
  List<String> listOfSubtype = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckuserloginedCubit, CheckuserloginedState>(
      builder: (context, userState) {
        return
          (context.screenWidth>1000)?
          Container(
          width: context.screenWidth * 0.175,
          child: Stack(
            children: [
              Positioned(
                top: context.screenHeight * 0.0875,
                left: 0,
                child: InkWell(
                  onTap: () {
                    if (userState.isLoggined!) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: UserProfileScreen(userState: userState),
                            );
                          });
                    }
                  },
                  child: Container(
                    width: context.screenWidth * 0.175,
                    height: context.screenHeight * 0.21,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: context.screenHeight * 0.095),
                        (userState.name ?? "Hii Journz")
                            .text
                            .align(TextAlign.justify)
                            .semiBold
                            .xl
                            .make()
                            .box
                            .alignCenter
                            .make(),
                        SizedBox(height: context.screenHeight * 0.01),
                        /*     (userState.email ?? "")
                            .text
                            .align(TextAlign.justify)
                            .semiBold
                            .make()
                            .box
                            .alignCenter
                            .make(), */
                        (userState.country ?? "")
                            .text
                            .align(TextAlign.justify)
                            .semiBold
                            .make()
                            .box
                            .alignCenter
                            .make()
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: context.screenHeight * 0.2975,
                  left: 0,
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              context.vxNav.popToRoot();
                            },
                            child: "Articles"
                                .text
                                .xl2
                                .white
                                .semiBold
                                .make()
                                .box
                                .width(context.screenWidth * 0.175)
                                .height(context.screenHeight * 0.075)
                                .p12
                                .alignCenter
                                .blue400
                                .make()),
                        userState.isLoggined!
                            ? InkWell(
                                onTap: () {
                                  showFavouriteCategoriesDialog(userState);
                                },
                                child: "Favourite Categories"
                                    .text
                                    .xl
                                    .semiBold
                                    .make()
                                    .box
                                    .color(Colors.grey.shade200)
                                    .width(context.screenWidth * 0.175)
                                    .height(context.screenHeight * 0.075)
                                    .p12
                                    .alignCenter
                                    .make(),
                              )
                            : Container(),
                        userState.isLoggined!
                            ? userState.role! == "ContentWriter"
                                ? InkWell(
                                    onTap: () {
                                      context.vxNav.push(
                                        Uri(
                                            path: MyRoutes.homeRoute,
                                            queryParameters: {
                                              "Page": "/CreateArticle"
                                            }),
                                      );
                                    },
                                    child: "Create Article"
                                        .text
                                        .xl
                                        .semiBold
                                        .make()
                                        .box
                                        .color(Colors.grey.shade200)
                                        .width(context.screenWidth * 0.175)
                                        .height(context.screenHeight * 0.075)
                                        .p12
                                        .alignCenter
                                        .make(),
                                  )
                                : Container()
                            : Container(),
                        userState.isLoggined!
                            ? InkWell(
                                onTap: () {
                                  context.vxNav.push(
                                    Uri(
                                        path: MyRoutes.homeRoute,
                                        queryParameters: {
                                          "Page": "/PersonalArticles"
                                        }),
                                  );
                                },
                                child: "Published Article"
                                    .text
                                    .xl
                                    .semiBold
                                    .make()
                                    .box
                                    .color(Colors.grey.shade200)
                                    .width(context.screenWidth * 0.175)
                                    .height(context.screenHeight * 0.075)
                                    .p12
                                    .alignCenter
                                    .make(),
                              )
                            : Container(),
                        userState.isLoggined!
                            ? InkWell(
                                onTap: () {
                                  context.vxNav.push(
                                    Uri(
                                        path: MyRoutes.homeRoute,
                                        queryParameters: {
                                          "Page": "/SavedArticles"
                                        }),
                                  );
                                },
                                child: "Saved Article"
                                    .text
                                    .xl
                                    .semiBold
                                    .make()
                                    .box
                                    .color(Colors.grey.shade200)
                                    .width(context.screenWidth * 0.175)
                                    .height(context.screenHeight * 0.075)
                                    .p12
                                    .alignCenter
                                    .make(),
                              )
                            : Container(),
                        !userState.isLoggined!
                            ? SizedBox(height: 10)
                            : Container(),
                        "Newz"
                            .text
                            .xl2
                            .white
                            .semiBold
                            .make()
                            .box
                            .width(context.screenWidth * 0.175)
                            .height(context.screenHeight * 0.075)
                            .p12
                            .alignCenter
                            .blue400
                            .make(),
                      ],
                    ),
                  )),
              Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: context.screenWidth * 0.25,
                          height: context.screenHeight * 0.175,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300),
                        ),
                        Container(
                          width: context.screenWidth * 0.2,
                          height: context.screenHeight * 0.15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade400),
                        ),
                        Container(
                          width: context.screenWidth * 0.185,
                          height: context.screenHeight * 0.13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade500),
                        ),
                        userState.isLoggined!
                            ? userState.photoUrl == "images/fluenzologo.png"
                                ? CircleAvatar(
                                    radius: 38.0,
                                    backgroundImage:
                                        AssetImage('assets/images/logo.png'),
                                    backgroundColor: Colors.transparent,
                                  )
                                : CircleAvatar(
                                    radius: 38.0,
                                    backgroundImage:
                                        NetworkImage(userState.photoUrl!),
                                    backgroundColor: Colors.transparent,
                                  )
                            : CircleAvatar(
                                radius: 38.0,
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
                                backgroundColor: Colors.transparent,
                              )
                      ],
                    ),
                  ))
            ],
          )
              .box
              .width(context.screenWidth * 0.175)
              .height(context.screenHeight * 0.75)
              .make(),
        ):
          Container();
      },
    );
  }

  void showFavouriteCategoriesDialog(CheckuserloginedState userState) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BlocProvider(
            create: (context) => CheckFavouriteCategoriesCubit(
                initialData: userState.favCategories!),
            child: BlocBuilder<CheckFavouriteCategoriesCubit,
                CheckFavouriteCategoriesState>(
              builder: (context, checkFavstate) {
                return Dialog(
                  child: Container(
                    width: context.screenWidth * 0.35,
                    height: context.screenHeight * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "Select Favourite Categories"
                            .text
                            .xl
                            .semiBold
                            .make()
                            .box
                            .alignCenterLeft
                            .p12
                            .make(),
                        ValueListenableBuilder<Box<HiveArticlesSubtypes>>(
                          valueListenable:
                              Boxes.getArticleSubtypeFromCloud().listenable(),
                          builder: (context, value, _) {
                            var subtype = value.values
                                .toList()
                                .cast<HiveArticlesSubtypes>();

                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: subtype.length,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    context
                                        .read<CheckFavouriteCategoriesCubit>()
                                        .addOrRemoveCategories(
                                            checkFavstate.selectedCategories,
                                            subtype[index].subtypeName);
                                  },
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius:
                                                  context.screenHeight * 0.065,
                                              backgroundImage: NetworkImage(
                                                  subtype[index].photoUrl),
                                            ),
                                            Text(subtype[index].subtypeName)
                                                .text
                                                .make(),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: checkFavstate
                                                  .selectedCategories
                                                  .contains(subtype[index]
                                                      .subtypeName)
                                              ? Icon(Icons.check)
                                              : Container(),
                                        ),
                                      ]),
                                );
                              },
                            )
                                .box
                                .width(context.screenWidth * 0.3)
                                .height(context.screenHeight * 0.47)
                                .make();
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('UserProfile')
                                  .doc(userState.userUid)
                                  .update({
                                'UsersFavouriteArticleCategory':
                                    checkFavstate.selectedCategories
                              }).whenComplete(() => Navigator.pop(context));
                            },
                            child: Text('Done'))
                      ],
                    ),
                  ),
                );
              },
            ));
        ;
      },
    );
  }
}
