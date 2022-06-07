part of merge_table;

abstract class BaseMColumn {
  final String header;
  final List<String>? columns;

  bool get isMergedColumn => columns != null;

  BaseMColumn({
    required this.header,
    this.columns,
  });
}

class MColumn extends BaseMColumn {
  MColumn({
    required String header,
  }) : super(header: header, columns: null);
}

class MMergedColumn extends BaseMColumn {
  @override
  List<String> get columns => super.columns!;

  MMergedColumn({
    required super.header,
    required List<String> columns,
  }) : super(columns: columns);
}
