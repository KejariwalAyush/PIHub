import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:p_i_hub/app/data/widgets/views/idea_view.dart';
import 'package:p_i_hub/app/data/widgets/views/profile_view.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../index.dart';

class IdeaContainer extends StatelessWidget {
  const IdeaContainer({Key? key, this.idea}) : super(key: key);

  final Idea? idea;

  @override
  Widget build(BuildContext context) {
    Idea idea = this.idea ??
        Idea(
            id: 'demoidea1',
            dateTime: DateTime.now(),
            title: 'PIHub - Best idea to read atleast read once.',
            username: 'KejariwalAyush',
            desc:
                "This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.\nThis is a project description..\n\nQui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.This is a project description..Qui est perspiciatis laborum rem sit odit. Sunt enim a laboriosam ipsum qui fugiat ipsa. Molestiae et soluta quia nihil quo cumque necessitatibus. Quo nihil molestiae praesentium.",
            hashtags: ['tags', 'tag', 'startup'],
            likes: 20,
            comments: [
              Comment(
                  id: 'icom1',
                  userName: 'lorem',
                  comment: '❤❤❤ Loved this idea.',
                  dateTime: DateTime.now()),
              Comment(
                  id: 'icom2',
                  userName: 'lipsum',
                  comment: 'Great Idea, must be applied. 😉💚',
                  dateTime: DateTime.now()),
            ],
            views: []);
    final RxBool isLiked =
        PIHub.currentProfile!.liked.ideas.contains(idea.id).obs;
    return GestureDetector(
      onTap: () => Get.to(() => IdeaView(idea)),
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
            [
              Obx(() => isLiked.isTrue
                  ? FaIcon(FontAwesomeIcons.solidLightbulb, color: Colors.amber)
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
              10.squareBox,
              Expanded(
                child: [
                  TimeFormat(idea.dateTime)
                      .text
                      .fade
                      .thin
                      .xs
                      .ellipsis
                      .color(kcWhite.withOpacity(0.4))
                      .make(),
                  5.squareBox,
                  (idea.username).text.color(kcMain).make().onInkTap(() {
                    Get.to(() => ProfileViewBuilder(idea.username));
                  }),
                ].column(),
              ),
              10.squareBox,
              PIHub.currentProfile!.saved.ideas.contains(idea.id)
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
            ].row(),
            10.squareBox,
            (idea.title).text.xl2.bold.ellipsis.maxLines(2).make(),
            20.squareBox,
            (idea.desc).text.light.ellipsis.maxLines(13).make(),
            20.squareBox,
            (idea.hashtags.toString())
                .text
                .ellipsis
                .sm
                .maxLines(2)
                .color(kcWhite.withOpacity(0.4))
                .make(),
            5.squareBox,
            if (idea.likes > 0 || idea.comments.length > 0)
              [
                if (idea.likes > 0)
                  [
                    ('${KFormatNumber(idea.likes)} ').text.bold.amber400.make(),
                    'people lighted the bulb'.text.sm.amber400.make()
                  ].row(),
                Spacer(),
                if (idea.comments.length > 0)
                  [
                    5.squareBox,
                    ('${KFormatNumber(idea.comments.length)} comments')
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

class IdeaContainerBuilder extends StatelessWidget {
  const IdeaContainerBuilder({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Idea>(
        future: FirebaseFirestore.instance
            .collection('ideas')
            .doc(id)
            .get()
            .then((value) => Idea.fromJson(jsonEncode(value.data()))),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator()).p32();
          return IdeaContainer(
            idea: snapshot.data,
          );
        },
      ),
    );
  }
}
