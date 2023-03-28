import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'package:news/src/resources/news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDBprovider,
    NewsApiProvider(),
  ];

  final List<Cache> _caches = <Cache>[newsDBprovider];

  NewsApiProvider apiProvider = NewsApiProvider();

  Future<List<int>> fetchTopIds() {
    return apiProvider.fetchTopIDs();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel? item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }
    for (var chache in _caches) {
      if (_caches != source) {
        chache.addItem(item!);
      }
    }
    return item!;
  }

  clearCache() async {
    for (var cache in _caches) {
      await cache.clearCache();
    }
  }
}

abstract class Source {
  Future<List<int>>? fetchTopIDs();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel itemModel);
  Future<int> clearCache();
}
