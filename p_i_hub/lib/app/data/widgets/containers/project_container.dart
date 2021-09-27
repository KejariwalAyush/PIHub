import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/widgets/views/profile_view.dart';
import 'package:p_i_hub/app/data/widgets/views/project_view.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../index.dart';

class ProjectContainer extends StatelessWidget {
  const ProjectContainer({
    Key? key,
    this.project,
  }) : super(key: key);

  final Project? project;

  @override
  Widget build(BuildContext context) {
    final Project project = this.project ??
        new Project(
            id: 'demo1',
            title: 'Project',
            dateTime: DateTime.now(),
            desc:
                'This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.',
            hashtags: ['ai', 'pandas', 'ml', 'pycharm'],
            username: "username",
            languages: [
              'Python',
              'Python',
            ],
            projectLink: 'https://github.com/KejariwalAyush/notify_me',
            comments: [
              Comment(
                  id: 'com1',
                  userName: 'lorem',
                  comment: 'Loved this app !! ❤❤❤',
                  dateTime: DateTime.now()),
              Comment(
                  id: 'com2',
                  userName: 'lipsum',
                  comment: 'Great UI 😉💚',
                  dateTime: DateTime.now()),
            ],
            likes: 10000,
            views: [],
            screenshots: [
              'https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2NyZWVuc2hvdHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60',
              'https://images.unsplash.com/photo-1518773553398-650c184e0bb3?ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8c2NyZWVuc2hvdHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60',
              'https://images.unsplash.com/photo-1587573578335-9672da4d0292?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fHNjcmVlbnNob3R8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60',
              'https://images.unsplash.com/photo-1587276785986-a9f5782fcc1e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHNjcmVlbnNob3R8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
            ]);
    final RxBool isLiked =
        (PIHub.currentProfile!.liked.projects.contains(project.id)).obs;
    return GestureDetector(
      onTap: () => Get.to(() => ProjectView(project)),
      onDoubleTap: () => isLiked.isFalse ? isLiked.toggle() : null,
      child: Container(
        width: context.width,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: kcSec,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimeFormat(project.dateTime)
                .text
                .fade
                .thin
                .xs
                .ellipsis
                .color(kcWhite.withOpacity(0.4))
                .make(),
            (project.title).text.xl2.ellipsis.make(),
            [
              (project.username).text.color(kcMain).make().onTap(() {
                Get.to(() => ProfileViewBuilder(project.username));
              }).pOnly(right: 20),
              Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.width * 0.35),
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: kcMain.withOpacity(0.2)),
                    child:
                        (project.languages.toString()).text.ellipsis.sm.make()),
              )
            ].row(),
            10.squareBox,
            (project.desc).text.sm.ellipsis.maxLines(5).make(),
            10.squareBox,
            if (project.screenshots != null)
              [
                'Screenshots'.text.make(),
                Spacer(),
                [
                  for (var i = 0;
                      i <
                          (project.screenshots!.length > 5
                              ? 4
                              : project.screenshots!.length);
                      i++)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        project.screenshots![i],
                        fit: BoxFit.cover,
                      ),
                    ).px4(),
                ].row()
              ].row(),
            15.squareBox,
            (project.hashtags.toString())
                .text
                .ellipsis
                .sm
                .maxLines(2)
                .color(kcWhite.withOpacity(0.4))
                .make(),
            5.squareBox,
            Divider(color: kcWhite.withOpacity(0.5)),
            [
              10.squareBox,
              Obx(() => isLiked.isTrue
                  ? FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red)
                  : FaIcon(FontAwesomeIcons.heart).onTap(() async {
                      project.likes++;
                      await FirebaseFirestore.instance
                          .collection('projects')
                          .doc(project.id)
                          .update({'likes': project.likes});

                      PIHub.currentProfile!.liked.projects.add(project.id);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(PIHub.currentProfile!.username)
                          .update(PIHub.currentProfile!.toMap());
                      isLiked.toggle();
                    })),
              Spacer(),
              10.squareBox,
              FaIcon(FontAwesomeIcons.comment),
              10.squareBox,
              PIHub.currentProfile!.saved.projects.contains(project.id)
                  ? FaIcon(FontAwesomeIcons.solidBookmark).onInkTap(() {
                      VxToast.show(context, msg: 'Project Unsaved');
                      PIHub.currentProfile!.saved.projects.remove(project.id);
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(PIHub.currentProfile!.username)
                          .update(PIHub.currentProfile!.toMap());
                    })
                  : FaIcon(FontAwesomeIcons.bookmark).onInkTap(() {
                      VxToast.show(context, msg: 'Project Saved Success');
                      PIHub.currentProfile!.saved.projects.add(project.id);
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(PIHub.currentProfile!.username)
                          .update(PIHub.currentProfile!.toMap());
                    }),
            ].row(),
            5.squareBox,
            if (project.likes > 0 || project.comments.length > 0)
              [
                if (project.likes > 0)
                  [
                    ('${KFormatNumber(project.likes)} ')
                        .text
                        .bold
                        .amber400
                        .make(),
                    'likes'.text.sm.amber400.make()
                  ].row(),
                Spacer(),
                if (project.comments.length > 0)
                  [
                    5.squareBox,
                    ('${KFormatNumber(project.comments.length)} comments')
                        .text
                        .make()
                  ].column(crossAlignment: CrossAxisAlignment.start)
              ].row(),
          ],
        ),
      ),
    );
  }
}

class ProjectContainerBuilder extends StatelessWidget {
  const ProjectContainerBuilder({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Project>(
        future: FirebaseFirestore.instance
            .collection('projects')
            .doc(id)
            .get()
            .then((value) => Project.fromJson(jsonEncode(value.data()))),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator()).p32();
          return ProjectContainer(
            project: snapshot.data,
          );
        },
      ),
    );
  }
}
