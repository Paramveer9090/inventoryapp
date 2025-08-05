import 'package:true_leaf_inventory_app/app/widgets/all_import.dart';

class CustomTable extends StatefulWidget {
  final int rowsPerPage;
  final int dataLength;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final ShapeBorder? border;
  final bool isBottom;

  const CustomTable({
    super.key,
    this.rowsPerPage = 10,
    required this.dataLength,
    required this.columns,
    required this.rows,
    this.margin = const EdgeInsets.all(8),
    this.elevation = 3,
    this.border,
    this.isBottom = true,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int rowCount = 0;
  int pageIndex = 0;
  var pageLength = 0;

  @override
  Widget build(BuildContext context) {
    pageLength = (widget.dataLength / 5).ceil();

    return Padding(
      padding: widget.margin,
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: widget.elevation,
            surfaceTintColor: AppColors.whiteColor,
            color: AppColors.whiteColor,
            borderOnForeground: true,
            shape: widget.border ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Color(0XFFb3c8e8),
                    width: 0.8,
                  ),
                ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    clipBehavior: Clip.hardEdge,
                    showBottomBorder: false,
                    columnSpacing: 45,
                    border: TableBorder.all(
                      width: 0.5,
                      color: AppColors.whiteColor,
                    ),
                    headingRowColor: WidgetStatePropertyAll (
                      AppColors.tableColor,
                    ),
                    columns: widget.columns,
                    rows: getRows(
                      context,
                      widget.rows,
                      rowCount,
                      widget.rowsPerPage,
                    ),
                  ),
                ),
                SizedBox(height: widget.isBottom == false ? 0 : 12),
                widget.isBottom == false
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${rowCount + 1} - ${(rowCount + widget.rowsPerPage) > widget.dataLength ? widget.dataLength : (rowCount + widget.rowsPerPage)} of ${widget.dataLength}',
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: rowCount <= 0
                                ? null
                                : () {
                                    rowCount -= widget.rowsPerPage;
                                    pageIndex -= 1;
                                    setState(() {});
                                  },
                            child: const Icon(
                              Icons.arrow_back_ios_outlined,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: rowCount + widget.rowsPerPage >= widget.dataLength
                                ? null
                                : () {
                                    rowCount += widget.rowsPerPage;
                                    pageIndex += 1;
                                    setState(() {});
                                  },
                            child: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                SizedBox(height: widget.isBottom == false ? 0 : 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> getRows(
    BuildContext context,
    List<DataRow> totalRows,
    int rowCount,
    int rowsPerPage,
  ) {
    int startIndex = rowCount * rowsPerPage;
    int endIndex = (rowCount + 1) * rowsPerPage;
    endIndex = endIndex > totalRows.length ? totalRows.length : endIndex;
    return totalRows.sublist(rowCount, rowCount + rowsPerPage > totalRows.length ? totalRows.length : rowCount + rowsPerPage);
  }
}
