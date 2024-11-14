import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

AppBar build_product_page_appbar(
  deleteDialog,
  BuildContext ctx,
  AppStyle appstyle
){
  
  return AppBar(
    backgroundColor: appstyle.secondaryColor,
    leading: Padding(
      padding: const EdgeInsets.only(left:  15.0),
      child: IconButton(
        onPressed: (){
          Navigator.of(ctx).pop();
        },
        icon: Icon(Icons.arrow_back_ios_new,size: 15)),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: IconButton(onPressed: (){
          deleteDialog();
        }, icon: Icon(Icons.delete_outline,color: Colors.red,)),
      )
    ],
  );
  
}