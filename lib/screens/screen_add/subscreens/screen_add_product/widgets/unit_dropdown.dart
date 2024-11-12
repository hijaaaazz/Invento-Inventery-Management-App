import 'package:flutter/material.dart';

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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged, // Directly use the passed callback
      decoration: InputDecoration(
        labelText: 'Select Unit',
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.blueGrey,
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
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
      iconSize: 28,
      hint: const Text(
        "Select Unit",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
