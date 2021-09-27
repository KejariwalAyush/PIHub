import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../index.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final formKey = GlobalKey<FormBuilderState>();
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RxBool isLoading = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: 'Add new Project'.text.make(),
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
                      keyboardType: TextInputType.name,
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'desc',
                      maxLines: 8,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 100),
                      ]),
                      keyboardType: TextInputType.multiline,
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
                      autovalidateMode: AutovalidateMode.always,
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'projectlink',
                      decoration: InputDecoration(
                        labelText: 'Add Project Link (if any)',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.url(context),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'productlink',
                      decoration: InputDecoration(
                        labelText: 'Add Download Link (if any)',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.url(context),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                    10.squareBox,
                    FormBuilderFilterChip(
                      name: 'languages',
                      decoration: InputDecoration(
                        labelText: 'Languages Involved',
                      ),
                      options: List.generate(
                        langs.length,
                        (i) => FormBuilderFieldOption(
                          value: '${langs[i]}',
                          child: '${langs[i]}'.text.make(),
                        ),
                      ),
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'link1',
                      decoration: InputDecoration(
                        labelText: 'Add screenshot Link 1',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.url(context),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'link2',
                      decoration: InputDecoration(
                        labelText: 'Add screenshot Link 2',
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.url(context),
                      ]),
                      keyboardType: TextInputType.url,
                    ),
                    10.squareBox,
                    FormBuilderTextField(
                      name: 'link3',
                      decoration: InputDecoration(
                        labelText: 'Add screenshot Link 3',
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
                  child: Text("Post Project"),
                  onPressed: () async {
                    isLoading.toggle();
                    formKey.currentState!.saveAndValidate();
                    var val = formKey.currentState!.value;
                    DocumentReference docRef =
                        FirebaseFirestore.instance.collection('projects').doc();
                    Project project = new Project(
                        id: docRef.id,
                        title: val['title'],
                        desc: val['desc'],
                        hashtags: val['hashtags'],
                        dateTime: DateTime.now(),
                        username: PIHub.currentProfile!.username,
                        languages: val['languages'],
                        views: [],
                        comments: [],
                        screenshots: [
                          if (val['link1'] != null) val['link1'],
                          if (val['link2'] != null) val['link2'],
                          if (val['link3'] != null) val['link3'],
                        ],
                        productLink: val['productlink'],
                        projectLink: val['projectlink'],
                        likes: 0);

                    await docRef.set(project.toMap());
                    PIHub.currentProfile!.projects.add(docRef.id);
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
