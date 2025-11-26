class CalculatorLogic {
  // n!
  static int factorial(int n) {
    if (n < 0) throw ArgumentError('Negative factorial');
    if (n == 0) return 1;
    var result = 1;
    for (var i = 1; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  // Bitwise
  static int and(int a, int b) => a & b;
  static int or(int a, int b) => a | b;
  static int xor(int a, int b) => a ^ b;
  static int not(int a) {
    const mask = 0xFFFFFFFF;
    return (~a) & mask;
  }
// SHIFT OPERATIONS
static int shiftLeft(int value, int shift) {
  return value << shift;
}
static int shiftRight(int value, int shift) {
  return value >> shift;
}
  static int shl(int a, int n) => a << n;
  static int shr(int a, int n) => a >> n;
}
