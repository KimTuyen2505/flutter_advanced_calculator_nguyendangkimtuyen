class ProgrammerLogic {
  // hex "0xFF" to int
  static int hexToInt(String hex) {
    return int.parse(hex.replaceAll("0x", ""), radix: 16);
  }

  // int to hex "0x0F"
  static String intToHex(int value) {
    return "0x${value.toRadixString(16).toUpperCase().padLeft(2, '0')}";
  }

  //AND
  static String andOperation(String a, String b) {
    int x = hexToInt(a);
    int y = hexToInt(b);
    int result = x & y;
    return intToHex(result);
  }
}
