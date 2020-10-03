import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
class StoriesBloc{

final _topIds=PublishSubject<List<int>>();
final _repository=new Repository();
final _itemsOutput=new BehaviorSubject<Map<int,Future<ItemModel>>>();
final _itemsFetcher=PublishSubject<int>();

//Getter to Streams
  Stream<List<int>> get topIds=>_topIds.stream;

  Stream<Map<int,Future<ItemModel>>> get items=>_itemsOutput.stream;
  //Getter to Sinks
   Function(int) get fetchItem=>_itemsFetcher.sink.add;
   StoriesBloc(){
      _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
   }


   fetchTopIds()async{
     final ids=await _repository.fetchTopIds();
     _topIds.sink.add(ids);
   }
   clearCache(){
     return _repository.clearCache();
   }
   _itemsTransformer(){
     return ScanStreamTransformer((Map<int,Future<ItemModel>> cache,int id, index){
       print(index);
        cache[id]=_repository.fetchItem(id);
        return cache;
     },<int,Future<ItemModel>>{},);
   }
  dispose(){
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }

}