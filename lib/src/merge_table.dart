part of merge_table;

class MergeTable extends StatelessWidget {
  MergeTable({
    Key? key,
    required this.rows,
    required this.columns,
    required this.borderColor,
    this.alignment = MergeTableAlignment.center,
  }) : super(key: key) {
    columnWidths = fetchColumnWidths(columns);
    assert(columns.isNotEmpty);
    assert(rows.isNotEmpty);
    for (List<BaseMRow> row in rows) {
      assert(row.length == columns.length);
    }
  }

  final Color borderColor;
  final List<BaseMColumn> columns;
  final List<List<BaseMRow>> rows;
  final MergeTableAlignment alignment;
  late final Map<int, TableColumnWidth> columnWidths;

  TableCellVerticalAlignment get defaultVerticalAlignment => alignment.tableAlignment;
  AlignmentGeometry get alignmentGeometry => alignment.geometry;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: columnWidths,
      defaultVerticalAlignment: defaultVerticalAlignment,
      children: [
        buildHeader(),
        ...buildRows(),
      ],
    );
  }

  TableRow buildHeader() {
    return TableRow(
      children: List.generate(
        columns.length,
        (index) {
          BaseMColumn column = columns[index];
          if (column.columns != null) {
            return buildMergedColumn(column);
          } else {
            return buildSingleColumn(column.header);
          }
        },
      ),
    );
  }

  List<TableRow> buildRows() {
    return List.generate(
      rows.length,
      (index) {
        List<BaseMRow> values = rows[index];
        return TableRow(
          children: List.generate(
            values.length,
            (index) {
              BaseMRow item = values[index];
              bool isMergedColumn = item.inlineRow.length > 1;
              if (isMergedColumn) {
                return buildMutiColumns(item.inlineRow);
              } else {
                return buildAlign(item.inlineRow.first);
              }
            },
          ),
        );
      },
    );
  }

  Widget buildMergedColumn(BaseMColumn column) {
    return Column(
      children: [
        buildSingleColumn(column.header),
        Divider(color: borderColor, height: 1, thickness: 1),
        buildMutiColumns(
          List.generate(column.columns!.length, (index) {
            return buildSingleColumn(column.columns![index]);
          }),
        ),
      ],
    );
  }

  Widget buildMutiColumns(List<Widget> values) {
    return LayoutBuilder(builder: (context, constriant) {
      List<Widget> children = List.generate(values.length, (index) {
        Widget value = values[index];
        double spaceForBorder = (values.length - 1) / values.length;
        return SizedBox(
          width: constriant.maxWidth / values.length - spaceForBorder,
          child: buildAlign(value),
        );
      });
      return IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (Widget child in children.take(children.length - 1)) ...[
              child,
              VerticalDivider(width: 1, color: borderColor, thickness: 1)
            ],
            children.last,
          ],
        ),
      );
    });
  }

  Widget buildSingleColumn(String title) {
    return buildAlign(Text(title));
  }

  Widget buildAlign(Widget child) {
    return Container(
      alignment: alignmentGeometry,
      child: child,
    );
  }

  Map<int, TableColumnWidth> fetchColumnWidths(List<BaseMColumn> columns) {
    Map<int, TableColumnWidth> columnWidths = {};
    double flexPerColumn = 1 / columns.length;
    for (int i = 0; i < columns.length; i++) {
      BaseMColumn column = columns[i];
      if (column.isMergedColumn) {
        columnWidths[i] = FlexColumnWidth(flexPerColumn * column.columns!.length);
      } else {
        columnWidths[i] = FlexColumnWidth(flexPerColumn);
      }
    }
    return columnWidths;
  }
}
