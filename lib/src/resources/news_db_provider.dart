import 'repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
class NewsDbProvider implements Source , Cache{
  Database db;
  NewsDbProvider(){
    init();
  }
 void init() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path= join(documentDirectory.path,"items3.db");
    db=await openDatabase(path,version: 1,onCreate: (Database newDb,int version){
       newDb.execute("""
       CREATE TABLE Items
       (id integer primary key,
       type text ,
       by text ,
       time integer ,
       text text,
       parent integer,
       kids BLOB,
       dead integer,
       deleted integer,
       url text,
       score integer,
       title text,
       descendants integer
       )
       """);
    });
  }
  Future<ItemModel> fetchItem(int id)async{
  final maps= await db.query("Items",
    columns: null,
    where: "id = ?",
    whereArgs: [id]
  );

  if(maps.length>0){
    return ItemModel.fromDb(maps.first);
  }
  return null;
  }
  Future<int> addItem(ItemModel itemModel){
    return db.insert("Items", itemModel.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore );
  }

  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    return null;
  }
  @override
  Future<int> clear(){
   return db.delete("Items");
  }

}
final newsDbProvider =new NewsDbProvider();