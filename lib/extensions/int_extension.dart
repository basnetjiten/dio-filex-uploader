// Extension for response status check
extension StatusCode on int {
  bool get isSuccessful => this >= 200 && this < 300;
}