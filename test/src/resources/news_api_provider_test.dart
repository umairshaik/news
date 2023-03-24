import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:news/src/resources/news_api_provider.dart';

void main() {
  test('Given api url When fetchTopIDs is called Then return list of IDs',
      () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      expect(request.url,
          Uri.parse("https://hacker-news.firebaseio.com/v0/topstories.json"));
      return Response(jsonEncode([1, 2, 3, 4]), 200);
    });
    final ids = await newsApi.fetchTopIDs();
    expect(ids, [1, 2, 3, 4]);
  });

  test('Given an ID When fetchItem is called Then return Item model', () async {
    final newsApi = NewsApiProvider();
    const id = 10;
    final jsonMap = {
      "by": "dhouston",
      "descendants": 71,
      "id": id,
      "kids": [
        8952,
        9224,
        8917,
        8884,
        8887,
        8943,
        8869,
        8958,
        9005,
        9671,
        8940,
        9067,
        8908,
        9055,
        8865,
        8881,
        8872,
        8873,
        8955,
        10403,
        8903,
        8928,
        9125,
        8998,
        8901,
        8902,
        8907,
        8894,
        8878,
        8870,
        8980,
        8934,
        8876
      ],
      "score": 111,
      "time": 1175714200,
      "title": "My YC app: Dropbox - Throw away your USB drive",
      "type": "story",
      "url": "http://www.getdropbox.com/u/2/screencast.html"
    };

    newsApi.client = MockClient((request) async {
      expect(request.url,
          Uri.parse("https://hacker-news.firebaseio.com/v0/item/$id.json"));
      return Response(jsonEncode(jsonMap), 200);
    });
    final itemModel = await newsApi.fetchItem(id);
    expect(itemModel.id, 10);
  });
}
