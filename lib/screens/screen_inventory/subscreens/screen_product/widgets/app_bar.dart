import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

// ignore: non_constant_identifier_names
AppBar build_product_page_appbar(
  deleteDialog,
  BuildContext ctx,
  AppStyle appstyle
){
  
  return AppBar(
    backgroundColor: appstyle.BackgroundWhite,
    leading: Padding(
      padding: const EdgeInsets.only(left:  15.0),
      child: IconButton(
        onPressed: (){
          Navigator.of(ctx).pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new,size: 15)),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(onPressed: (){
          deleteDialog();
        }, icon: const Icon(Icons.delete_outline,color: Colors.red,)),
      )
    ],
  );
  
}