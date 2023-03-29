import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/model/item_model.dart';

import 'loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  const NewsListTile({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return const LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data!);
          },
        );
      },
      stream: bloc.items,
    );
  }

  Widget buildTile(BuildContext context, ItemModel itemModel) {
    return Column(
      children: [
        ListTile(
          title: Text(itemModel.title),
          subtitle: Text(
            "${itemModel.score} points",
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          trailing: Column(
            children: [
              const Icon(Icons.comment),
              Text("${itemModel.descendants}")
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/${itemModel.id}');
          },
        ),
        const Divider(),
      ],
    );
  }
}
