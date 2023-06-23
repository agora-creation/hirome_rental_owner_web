import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomDataGrid extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> columns;

  const CustomDataGrid({
    required this.source,
    required this.columns,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: source,
      onQueryRowHeight: (details) {
        return details.getIntrinsicRowHeight(details.rowIndex);
      },
      columns: columns,
      columnWidthMode: ColumnWidthMode.fill,
    );
  }
}
