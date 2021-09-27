import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:p_i_hub/app/data/widgets/views/profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class IdeaView extends StatelessWidget {
  final Idea idea;
  IdeaView(this.idea);
  @override
  Widget build(BuildContext context) {
    final RxBool isLiked = false.obs;
    final TextEditingController commentCtrl = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: PIHub.currentProfile!.saved.ideas.contains(idea.id)
                ? FaIcon(FontAwesomeIcons.solidBookmark).onInkTap(() {
                    VxToast.show(context, msg: 'Idea Unsaved');
                    PIHub.currentProfile!.saved.ideas.remove(idea.id);
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(PIHub.currentProfile!.username)
                        .update(PIHub.currentProfile!.toMap());
                  })
                : FaIcon(FontAwesomeIcons.bookmark).onInkTap(() {
                    VxToast.show(context, msg: 'Idea Saved Success');
                    PIHub.currentProfile!.saved.ideas.add(idea.id);
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
              10.squareBox,
              (idea.title).text.xl2.bold.make().px20(),
              [
                (idea.username).text.color(kcMain).make().onTap(() {
                  Get.to(() => ProfileViewBuilder(idea.username));
                }),
                Spacer(),
                TimeFormat(idea.dateTime)
                    .text
                    .fade
                    .thin
                    .xs
                    .ellipsis
                    .color(kcWhite.withOpacity(0.4))
                    .make(),
              ].row().px20(),
              if (idea.link != null) 10.squareBox,
              if (idea.link != null)
                GestureDetector(
                  onTap: () {
                    launch(idea.link!);
                  },
                  child: 'Open link'
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
                ).px20(),
              10.squareBox,
              (idea.hashtags.toString())
                  .text
                  .sm
                  .color(kcWhite.withOpacity(0.4))
                  .make()
                  .px20(),
              10.squareBox,
              (idea.desc).text.make().px20(),
              10.squareBox,
              Divider(),
              10.squareBox,
              [
                Obx(() => isLiked.isTrue
                    ? FaIcon(FontAwesomeIcons.solidLightbulb,
                        color: Colors.amber)
                    : FaIcon(FontAwesomeIcons.lightbulb).onTap(() async {
                        idea.likes++;
                        await FirebaseFirestore.instance
                            .collection('projects')
                            .doc(idea.id)
                            .update({'likes': idea.likes});
                        PIHub.currentProfile!.liked.ideas.add(idea.id);
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(PIHub.currentProfile!.username)
                            .update(PIHub.currentProfile!.toMap());
                        isLiked.toggle();
                      })),
                if (idea.likes > 0)
                  '${KFormatNumber(idea.likes)} bulbs lightend'
                      .text
                      .sm
                      .thin
                      .color(kcWhite.withOpacity(0.5))
                      .make()
                      .px4(),
                Spacer(),
                if (idea.comments.length > 0)
                  '${idea.comments.length} comments'
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
                    idea.comments.add(Comment(
                        id: '${idea.id}${idea.comments.length}',
                        userName: PIHub.currentProfile!.username,
                        comment: commentCtrl.text,
                        dateTime: DateTime.now()));
                    await FirebaseFirestore.instance
                        .collection('ideas')
                        .doc(idea.id)
                        .update(idea.toMap());
                    VxToast.show(context, msg: "Comment Added");
                    FocusScope.of(context).unfocus();
                    commentCtrl.clear();
                  }),
                ).px16()
              ].row(),
              if (idea.comments.length > 0)
                Column(
                  children: [
                    for (var comment in idea.comments)
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
