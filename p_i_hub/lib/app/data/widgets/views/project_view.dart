import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/data/widgets/views/profile_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ProjectView extends StatelessWidget {
  final Project project;
  ProjectView(this.project);
  @override
  Widget build(BuildContext context) {
    final TextEditingController commentCtrl = new TextEditingController();
    final RxBool isLiked =
        PIHub.currentProfile!.liked.projects.contains(project.id).obs;
    return Scaffold(
      backgroundColor: kcBlack,
      appBar: AppBar(
        actions: [
          Center(
            child: PIHub.currentProfile!.saved.projects.contains(project.id)
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
          ).px16(),
        ],
      ),
      body: Container(
        width: context.width,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.squareBox,
              (project.title).text.xl2.bold.make().px20(),
              [
                (project.username).text.color(kcMain).make().onTap(() {
                  Get.to(() => ProfileViewBuilder(project.username));
                }),
                Spacer(),
                TimeFormat(project.dateTime)
                    .text
                    .fade
                    .thin
                    .xs
                    .ellipsis
                    .color(kcWhite.withOpacity(0.4))
                    .make(),
              ].row().px20(),
              if (project.projectLink != null || project.productLink != null)
                10.squareBox,
              [
                if (project.projectLink != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        launch(project.projectLink!);
                      },
                      child: 'Open Project'
                          .text
                          .xl
                          .semiBold
                          .gray700
                          .makeCentered()
                          .card
                          .rounded
                          .gray400
                          .make()
                          .wh(MediaQuery.of(context).size.width, 65)
                          .p(10),
                    ),
                  ),
                if (project.productLink != null)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        launch(project.productLink!);
                      },
                      child: 'Download Link'
                          .text
                          .xl
                          .semiBold
                          .gray700
                          .makeCentered()
                          .card
                          .rounded
                          .gray400
                          .make()
                          .wh(MediaQuery.of(context).size.width, 65)
                          .p(10),
                    ),
                  ),
              ].row().px20(),
              10.squareBox,
              ('Languages used: ${project.languages.toString()}')
                  .text
                  .ellipsis
                  .sm
                  .make()
                  .px20(),
              10.squareBox,
              (project.hashtags.toString())
                  .text
                  .sm
                  .color(kcWhite.withOpacity(0.4))
                  .make()
                  .px20(),
              10.squareBox,
              (project.desc).text.make().px20(),
              10.squareBox,
              if (project.screenshots != null &&
                  project.screenshots!.length > 0)
                ExpansionTile(
                  title: 'Screenshots (${project.screenshots!.length})'
                      .text
                      .make(),
                  iconColor: kcMain,
                  textColor: kcMain,
                  leading: FaIcon(FontAwesomeIcons.images),
                  children: [
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kcSec,
                      ),
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider:
                                NetworkImage(project.screenshots![index]),
                            initialScale:
                                PhotoViewComputedScale.contained * 0.8,
                            minScale: 0.5,
                            maxScale: 5.0,
                            // heroAttributes: PhotoViewHeroAttributes(tag: project.screenshots![index]),
                          );
                        },
                        itemCount: project.screenshots!.length,
                        loadingBuilder: (context, event) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: event == null
                                  ? 0
                                  : (event.cumulativeBytesLoaded /
                                      (event.expectedTotalBytes ?? 1)),
                            ),
                          ),
                        ),
                        backgroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // color: kcSec,
                        ),
                        // pageController: widget.pageController,
                        // onPageChanged: onPageChanged,
                      ),
                    ),
                  ],
                ).px20(),
              Divider(),
              10.squareBox,
              [
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
                if (project.likes > 0)
                  '${KFormatNumber(project.likes)} likes'
                      .text
                      .sm
                      .thin
                      .color(kcWhite.withOpacity(0.5))
                      .make()
                      .px4(),
                Spacer(),
                if (project.comments.length > 0)
                  '${project.comments.length} comments'
                      .text
                      .sm
                      .thin
                      .color(kcWhite.withOpacity(0.5))
                      .make()
                      .px4(),
                FaIcon(FontAwesomeIcons.comment),
              ].row().px16(),
              15.squareBox,
              [
                Expanded(
                  child: TextField(
                    controller: commentCtrl,
                    decoration: InputDecoration(
                      hintText: 'Add a Comment',
                    ),
                  ).px16(),
                ),
                Container(
                  width: 25,
                  alignment: Alignment.center,
                  child: FaIcon(
                    FontAwesomeIcons.paperPlane,
                    color: kcMain,
                  ).onTap(() async {
                    Get.log(commentCtrl.text);
                    project.comments.add(Comment(
                        id: '${project.id}${project.comments.length}',
                        userName: PIHub.currentProfile!.username,
                        comment: commentCtrl.text,
                        dateTime: DateTime.now()));
                    await FirebaseFirestore.instance
                        .collection('projects')
                        .doc(project.id)
                        .update(project.toMap());
                    VxToast.show(context, msg: "Comment Added");
                    FocusScope.of(context).unfocus();
                    commentCtrl.clear();
                  }),
                ).px16()
              ].row(),
              if (project.comments.length > 0)
                Column(
                  children: [
                    for (var comment in project.comments)
                      ListTile(
                        title: comment.comment.text.make(),
                        subtitle: [
                          comment.userName.text
                              .color(kcMain.withOpacity(0.7))
                              .make()
                              .onTap(() {
                            Get.to(() => ProfileViewBuilder(comment.userName));
                          }),
                          Spacer(),
                          TimeFormat(comment.dateTime)
                              .text
                              .sm
                              .color(kcWhite.withOpacity(0.5))
                              .make()
                        ].row(),
                      ),
                  ],
                ).px8()
            ],
          ),
        ),
      ),
    );
  }
}
