part of merge_table;

class MergeTable extends StatelessWidget {
  MergeTable({
    Key? key,
    required this.rows,
    required this.columns,
    required this.borderColor,
    this.alignment = MergeTableAlignment.center,
  }) : super(key: key) {
    assert(columns.isNotEmpty);
    assert(rows.isNotEmpty);
    for (List<BaseMRow> row in rows) {
      assert(row.length == columns.length);
    }

    // load late fields
    loadColumnWidths(columns);
    loadAlignment();
  }

  final Color borderColor;
  final List<BaseMColumn> columns;
  final List<List<BaseMRow>> rows;
  final MergeTableAlignment alignment;
  late final Map<int, TableColumnWidth> columnWidths;
  late final TableCellVerticalAlignment defaultVerticalAlignment;
  late final AlignmentGeometry alignmentGeometry;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: columnWidths,
      defaultVerticalAlignment: defaultVerticalAlignment,
      children: [
        TableRow(
          children: List.generate(
            columns.length,
            (index) {
              BaseMColumn column = columns[index];
              if (column.columns != null) {
                return buildMergedColumn(column);
              } else {
                return buildColumn(column.header);
              }
            },
          ),
        ),
        ...List.generate(
          rows.length,
          (index) {
            final row = rows[index];
            return TableRow(
              children: List.generate(
                row.length,
                (index) {
                  final customRow = row[index];
                  if (customRow.inlineRow.length > 1) {
                    return buildColumns(customRow.inlineRow);
                  } else {
                    return buildAlign(customRow.inlineRow.first);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildMergedColumn(BaseMColumn column) {
    return Column(
      children: [
        buildColumn(column.header),
        Divider(color: borderColor, height: 1, thickness: 1),
        buildColumns(
          List.generate(column.columns!.length, (index) {
            return buildColumn(column.columns![index]);
          }),
        ),
      ],
    );
  }

  Widget buildColumns(List<Widget> values) {
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

  Widget buildColumn(String title) {
    return buildAlign(Text(title));
  }

  Widget buildAlign(Widget child) {
    return Container(
      alignment: alignmentGeometry,
      child: child,
    );
  }

  void loadColumnWidths(List<BaseMColumn> columns) {
    columnWidths = {};
    double flexPerColumn = 1 / columns.length;
    for (int i = 0; i < columns.length; i++) {
      BaseMColumn column = columns[i];
      if (column.isMergedColumn) {
        columnWidths[i] = FlexColumnWidth(flexPerColumn * column.columns!.length);
      } else {
        columnWidths[i] = FlexColumnWidth(flexPerColumn);
      }
    }
  }

  void loadAlignment() {
    switch (alignment) {
      case MergeTableAlignment.centerLeft:
      case MergeTableAlignment.centerRight:
      case MergeTableAlignment.center:
        defaultVerticalAlignment = TableCellVerticalAlignment.middle;
        break;
      case MergeTableAlignment.bottomLeft:
      case MergeTableAlignment.bottomRight:
        defaultVerticalAlignment = TableCellVerticalAlignment.bottom;
        break;
      case MergeTableAlignment.topRight:
      case MergeTableAlignment.topLeft:
        defaultVerticalAlignment = TableCellVerticalAlignment.top;
        break;
    }

    switch (alignment) {
      case MergeTableAlignment.centerLeft:
        alignmentGeometry = Alignment.centerLeft;
        break;
      case MergeTableAlignment.centerRight:
        alignmentGeometry = Alignment.centerRight;
        break;
      case MergeTableAlignment.bottomLeft:
        alignmentGeometry = Alignment.bottomLeft;
        break;
      case MergeTableAlignment.bottomRight:
        alignmentGeometry = Alignment.bottomRight;
        break;
      case MergeTableAlignment.topLeft:
        alignmentGeometry = Alignment.topLeft;
        break;
      case MergeTableAlignment.topRight:
        alignmentGeometry = Alignment.topRight;
        break;
      case MergeTableAlignment.center:
        alignmentGeometry = Alignment.center;
        break;
    }
  }
}
