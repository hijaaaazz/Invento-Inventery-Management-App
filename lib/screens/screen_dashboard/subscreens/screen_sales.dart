import 'package:flutter/material.dart';
import 'package:invento2/database/inventory/sales/sales_functions.dart';
import 'package:invento2/database/inventory/sales/sales_model.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenSales extends StatefulWidget {
  @override
  _ScreenSalesState createState() => _ScreenSalesState();
}

class _ScreenSalesState extends State<ScreenSales> {
  final TextEditingController _searchController = TextEditingController();
  List<SalesModel> filteredSales = [];
  String filterOption = 'invoice';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    filteredSales = salesList.value; // Assuming salesList is defined globally
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
      } else if (filterOption == 'date' && selectedDate != null) {
        // Parse the sale.id (microseconds) and convert to DateTime
        int? microseconds = int.tryParse(sale.id.toString());
        if (microseconds != null) {
          DateTime saleDate = DateTime.fromMicrosecondsSinceEpoch(microseconds);

          // Compare only the date part (ignoring time)
          return saleDate.year == selectedDate!.year &&
              saleDate.month == selectedDate!.month &&
              saleDate.day == selectedDate!.day;
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
          title: Text("Filter by"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Invoice Number"),
                onTap: () {
                  setState(() {
                    filterOption = 'invoice';
                    _filterSales(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Customer Name"),
                onTap: () {
                  setState(() {
                    filterOption = 'customer';
                    _filterSales(_searchController.text);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Purchase Date"),
                onTap: () {
                  setState(() {
                    filterOption = 'date';
                  });
                  Navigator.pop(context);
                  _pickDate(); // Trigger the date picker
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _filterSales(''); // Refresh the list based on the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.BackgroundWhite,
      appBar: appBarHelper("Sales History"),
      body: Column(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSales,
                    decoration: InputDecoration(
                      hintText: filterOption == 'customer'
                          ? "Search by customer name..."
                          : filterOption == 'invoice'
                              ? "Search by invoice number..."
                              : "Filter by date selected",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<SalesModel>>(
              valueListenable: salesList, // Assuming `salesList` is a ValueNotifier
              builder: (context, sales, child) {
                if (filteredSales.isEmpty) {
                  return Center(child: Text("No sales found"));
                }

                return ListView.builder(
                  itemCount: filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = filteredSales[index];
                    return SaleItem(sale: sale);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SaleItem extends StatelessWidget {
  final SalesModel sale;

  const SaleItem({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text("Invoice: ${sale.saleNumber}"),
        subtitle: Text("Customer: ${sale.customerName ?? 'N/A'}"),
        trailing: Text("Total: \$${sale.grandTotal.toStringAsFixed(2)}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesDetails(sale: sale),
            ),
          );
        },
      ),
    );
  }
}

class SalesDetails extends StatelessWidget {
  final SalesModel sale;

  const SalesDetails({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details: ${sale.saleNumber}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Invoice Number: ${sale.saleNumber}"),
            SizedBox(height: 8),
            Text("Customer: ${sale.customerName ?? 'N/A'}"),
            SizedBox(height: 8),
            Text("Grand Total: \$${sale.grandTotal.toStringAsFixed(2)}"),
            SizedBox(height: 16),
            Text("Items:"),
            ...sale.saleProducts.map((product) {
              return ListTile(
                title: Text(product.product.name),
                subtitle: Text("Quantity: ${product.quantity}"),
                trailing: Text("\$${(product.product.rate * product.quantity).toStringAsFixed(2)}"),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
