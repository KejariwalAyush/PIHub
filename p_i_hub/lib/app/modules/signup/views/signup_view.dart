import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:p_i_hub/app/data/index.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
    final RxBool isLoading = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Build your Account"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: controller.formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.maxLength(context, 10),
                          FormBuilderValidators.minLength(context, 5),
                          (val) {
                            if (val.toString().contains(' '))
                              return 'Spaces not allowed';
                            else
                              return null;
                          }
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
                    child: Text("Let's Go"),
                    onPressed: () async {
                      isLoading.toggle();
                      controller.formKey.currentState!.saveAndValidate();
                      print(controller.formKey.currentState!.value['username']);
                      if (!await controller.isValidUsername(
                          controller.formKey.currentState!.value['username'])) {
                        controller.formKey.currentState?.invalidateField(
                            name: 'username',
                            errorText: 'Username already taken.');
                      } else {
                        controller.signUpUser();
                      }
                      isLoading.toggle();
                    },
                  ).w(context.width)),
          ],
        ),
      ),
    );
  }
}
