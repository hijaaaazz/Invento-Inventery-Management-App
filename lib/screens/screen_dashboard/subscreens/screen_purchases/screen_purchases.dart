import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/purchase/purchase_functions.dart';
import 'package:invento2/database/inventory/purchase/purchase_model.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_purchases/purchase_tile.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenPurchases extends StatefulWidget {
  const ScreenPurchases({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScreenPurchasesState createState() => _ScreenPurchasesState();
}

class _ScreenPurchasesState extends State<ScreenPurchases> {
  final TextEditingController _searchController = TextEditingController();
  List<PurchaseModel> filteredPurchases = [];
  String filterOption = 'invoice';
  DateTime selectedDate = DateTime.now();

@override
void initState() {
  super.initState();

  filteredPurchases = List.from(purchasesList.value)..sort((a, b) {
    return b.id.compareTo(a.id);
  });
}



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPurchases(String query) {
    final filtered = purchasesList.value.where((purchase) {
      if (filterOption == 'invoice') {
        return purchase.purchaseNumber.toLowerCase().contains(query.toLowerCase());
      } else if (filterOption == 'supplier' && purchase.supplierName != null) {
        return purchase.supplierName!.toLowerCase().contains(query.toLowerCase());
      } else if (filterOption == 'customerNumber' && purchase.supplierPhone != null) {
        return purchase.supplierPhone!.toString().contains(query);
      } else if (filterOption == 'date') {
        int? microseconds = int.tryParse(purchase.id.toString());
        if (microseconds != null) {
          DateTime purchaseDate = DateTime.fromMicrosecondsSinceEpoch(microseconds);

          return purchaseDate.year == selectedDate.year &&
              purchaseDate.month == selectedDate.month &&
              purchaseDate.day == selectedDate.day;
        }
      }
      return false;
    }).toList();

    setState(() {
      filteredPurchases = filtered;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter by"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Invoice Number"),
                onTap: () {
                  setState(() {
                    filterOption = 'invoice';
                    FocusScope.of(context).unfocus();
                    _filterPurchases(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Supplier Name"),
                onTap: () {
                  setState(() {
                    filterOption = 'supplier';
                    FocusScope.of(context).unfocus();
                    _filterPurchases(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Suppplier Number"),
                onTap: () {
                  setState(() {
                    filterOption = 'customerNumber';
                    FocusScope.of(context).unfocus();
                    _filterPurchases(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Purchase Date"),
                onTap: () {
                  setState(() {
                    filterOption = 'date';
                    FocusScope.of(context).unfocus();
                  });
                  Navigator.pop(context);
                  _pickDate(); 
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _filterPurchases(''); 
      });
    }
  }


  @override
  Widget build(BuildContext context) {
      return ValueListenableBuilder<List<PurchaseModel>>(
        valueListenable: purchasesList,
        builder: (context, purchase, child) {
         double totalPurchaseValue = purchase.fold(0, (a, b) => a + b.grandTotal);
          return Scaffold(
            backgroundColor: AppStyle.backgroundWhite,
            appBar: appBarHelper("purchases"),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient:const LinearGradient(
                          
                          colors: AppStyle.gradientorange,
                          ) 
                      ),
                      height: MediaQueryInfo.screenHeight*0.15,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Purchase Value :",
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppStyle.textBlack,
                                ),
                              ),
                              SizedBox(
                                height: 50, 
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "₹ ${totalPurchaseValue.toString()}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyle.textWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _searchController,
                              onChanged: (value) => _filterPurchases(value), 
                              hintText: filterOption == 'customer'
                                  ? "Search by customer name..."
                                  : filterOption == 'invoice'
                                      ? "Search by invoice number..."
                                      : "Filter by date selected",
                              icon: Icons.search,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: _showFilterDialog,
                          ),
                        ],
                      ),
                                        ),
                    ),

                    SizedBox(
                      height: MediaQueryInfo.screenHeight * 0.785,
                      child: filteredPurchases.isEmpty
                          ? const Center(child: Text("No sales found"))
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: ListView.builder(
                                itemCount: filteredPurchases.length,
                                itemBuilder: (context, index) {
                                  final purchase = filteredPurchases[index];
                                  return PurchaseItemWidget(purchase: purchase);
                                },
                              ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
}