import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/widgets/category_auto_complete.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/widgets/error_dialog.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/widgets/text_fiels.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/widgets/unit_dropdown.dart';

class ScreenAddProduct extends StatefulWidget {

  const ScreenAddProduct({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScreenAddProductState createState() => _ScreenAddProductState();
}
class _ScreenAddProductState extends State<ScreenAddProduct> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  String? imagePath;
  String? _selectedUnit;
  final List<String> _units = ['Kg', 'Ltr', 'Pcs']; 
  TextStyle headStyle= GoogleFonts.inter(
     fontSize: 15,
     fontWeight: FontWeight.bold,
     color: const Color.fromARGB(255, 0, 0, 0)
  );

  

  final _categories = categoryListNotifier.value
    .map((category) => category.name)
    .where((name) => name != null) 
    .cast<String>() 
    .toList();

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    _mrpController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
Future<void> _addProduct() async {
  if (_itemNameController.text.isEmpty ||
      _descriptionController.text.isEmpty ||
      _rateController.text.isEmpty ||
      _mrpController.text.isEmpty ||
      _minStockController.text.isEmpty ||
      _maxStockController.text.isEmpty ||
      _categoryController.text.isEmpty ||
      _selectedUnit == null ||
      imagePath == "assets/images/box.jpg") {
    showErrorDialog(context,"Please fill all fields and select an image.");
    return;
  }

  final productId = DateTime.now().millisecondsSinceEpoch.toString();
  final name = _itemNameController.text;
  final description = _descriptionController.text;
  final rate = double.tryParse(_rateController.text) ?? 0;
  final price = double.tryParse(_mrpController.text) ?? 0;
  final minStock = double.tryParse(_minStockController.text) ?? 0;
  final maxStock = double.tryParse(_maxStockController.text) ?? 0;
  final category = _categoryController.text;
  final unit = _selectedUnit ?? '';
  final productImage = imagePath;

  final success = await addProduct(
    id: productId,
    name: name,
    category: category,
    description: description,
    unit: unit,
    rate: rate,
    price: price,
    minlimit: minStock,
    maxlimit: maxStock,
    userId: userDataNotifier.value.id,
    productImage: productImage!,
  );

  if (success) {
    _clearForm();
    Navigator.of(context).pop();
  }
}


 void _clearForm() {
    _itemNameController.clear();
    _descriptionController.clear();
    _rateController.clear();
    _mrpController.clear();
    _minStockController.clear();
    _maxStockController.clear();
    _categoryController.clear();
    setState(() {
      _selectedUnit = null;
      imagePath = null;
    });
  }


 

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: build_appbar(_addProduct),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("General Information", style:headStyle),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
  onTap: () {
    _pickImage();
  },
  child: CircleAvatar(
    radius: 64, 
    backgroundImage: imagePath != null
        ? FileImage(File(imagePath!)) 
        : const AssetImage('assets/images/box.jpg') as ImageProvider, 
    backgroundColor: Colors.grey[300], 
    child: 
         const Center(
            child: Text(
              '''Add\nImage''',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          )
  ),
),
const SizedBox(height: 15,),

            buildTextField(label: "Item Name", controller: _itemNameController),
            buildTextField(label: "Description", controller: _descriptionController),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Pricing Information", style:headStyle),
              ],
            ),
            Row(
              children: [
                Expanded(child: buildTextField(label: "Rate", controller: _rateController, keyboardType: TextInputType.number)),
                Expanded(child: buildTextField(label: "MRP", controller: _mrpController, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Stock Information", style:headStyle),
              ],
            ),
            Row(
              children: [
                Expanded(child: buildTextField(label: "Minimum Stock", controller: _minStockController, keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(child: buildTextField(label: "Maximum Stock", controller: _maxStockController, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 10),            
            Row(
              children: [
                buildCategoryAutocomplete(_categories, _categoryController),
                const SizedBox(width: 20),
                buildUnitDropdown(_units, _selectedUnit, onChanged)
                
              ],
            ),
            SizedBox(height: keyboardHeight > 0 ? 100 : 0), 
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  void onChanged(String? newValue) {
  setState(() {
    _selectedUnit = newValue;
  });
}
  
  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      imagePath = pickedFile.path;
    });
  } else {
    // ignore: use_build_context_synchronously
    showErrorDialog(context,"No image selected.");
  }
}





 
    
}

AppBar build_appbar(VoidCallback addProduct) {
  return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Add Product",
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: addProduct, 
            ),
          ),
        ],
      );
}