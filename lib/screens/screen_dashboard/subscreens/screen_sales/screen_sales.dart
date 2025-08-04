import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/media_query_helper/media_query_helper.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/helpers/user_prefs.dart';
import 'package:invento2/screens/screen_dashboard/subscreens/screen_sales/sale_item.dart';
import 'package:invento2/screens/screen_register/widgets/widget_forms/widget_form.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenSales extends StatefulWidget {
  const ScreenSales({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScreenSalesState createState() => _ScreenSalesState();
}

class _ScreenSalesState extends State<ScreenSales> {
  final TextEditingController _searchController = TextEditingController();
  List<SalesModel> filteredSales = [];
  String filterOption = 'invoice';
  DateTime selectedDate = DateTime.now();
  String _currencySymbol="";


  @override
  void initState() {
    super.initState();
   filteredSales = List.from(
  salesList.value
)..sort((a, b) => b.id.compareTo(a.id));

  _loadCurrencySymbol();  // Load the currency symbol when the widget is initialized
  }

  // Asynchronous function to load the currency symbol
  _loadCurrencySymbol() async {
    String symbol = await AppPreferences.symbol; // Fetch symbol asynchronously
    setState(() {
      _currencySymbol = symbol;  // Update the state with the fetched symbol
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

 void _filterSales(String query) {
  final filtered = salesList.value.where((sale) {

    if (filterOption == 'invoice') {
      return sale.saleNumber.toLowerCase().contains(query.toLowerCase());
    } else if (filterOption == 'customer' && sale.customerName != null) {
      return sale.customerName!.toLowerCase().contains(query.toLowerCase());
    } else if (filterOption == 'customerNumber' && sale.customerNumber != null) {
      return sale.customerNumber!.toString().contains(query);
    } else if (filterOption == 'date') {
      int? microseconds = int.tryParse(sale.id.toString());
      if (microseconds != null) {
        DateTime saleDate = DateTime.fromMicrosecondsSinceEpoch(microseconds);
        return saleDate.year == selectedDate.year &&
            saleDate.month == selectedDate.month &&
            saleDate.day == selectedDate.day;
      }
    }
    return false;
  }).toList();

  setState(() {
    filteredSales = filtered;
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
                    _filterSales(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Customer Name"),
                onTap: () {
                  setState(() {
                    filterOption = 'customer';
                    FocusScope.of(context).unfocus();
                    _filterSales(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Customer Number"),
                onTap: () {
                  setState(() {
                    filterOption = 'customerNumber';
                    FocusScope.of(context).unfocus();
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
        _filterSales(''); 
      });
    }
  }

  @override
    Widget build(BuildContext context) {
      return ValueListenableBuilder<List<SalesModel>>(
        valueListenable: salesList,
        builder: (context, sales, child) {
         double totalSaleValue = sales.fold(0, (a, b) =>
         a + b.grandTotal
    );
          return Scaffold(
            backgroundColor: AppStyle.backgroundWhite,
            appBar: appBarHelper("sales"),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient:LinearGradient(
                          
                          colors: AppStyle.gradientGreen,
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
                                "Total Sales Value :",
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppStyle.textBlack,
                                ),
                              ),
                              SizedBox(
                                height: 50, // Adjust based on your needs
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "$_currencySymbol ${totalSaleValue.toString()}",
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
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _searchController,
                              onChanged: (value) => _filterSales(value), // Explicit ValueChanged<String>
                              hintText: filterOption == 'customer'
                                  ? "Search by customer name..."
                                  : filterOption == 'invoice'
                                      ? "Search by invoice number..."
                                      : filterOption== "customerNumber"
                                      ? "Search by Supplier Mobile Number":
                                      "Filter By Date",
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

                    SizedBox(
                      height: MediaQueryInfo.screenHeight * 0.785,
                      child: filteredSales.isEmpty
                          ? const Center(child:Text("No Sales Recorded Yet",style:TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),),)
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: ListView.builder(
                                itemCount: filteredSales.length,
                                itemBuilder: (context, index) {
                                  final sale = filteredSales[index];
                                  return SaleItem(sale: sale, currencySymbol: _currencySymbol,);
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
