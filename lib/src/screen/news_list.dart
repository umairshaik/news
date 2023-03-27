import 'package:flutter/material.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top News"),
      ),
      body: buildList(),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return FutureBuilder(
          builder: (context, snapshot) {
            return Container(
              height: 80.0,
              child: snapshot.hasData
                  ? Text("I am visible $index")
                  : Text("I haven't fetched data yet $index"),
            );
          },
          future: getFuture(),
        );
      },
      itemCount: 1000,
    );
  }

  Future<String> getFuture() {
    return Future.delayed(
      const Duration(seconds: 2),
      () => "hi",
    );
  }
}
