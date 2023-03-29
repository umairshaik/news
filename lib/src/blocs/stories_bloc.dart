import 'package:news/src/model/item_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  Stream<List<int>> get topIds => _topIds.stream;

  // Steam
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // Sink
  void Function(int event) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        print(index);
        final item = _repository.fetchItem(id);
        if (item != null) {
          cache[id] = item;
        }
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  clearCache() {
    return _repository.clearCache();
  }

  dispose() {
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}
