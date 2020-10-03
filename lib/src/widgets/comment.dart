import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;

  final Map<int, Future<ItemModel>> itemMap;
   final int depth;

  Comment({this.itemId, this.itemMap ,this.depth});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final item = snapshot.data;
          final children = <Widget>[
            ListTile(
              title: buildText(item),
              subtitle: item.by==""? Text('Deleted') :Text(item.by),
              contentPadding:EdgeInsets.only(left: 16.0,right: 16.0*(depth+1)) ,
            ),
            Divider(),
          ];
          item.kids.forEach((kidId) {
            children.add(Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth+1,
            ));
          });

          return Column(
            children: children,
          );
        });
  }

  buildText(ItemModel item) {
    final text=item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
