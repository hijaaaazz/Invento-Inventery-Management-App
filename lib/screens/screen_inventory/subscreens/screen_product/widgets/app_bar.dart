import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

AppBar build_product_page_appbar(
  BuildContext ctx,
  AppStyle appstyle
){
  
  return AppBar(
    backgroundColor: appstyle.secondaryColor,
    leading: IconButton(
      onPressed: (){
        Navigator.of(ctx).pop();
      },
      icon: Icon(Icons.arrow_back_ios_new,size: 15)),
    actions: [
      IconButton(onPressed: (){
      }, icon: Icon(Icons.delete,color: appstyle.primaryColor,))
    ],
  );
  
}