part of merge_table;

enum MergeTableAlignment {
  centerLeft,
  centerRight,
  bottomLeft,
  bottomRight,
  topLeft,
  topRight,
  center,
}

extension MergeTableAlignmentExtension on MergeTableAlignment {
  Alignment get geometry {
    switch (this) {
      case MergeTableAlignment.centerLeft:
        return Alignment.centerLeft;
      case MergeTableAlignment.centerRight:
        return Alignment.centerRight;
      case MergeTableAlignment.bottomLeft:
        return Alignment.bottomLeft;
      case MergeTableAlignment.bottomRight:
        return Alignment.bottomRight;
      case MergeTableAlignment.topLeft:
        return Alignment.topLeft;
      case MergeTableAlignment.topRight:
        return Alignment.topRight;
      case MergeTableAlignment.center:
        return Alignment.center;
    }
  }

  TableCellVerticalAlignment get tableAlignment {
    switch (this) {
      case MergeTableAlignment.centerLeft:
      case MergeTableAlignment.centerRight:
      case MergeTableAlignment.center:
        return TableCellVerticalAlignment.middle;

      case MergeTableAlignment.bottomLeft:
      case MergeTableAlignment.bottomRight:
        return TableCellVerticalAlignment.bottom;

      case MergeTableAlignment.topRight:
      case MergeTableAlignment.topLeft:
        return TableCellVerticalAlignment.top;
    }
  }
}
