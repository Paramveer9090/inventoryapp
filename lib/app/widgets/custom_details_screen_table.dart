import 'package:flutter/material.dart';

class CustomDetailsScreenTable extends StatelessWidget {
  final Map<String, String> tableData;
  final orderItem;
  final imageURl;

  const CustomDetailsScreenTable({
    super.key,
    required this.tableData,
    this.imageURl,
    this.orderItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(8),
          width: 1,
          color: Colors.grey,
        ),
        children: [
          ...tableData.entries.map(
            (e) => TableRow(
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: e.key == "Expense Items" || e.key == "Order Items"
                        ? orderItem
                        : e.key == "image"
                            ? Image.network(
                                imageURl,
                              )
                            : Text(
                                e.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
