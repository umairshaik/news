import 'dart:ffi';

import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsDBProvider(),
    NewsApiProvider(),
  ];

  List<Cache> cache = <Cache>[NewsDBProvider()];

  NewsDBProvider dbProvider = NewsDBProvider();
  NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIDs();
  }

  Future<ItemModel> fetchItem(int id) async {
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    item = await apiProvider.fetchItem(id);
    dbProvider.addItem(item);
    return item;
  }
}

abstract class Source {
  Future<List<int>>? fetchTopIDs();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel itemModel);
}
