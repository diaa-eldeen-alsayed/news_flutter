import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import '../blocs/comments_provider.dart';
import 'dart:async';
import'../widgets/comment.dart';

class NewsDetails extends StatelessWidget {
  final int itemId;

  NewsDetails({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  buildBody(CommentsBloc commentsBloc) {
    return StreamBuilder(
        stream: commentsBloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> sanpshot) {
          if (!sanpshot.hasData) {
            return Text('Loading');
          }
          final itemFuture = sanpshot.data[itemId];
          return FutureBuilder(future: itemFuture,
              builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
                if (!itemSnapshot.hasData) {
                  return Text('Loading');
                }
                return buildList(itemSnapshot.data, sanpshot.data);
              });
        });
  }

  Widget buildTitle(ItemModel data) {
    return Container(
      margin: EdgeInsets.all(10.0), alignment: Alignment.topCenter,
      child: Text(
        data.title, textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),);
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children= <Widget>[];
    children.add(buildTitle(item));
    final commentsList=item.kids.map((kidId) =>  Comment(itemId: kidId,itemMap: itemMap,depth: 0,) ).toList();
    children.addAll(commentsList);
    return ListView(children:children);
  }


}
