import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDBprovider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[newsDBprovider];

  NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIDs();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel? item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }
    for (var chache in caches) {
      chache.addItem(item!);
    }
    return item!;
  }
}

abstract class Source {
  Future<List<int>>? fetchTopIDs();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel itemModel);
}
