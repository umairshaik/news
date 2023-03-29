import 'dart:async';

import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Stream
  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  //Sink
  void Function(int id) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      cache[id]!.then((ItemModel itemModel) {
        itemModel.kids.forEach((kidId) => fetchItemWithComments(kidId));
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }
}
