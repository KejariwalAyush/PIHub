import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../index.dart';

class SavedView extends StatelessWidget {
  const SavedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile profile = PIHub.currentProfile!;
    return Scaffold(
      appBar: AppBar(
        title: 'Saved PIs'.text.make(),
      ),
      body: DefaultTabController(
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
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Builder(
                    builder: (context) {
                      if (profile.saved.projects.length > 0)
                        return ListView.builder(
                          itemCount: profile.saved.projects.length,
                          itemBuilder: (context, index) {
                            return ProjectContainerBuilder(
                                id: profile.saved.projects[index]);
                          },
                        );
                      return Center(
                        child: Text("No Projects Yet!"),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (profile.saved.ideas.length > 0)
                        return ListView.builder(
                          itemCount: profile.saved.ideas.length,
                          itemBuilder: (context, index) {
                            return IdeaContainerBuilder(
                                id: profile.saved.ideas[index]);
                          },
                        );
                      return Center(child: Text("No Idea's Yet"));
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
