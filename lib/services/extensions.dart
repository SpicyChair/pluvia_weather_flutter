

extension StringExtension on String {
  String toTitleCase() {
    return this.split(" ").map((str) => str.capitalize()).join(" ");
  }
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}