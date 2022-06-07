
<img width="701" alt="image" src="https://user-images.githubusercontent.com/29684683/172324800-9a322d9c-01d6-41d3-90c5-6c3911407c01.png">

```yaml
dependencies:
  # ...
  merge_table:
    git:
      url: https://github.com/juniorise/merge_table.git
      ref: master
```

```dart
MergeTable(
  borderColor: Colors.black,
  alignment: MergeTableAlignment.center,
  columns: [
    MColumn(header: "Pump"),
    MColumn(header: "Product"),
    MColumn(header: "Seal"),
    MMergedColumn(
      header: "Reading",
      columns: ["Before", "Then", "After"],
    ),
    MColumn(header: "Write"),
  ],
  rows: [
    [
      MRow(const Text("1")),
      MRow(const Text("2")),
      MRow(const Text("3")),
      MMergedRows([
        const Text("4"),
        const Text("5"),
        const Text("8"),
      ]),
      MRow(const Text("6")),
    ],
    [
      MRow(const Text("1")),
      MRow(const Text("2")),
      MRow(const Text("3")),
      MMergedRows([
        const Text("4"),
        const Text("5"),
        const Text("8"),
      ]),
      MRow(const Text("6")),
    ],
  ],
)
```
