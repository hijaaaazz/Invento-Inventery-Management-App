import 'package:flutter/material.dart';

Widget buildCategoryAutocomplete(
    List<String> categories, TextEditingController categoryController,String? productCategory) {
  return Expanded(
    child: Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return categories.where((category) =>
            category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (selectedCategory) {
        categoryController.text = selectedCategory;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: productCategory??'Select Category', 
            labelStyle: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: Colors.grey[100], 
            border: InputBorder.none, 
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), 
              borderSide: BorderSide.none, 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), 
              borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected,
    Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.41,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueGrey[100],
              ),
              child: ListView.builder(
                shrinkWrap: true, // Allows ListView to size itself based on content
                physics: const NeverScrollableScrollPhysics(), // Prevents internal scrolling
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return Column(
                    children: [
                      ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      ),
                      if (index < options.length - 1)
                        const Divider(
                          height: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.grey,
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },


    ),
  );
}
