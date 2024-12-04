import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

Widget buildUnitDropdown(
    List<String> units, String? selectedUnit, Function(String?) onChanged) {
  return Expanded(
    child: DropdownButtonFormField<String>(
      value: selectedUnit,
      items: units.map((unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:AppStyle.textBlack,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged, 
      decoration: InputDecoration(
        labelText: 'Select Unit',
        labelStyle: TextStyle(
          fontSize: 14,
          color: AppStyle.blueGrey,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
        ),
        filled: true,
        fillColor:AppStyle.backgroundGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      dropdownColor:AppStyle.backgroundWhite,
      icon: Icon(Icons.arrow_drop_down, color: AppStyle.blueGrey),
      iconSize: 28,
      hint: Text(
        selectedUnit?? "Select Unit",
        style: TextStyle(
          fontSize: 14,
          color: AppStyle.textBlack,
        ),
      ),
    ),
  );
}
