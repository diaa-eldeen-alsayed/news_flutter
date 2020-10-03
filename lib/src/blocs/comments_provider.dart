import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentsProvider  extends InheritedWidget{
  final CommentsBloc bloc ;
  CommentsProvider({Key key,Widget child})
  :bloc= new CommentsBloc(),
  super(key:key,child:child);

  @override
  bool updateShouldNotify(_)=>true;
  static CommentsBloc of (BuildContext context){
 return(context.dependOnInheritedWidgetOfExactType<CommentsProvider>().bloc);
  }

}