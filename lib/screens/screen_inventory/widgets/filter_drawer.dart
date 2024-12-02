
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';

class FilterDrawer extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final double minPrice;
  final double maxPrice;
  final Function getMaxPrice;
  final Function(double, double) onPriceChanged;
  final Function(String) onCategorySelected;
  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onCloseDrawer;

  const FilterDrawer({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.minPrice,
    required this.maxPrice,
    required this.getMaxPrice,
    required this.onPriceChanged,
    required this.onCategorySelected,
    required this.onApplyFilters,
    required this.onClearFilters,
    required this.onCloseDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: MediaQueryInfo.screenHeight*0.47,
      decoration: BoxDecoration(
        color: AppStyle.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 10,
            offset: const Offset(0,10),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQueryInfo.screenWidth*0.08,vertical: MediaQueryInfo.screenHeight*0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text('Filter Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15,),
            Text("Categories",style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500
               ),),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, 
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index]; 
                  final isSelected = selectedCategories.contains(category); // Check if it's selected
              
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Add space between chips
                    child: FilterChip(
                      showCheckmark: false,
                      shape: StadiumBorder(side: BorderSide(color: AppStyle.backgroundPurple, width: 1)),
                      backgroundColor: AppStyle.backgroundWhite,
                      selectedColor: AppStyle.backgroundPurple,
                      elevation: 2,
                      label: Text(
                        category,
                        style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppStyle.backgroundWhite : AppStyle.backgroundPurple,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        onCategorySelected(category); // Call the provided function when selected
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text("Price Range",style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500
               ),),
                RangeSlider(
                  activeColor: AppStyle.backgroundPurple,
                  values: RangeValues(minPrice, maxPrice),
                  min: 0.0,
                  max: getMaxPrice(),
            
                  onChanged: (values) => onPriceChanged(values.start, values.end),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${minPrice.toStringAsFixed(2)}'),
                    Text('₹${maxPrice.toStringAsFixed(2)}')
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.backgroundWhite, 
                    textStyle: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), 
                    ),
                  ),
                  onPressed: onClearFilters,
                  child: const Text('Clear Filters'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.backgroundWhite, 
                    textStyle: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: AppStyle.backgroundPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), 
                    ),
                  ),
                  onPressed: onApplyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
