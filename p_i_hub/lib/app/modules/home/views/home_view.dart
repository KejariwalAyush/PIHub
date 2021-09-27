import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/data/widgets/views/profile_view.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcBlack,
      bottomNavigationBar: context.isPortrait ? navBar() : null,
      body: Row(
        children: [
          if (!context.isPortrait)
            Obx(
              () => Container(
                height: context.height,
                width: 60,
                child: [
                  CircleAvatar(
                          backgroundColor: controller.currentIndex.value == 0
                              ? kcMain
                              : null,
                          child: FaIcon(FontAwesomeIcons.projectDiagram,
                              color: kcWhite))
                      .onInkTap(() => controller.changeCurrentIndex(0)),
                  CircleAvatar(
                          backgroundColor: controller.currentIndex.value == 1
                              ? kcMain
                              : null,
                          child: FaIcon(FontAwesomeIcons.lightbulb,
                              color: kcWhite))
                      .onInkTap(() => controller.changeCurrentIndex(1)),
                  CircleAvatar(
                          backgroundColor: controller.currentIndex.value == 2
                              ? kcMain
                              : null,
                          child: FaIcon(FontAwesomeIcons.user, color: kcWhite))
                      .onInkTap(() => controller.changeCurrentIndex(2)),
                ].column(alignment: MainAxisAlignment.spaceEvenly),
              ),
            ),
          Expanded(
            child: GetBuilder<HomeController>(
              init: HomeController(),
              initState: (_) {},
              builder: (_) {
                if (_.currentIndex.value == 0)
                  return Container(
                    child: Column(
                      children: [
                        Get.mediaQuery.padding.top.squareBox,
                        if (context.isPortrait)
                          'PIHub - Projects'.text.xl4.make().px16().py4(),
                        Expanded(
                          child: StreamBuilder<List<Project>>(
                              stream: FirebaseFirestore.instance
                                  .collection('projects')
                                  .orderBy('dateTime', descending: true)
                                  .limit(15)
                                  .get()
                                  .then((value) => value.docs
                                      .map((e) => Project.fromMap(e.data()))
                                      .toList())
                                  .asStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center(
                                      child: CircularProgressIndicator());
                                List<Project> projects = snapshot.data!;
                                return ListView.builder(
                                  itemCount: projects.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      ProjectContainer(
                                    project: projects[index],
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                else if (_.currentIndex.value == 1)
                  return Container(
                    child: Column(
                      children: [
                        Get.mediaQuery.padding.top.squareBox,
                        if (context.isPortrait)
                          'PIHub - Ideas'.text.xl4.make().px16().py4(),
                        Expanded(
                          child: StreamBuilder<List<Idea>>(
                              stream: FirebaseFirestore.instance
                                  .collection('ideas')
                                  .orderBy('dateTime', descending: true)
                                  .limit(15)
                                  .get()
                                  .then((value) => value.docs
                                      .map((e) => Idea.fromMap(e.data()))
                                      .toList())
                                  .asStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Center(
                                      child: CircularProgressIndicator());
                                List<Idea> ideas = snapshot.data!;
                                return ListView.builder(
                                  itemCount: ideas.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      IdeaContainer(
                                    idea: ideas[index],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                else
                  return ProfileViewBuilder(PIHub.currentProfile!.username);
              },
            ),
          ),
        ],
      ),
    );
  }

  SnakeNavigationBar navBar() {
    return SnakeNavigationBar.color(
      snakeViewColor: kcMain,
      backgroundColor: kcBlack,
      currentIndex: controller.currentIndex.value,
      elevation: 30,
      onTap: controller.changeCurrentIndex,
      // behaviour: SnakeBarBehaviour.pinned,
      // shape: StadiumBorder(),
      items: [
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.projectDiagram, color: kcWhite),
            label: 'Projects'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.lightbulb, color: kcWhite),
            label: 'Ideas'),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user, color: kcWhite),
            label: 'Profile'),
      ],
    );
  }
}
