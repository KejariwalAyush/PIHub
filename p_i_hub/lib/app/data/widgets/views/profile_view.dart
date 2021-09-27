import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/data/widgets/views/add_idea.dart';
import 'package:p_i_hub/app/data/widgets/views/add_project.dart';
import 'package:p_i_hub/app/data/widgets/views/edit_profile_view.dart';
import 'package:p_i_hub/app/data/widgets/views/saved_view.dart';
import 'package:p_i_hub/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileViewBuilder extends StatelessWidget {
  const ProfileViewBuilder(
    this.username, {
    Key? key,
  }) : super(key: key);

  final String username;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Profile>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .get()
            .then((value) => Profile.fromMap(value.data()!)),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: username.text.make(),
                ),
                body: Center(child: CircularProgressIndicator()).p32());
          return ProfileView(snapshot.data!);
        },
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView(
    this.profile, {
    Key? key,
  }) : super(key: key);

  final Profile profile;
  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = profile.id == FirebaseAuth.instance.currentUser!.uid;
    final RxBool isFollowed =
        PIHub.currentProfile!.following.contains(profile.username).obs;
    final users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: kcBlack,
      appBar: AppBar(
        title: profile.username.text.make(),
        actions: [
          if (isCurrentUser)
            [
              Center(
                child: FaIcon(FontAwesomeIcons.bookmark).onInkTap(() {
                  Get.to(() => SavedView());
                }).px16(),
              ),
              Center(
                child: FaIcon(FontAwesomeIcons.plusSquare).onInkTap(() {
                  Get.bottomSheet(
                    Container(
                      color: kcSec,
                      child: [
                        'Project'.text.xl2.bold.make().p16().onInkTap(() {
                          Get.back();
                          Get.to(() => AddProject());
                        }),
                        'Idea'.text.xl2.bold.make().p16().onInkTap(() {
                          Get.back();
                          Get.to(() => AddIdea());
                        }),
                      ].column().py16(),
                    ),
                  );
                }).px16(),
              ),
              Center(
                child: FaIcon(FontAwesomeIcons.signOutAlt).onInkTap(() {
                  Get.bottomSheet(Container(
                    color: kcSec,
                    child: 'LogOut'
                        .text
                        .xl2
                        .bold
                        .make()
                        .p16()
                        .onInkTap(() async {
                          Get.back();
                          await Get.find<AuthService>().signOut();
                          Get.toNamed(Routes.SIGNIN);
                        })
                        .card
                        .make(),
                  ));
                }).px16(),
              ),
            ].row()
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              10.squareBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profile.imgUrl),
                    radius: 45,
                    onBackgroundImageError: (exception, stackTrace) =>
                        Get.log(exception.toString()),
                  ).p8(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      '${profile.name}'.text.xl.make(),
                      '${profile.email}'
                          .text
                          .xs
                          .ellipsis
                          .color(kcWhite.withOpacity(0.5))
                          .make(),
                    ],
                  ).px8(),
                ],
              ),
              10.squareBox,
              Container(
                width: context.width,
                child: [
                  '${KFormatNumber(profile.projects.length + profile.ideas.length)}\nPIs'
                      .text
                      .center
                      .make(),
                  '${KFormatNumber(profile.followers.length)}\nFollowers'
                      .text
                      .center
                      .make(),
                  '${KFormatNumber(profile.following.length)}\nFollowing'
                      .text
                      .center
                      .make(),
                ].row(alignment: MainAxisAlignment.spaceEvenly),
              ),
              if (profile.links.length > 0)
                [
                  10.squareBox,
                  'Links'.text.xl.make(),
                  10.squareBox,
                  for (var link in profile.links)
                    if (link != '')
                      link.text.underline.ellipsis.amber400
                          .make()
                          .onTap(() => launch(link)),
                ]
                    .column(crossAlignment: CrossAxisAlignment.start)
                    .w(context.width)
                    .px8()
                    .py4(),
              isCurrentUser
                  ? GestureDetector(
                      onTap: () {
                        Get.to(() => EditProfileView());
                      },
                      child: 'Edit Profile'
                          .text
                          .xl
                          .semiBold
                          .makeCentered()
                          .card
                          .rounded
                          .make()
                          .wh(context.width, 50)
                          .p(10),
                    )
                  : Obx(() => isFollowed.isTrue
                      ? GestureDetector(
                          onTap: () async {
                            PIHub.currentProfile!.following
                                .remove(profile.username);
                            profile.followers
                                .remove(PIHub.currentProfile!.username);
                            await users
                                .doc(PIHub.currentProfile!.username)
                                .update({
                              'following': PIHub.currentProfile!.following
                            });
                            await users
                                .doc(profile.username)
                                .update({'followers': profile.followers});
                            isFollowed.toggle();
                          },
                          child: 'Unfollow'
                              .text
                              .xl
                              .semiBold
                              .makeCentered()
                              .card
                              .rounded
                              .make()
                              .wh(context.width, 50)
                              .p(10),
                        )
                      : GestureDetector(
                          onTap: () async {
                            PIHub.currentProfile!.following
                                .add(profile.username);
                            profile.followers
                                .add(PIHub.currentProfile!.username);
                            await users
                                .doc(PIHub.currentProfile!.username)
                                .update({
                              'following': PIHub.currentProfile!.following
                            });
                            await users
                                .doc(profile.username)
                                .update({'followers': profile.followers});
                            isFollowed.toggle();
                          },
                          child: 'Follow'
                              .text
                              .xl
                              .semiBold
                              .makeCentered()
                              .card
                              .rounded
                              .color(kcMain)
                              .make()
                              .wh(context.width, 50)
                              .p(10),
                        )),
              DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        tabs: [
                          Tab(text: "Projects"),
                          Tab(text: "Ideas"),
                        ],
                        indicatorColor: kcMain,
                      ),
                    ),
                    Container(
                      //Add this to give height
                      height: context.height / 1.5,
                      child: TabBarView(children: [
                        Builder(
                          builder: (context) {
                            if (profile.projects.length > 0)
                              return ListView.builder(
                                itemCount: profile.projects.length,
                                itemBuilder: (context, index) {
                                  return ProjectContainerBuilder(
                                      id: profile.projects[index]);
                                },
                              );
                            return Center(
                              child: Text("No Projects Yet!"),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            if (profile.ideas.length > 0)
                              return ListView.builder(
                                itemCount: profile.ideas.length,
                                itemBuilder: (context, index) {
                                  return IdeaContainerBuilder(
                                      id: profile.ideas[index]);
                                },
                              );
                            return Center(child: Text("No Idea's Yet"));
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
