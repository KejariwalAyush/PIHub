import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormBuilderState>();
  final collection = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Account"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
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
                      FormBuilderFilterChip(
                        name: 'languages',
                        decoration: InputDecoration(
                          labelText: 'Select Languages you like',
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
                          labelText: 'Add Link 1',
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
                          labelText: 'Add Link 2',
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
                          labelText: 'Add Link 3',
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
              ),
            ),
            Obx(() => isLoading.isTrue
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    child: Text("Update Profile"),
                    onPressed: () async {
                      isLoading.toggle();
                      formKey.currentState!.saveAndValidate();

                      isLoading.toggle();
                    },
                  ).w(context.width)),
          ],
        ),
      ),
    );
  }

  Future<void> signUpUser() async {
    var val = formKey.currentState!.value;
    PIHub.currentProfile!.hashtags = val['hashtags'];
    PIHub.currentProfile!.languages = val['languages'];
    PIHub.currentProfile!.links = [
      if (formKey.currentState!.value['link1'] != null)
        formKey.currentState!.value['link1'],
      if (formKey.currentState!.value['link2'] != null)
        formKey.currentState!.value['link2'],
      if (formKey.currentState!.value['link3'] != null)
        formKey.currentState!.value['link3'],
    ];

    await collection
        .doc(PIHub.currentProfile!.username)
        .update(PIHub.currentProfile!.toMap())
        .then((value) {
      print('Data Uploaded');
      Get.back();
    });
  }
}
