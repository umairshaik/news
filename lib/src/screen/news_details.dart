import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/model/item_model.dart';

import '../widgets/comment.dart';

class NewsDetails extends StatelessWidget {
  final int itemId;
  const NewsDetails({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: buildBody(bloc));
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        }
        final itemFutuer = snapshot.data![itemId];
        return FutureBuilder(
          future: itemFutuer,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return const Text('Loading');
            }
            return buildList(itemSnapshot.data!,
                snapshot.data!); //buildTitle(itemSnapshot.data!);
          },
        );
      },
    );
  }

  Widget buildTitle(ItemModel itemModel) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(12.0),
      child: Text(
        itemModel.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final childern = <Widget>[buildTitle(item)];

    final List<Comment> commentList = item.kids.map((kidId) {
      return Comment(itemId: kidId, itemMap: itemMap, depth: 0);
    }).toList();
    childern.addAll(commentList);

    return ListView(
      children: childern,
    );
  }
}
