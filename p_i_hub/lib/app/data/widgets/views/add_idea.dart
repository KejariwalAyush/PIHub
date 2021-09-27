import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../index.dart';

class AddIdea extends StatefulWidget {
  const AddIdea({Key? key}) : super(key: key);

  @override
  _AddIdeaState createState() => _AddIdeaState();
}

class _AddIdeaState extends State<AddIdea> {
  final formKey = GlobalKey<FormBuilderState>();
  final RxBool isLoading = false.obs;
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add new Idea'.text.make(),
      ),
      body: Column(
        children: [
          Expanded(
            child: FormBuilder(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'title',
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 5),
                      ]),
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'desc',
                      maxLines: 16,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 100),
                      ]),
                    ),
                    10.squareBox,
                    FormBuilderFilterChip(
                      name: 'hashtags',
                      decoration: InputDecoration(
                        labelText: 'Select hashtags you like',
                      ),
                      options: List.generate(
                        hashtags.length,
                        (i) => FormBuilderFieldOption(
                          value: '${hashtags[i]}',
                          child: '${hashtags[i]}'.text.make(),
                        ),
                      ),
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'link',
                      decoration: InputDecoration(
                        labelText: 'Add Link (if any)',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.url(context),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),
              ),
            ).px8(),
          ),
          Obx(() => isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  child: Text("Post Idea"),
                  onPressed: () async {
                    isLoading.toggle();
                    formKey.currentState!.saveAndValidate();
                    var val = formKey.currentState!.value;
                    DocumentReference docRef =
                        FirebaseFirestore.instance.collection('ideas').doc();

                    Idea idea = new Idea(
                        id: docRef.id,
                        title: val['title'],
                        desc: val['desc'],
                        hashtags: val['hashtags'],
                        dateTime: DateTime.now(),
                        username: PIHub.currentProfile!.username,
                        likes: 0,
                        comments: [],
                        views: []);

                    await docRef.set(idea.toMap());
                    PIHub.currentProfile!.ideas.add(docRef.id);
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(PIHub.currentProfile!.username)
                        .update(PIHub.currentProfile!.toMap())
                        .then((value) => Get.back());
                    isLoading.toggle();
                  },
                ).w(context.width).p8()),
        ],
      ),
    );
  }
}
