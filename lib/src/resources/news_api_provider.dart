import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart';
import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/repository.dart';

final _base_url = "https://hacker-news.firebaseio.com/v0";

class NewsApiProvider implements Source {
  Client client = Client();

  @override
  Future<List<int>> fetchTopIDs() async {
    final response = await client.get(Uri.parse("$_base_url/topstories.json"));
    final ids = jsonDecode(response.body);
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse("$_base_url/item/$id.json"));
    final parsedJson = jsonDecode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
