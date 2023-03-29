import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/src/model/item_model.dart';
import 'package:news/src/widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  const Comment(
      {super.key,
      required this.itemId,
      required this.itemMap,
      required this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingContainer();
        }
        final item = snapshot.data!;
        final itemBy = item.by == "" ? "Deleted" : item.by;
        final childern = <Widget>[
          ListTile(
            title: Html(data: item.text),
            subtitle: Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(itemBy),
            ),
            contentPadding: EdgeInsets.only(left: depth * 16.0),
          ),
          const Divider(),
        ];

        for (var kidID in item.kids) {
          childern.add(Comment(
            itemId: kidID,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        }
        return Column(children: childern);
      },
    );
  }
}
