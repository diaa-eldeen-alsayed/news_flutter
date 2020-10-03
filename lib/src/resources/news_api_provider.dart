import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'repository.dart';
class NewsApiProvider implements Source{
  final _root="https://hacker-news.firebaseio.com/v0";
  Client client =new Client();
    fetchTopIds() async{
       final response = await client.get("$_root/topstories.json");
       print("response="+response.body);
       final List<dynamic> ids=  json.decode(response.body) ;
        final id= ids.cast<int>();
        return id;
    }
    Future<ItemModel> fetchItem(int id) async{
      final response = await client.get('$_root/item/$id.json');
        final parsedJson = json.decode(response.body);
        print(response.body);
        return ItemModel.fromJson(parsedJson);

    }
}