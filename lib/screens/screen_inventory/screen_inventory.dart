import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:invento2/database/inventory/category/category_functions.dart';
import 'package:invento2/database/inventory/category/category_model.dart';
import 'package:invento2/database/inventory/product/product_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_category.dart';
import 'package:invento2/screens/screen_inventory/subscreens/screen_product.dart';
import 'package:invento2/screens/screen_inventory/widgets/add_category_dialog.dart';

class ScreenInventory extends StatefulWidget {
  final dynamic userData;

  ScreenInventory({Key? key, required this.userData}) : super(key: key);

  @override
  State<ScreenInventory> createState() => _ScreenInventoryState();
}

class _ScreenInventoryState extends State<ScreenInventory> {
  late List<Product> productList;
  late List<CategoryModel> categoryList;

  @override
void initState() {
  super.initState();

  // Check if the user data is valid
  if (widget.userData == null || widget.userData.id == null) {
    print("User data is null or missing ID");
    productList = [];
    categoryList = [];
  } else {
    // Load products for the specific user
    productList = _generateDummyProductList();

    // Load categories from Hive
    _loadCategories();
  }
}

// Load categories from Hive
// Load categories from Hive
void _loadCategories() async {
  try {
    // Open the Hive box if not already open
    if (!Hive.isBoxOpen('categorybox')) {
      await Hive.openBox<CategoryModel>('categorybox');
    }

    // Assign the loaded categories to categoryList
    final categoryBox = Hive.box<CategoryModel>('categorybox');
    categoryList = categoryBox.values
        .where((category) => category.userId == widget.userData.id)
        .toList();
    
    // Call setState to update the UI
    setState(() {});
  } catch (e) {
    print("Error loading categories: $e");
  }
}


  // Generate a dummy product list based on user ID
  List<Product> _generateDummyProductList() {
    return [];
  }

  // Define category gradients
  final List<List<Color>> categoryGradients = [
    [Colors.red, Colors.orange],
    [Colors.green, Colors.blue],
    [Colors.purple, Colors.pink],
    [Colors.blueAccent, Colors.cyan],
    [Colors.deepOrange, Colors.redAccent],
  ];

  @override
  Widget build(BuildContext context) {
    final userSpecificProducts = productList.where((product) => product.userId == widget.userData.id).toList();
    final userSpecificCategories = productList.where((category) => category.userId == widget.userData.id).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
           SizedBox(height: 15),
          _buildAllSection(userSpecificProducts),

          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  ValueListenableBuilder<List<CategoryModel>>(
  valueListenable: categoryListNotifier,
  builder: (ctx, updatedList, _) {
    // Filter the updated list to include only categories that match the user ID
    final userSpecificCategories = updatedList
        .where((category) => category.userId == widget.userData.id)
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: userSpecificCategories.length,
      itemBuilder: (context, index) {
        final category = userSpecificCategories[index];
        return _buildCategorySection(category, index, userSpecificProducts);
      },
    );
  },
),
                  const SizedBox(height: 15),
                  // Add New Category Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth * 0.07, vertical: MediaQueryInfo.screenHeight * 0.15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          showAddCategoryDialog(context, widget.userData.id);
                        },
                        child: Text(
                          "Add New Category",
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildCategorySection(CategoryModel category, int index, List<Product> userProducts) {
  if (category.name == null || category.name!.isEmpty) return Container();

  final productsInCategory = userProducts
      .where((product) => product.category != null && product.category == category.name)
      .toList();

  if (productsInCategory.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15,top: 10),
            child: Text(
              category.name ?? '',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,),
            child: Text(
              'No products available in this category',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child:GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return ScreenProductList(
              title: category.name ?? '',
              userProducts: productsInCategory,
            );
            }));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name ?? '',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward_ios_outlined)
              ],
            ),
          ),
        )
      ),
      CarouselSlider(
        items: productsInCategory.map((product) {
          return GestureDetector(
            onTap: () {
              // Navigate to the product details page
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: categoryGradients[index % categoryGradients.length],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Semantics(
                  label: 'Product: ${product.name}',
                  child: Text(
                    product.name,
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height:120,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction:0.5,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayInterval: const Duration(seconds: 3),
        ),
      ),
    ],
  );
}


  // Build the section for displaying all products
  Widget _buildAllSection(List<Product> userProducts) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ScreenProductList(title: "All Products", userProducts: []);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Products",
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
        ),
        CarouselSlider(
          items: userProducts.map((product) {
            return GestureDetector(
              onTap: () {
                // Navigate to the product details page
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Semantics(
                    label: 'Product: ${product.name}',
                    child: Text(
                      product.name,
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayInterval: const Duration(seconds: 3),
          ),
        ),
      ],
    ),
  );
}


  // AppBar with title and search button
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        "Inventory",
        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Add search functionality here
          },
        ),
      ],
    );
  }
}
