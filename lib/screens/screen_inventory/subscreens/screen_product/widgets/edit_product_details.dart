import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/product/product_functions.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_add/subscreens/screen_add_product/widgets/category_auto_complete.dart';

class EditProduct extends StatefulWidget {
  final ValueNotifier<ProductModel> productNotifier;
  final ValueNotifier<List<ProductModel>>? gridViewNotifier;
  final VoidCallback? getMaxPrice;
   final VoidCallback? clearfilter;

  const EditProduct({
    super.key,
    required this.productNotifier,
    this.gridViewNotifier,
    this.getMaxPrice,
    this.clearfilter
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController rateController;
  final _categories = categoryListNotifier.value
    .map((category) => category.name)
    .cast<String>() 
    .toList();

  late ValueNotifier<File?> imageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    
    nameController = TextEditingController(text: widget.productNotifier.value.name);
    descriptionController = TextEditingController(text: widget.productNotifier.value.description);
    categoryController = TextEditingController(text: widget.productNotifier.value.category);
    priceController = TextEditingController(text: widget.productNotifier.value.price.toString());
    rateController = TextEditingController(text: widget.productNotifier.value.rate.toString());
    

    // Initialize image file
    imageFile = ValueNotifier<File?>(
      widget.productNotifier.value.productImage.isNotEmpty
          ? File(widget.productNotifier.value.productImage)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Product Details",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics:const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQueryInfo.screenHeight * 0.95,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ValueListenableBuilder<File?>(
                    valueListenable: imageFile,
                    builder: (context, file, _) {
                      return GestureDetector(
                        onTap: () => pickImage(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: file != null
                              ? Image.file(
                                  file,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 150,
                                  width: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQueryInfo.screenHeight * 0.55,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        buildTextField("Product Name", nameController),
                        buildTextField("Product Description", descriptionController, maxLines: 3),
                        Text("Category",style: GoogleFonts.outfit(fontSize: 16),),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: buildCategoryAutocomplete(_categories,categoryController,widget.productNotifier.value.category)),

                        buildTextField("Price", priceController, inputType: TextInputType.number),
                        buildTextField("Rate", rateController, inputType: TextInputType.number),
                        const SizedBox(height: 30),
                        
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom == 0
                              ? MediaQueryInfo.screenHeight * 0.0
                              : MediaQueryInfo.screenHeight * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25,),
                Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.outfit(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                await updateProduct(
                                  id: widget.productNotifier.value.productId,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  category: categoryController.text,
                                  price: double.tryParse(priceController.text) ?? widget.productNotifier.value.price,
                                  rate: double.tryParse(rateController.text) ?? widget.productNotifier.value.rate,
                                  productImage: imageFile.value?.path ?? widget.productNotifier.value.productImage,
                                  minlimit: widget.productNotifier.value.minlimit,
                                  maxlimit: widget.productNotifier.value.maxlimit,
                                );

                                widget.productNotifier.value = widget.productNotifier.value.copyWith(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  category: categoryController.text,
                                  price: double.tryParse(priceController.text) ?? widget.productNotifier.value.price,
                                  rate: double.tryParse(rateController.text) ?? widget.productNotifier.value.rate,
                                  productImage: imageFile.value?.path ?? widget.productNotifier.value.productImage,
                                );

                                if (widget.gridViewNotifier != null) {
                                  final index = widget.gridViewNotifier!.value.indexWhere(
                                    (p) => p.productId == widget.productNotifier.value.productId,
                                  );
                                  widget.gridViewNotifier?.value[index] = widget.productNotifier.value;
                                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                  widget.gridViewNotifier?.notifyListeners();
                                }
                                if (widget.getMaxPrice != null) {
                                  widget.getMaxPrice!();
                                }
                                if (widget.clearfilter != null) {
                                  widget.clearfilter!();
                                }

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Save",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // Widget to build text fields
  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: inputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
