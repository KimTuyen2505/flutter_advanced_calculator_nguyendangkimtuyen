<div align="center">
🌈 <span style="background: linear-gradient(90deg, #ff8a00, #e52e71); -webkit-background-clip: text; color: transparent;">UNIT TESTING — Calculator App</span>
Reliable • Maintainable • Fully Tested
<img src="https://img.shields.io/badge/UNIT%20TESTS-PASSED-4CAF50?style=for-the-badge"> <img src="https://img.shields.io/badge/COVERAGE-~85%25-2196F3?style=for-the-badge"> <img src="https://img.shields.io/badge/FLUTTER-TEST-02569B?style=for-the-badge"> <img src="https://img.shields.io/badge/DART-3.x-0175C2?style=for-the-badge">
🔍 A full test suite ensuring correctness across arithmetic, scientific, programmer mode & storage logic.
</div>
📘 Overview
This document provides a clean summary of all automated unit tests implemented for the Calculator App.
Focus areas:
Expression evaluation
Operator precedence
Scientific functions
Memory operations
Nested parentheses
Programmer mode (bitwise)
History & storage logic
🌐 Mocking Setup
🧩 MockStorage

A lightweight, in-memory storage used to replace database/local storage during testing.
Ensures tests run fast and deterministically.

🗂️ MockHistory

A simplified HistoryProvider using MockStorage to record calculation history.

🧪 Test Categories
🔹 A. Basic Arithmetic Tests
Expression	Expected
5 + 3	8
10 - 4	6
2 + 3 × 4	14
(2 + 3) × 4	20
5 ÷ 0	Infinity
sqrt(-4)	NaN
🔹 B. Scientific Mode Tests
Expression	Expected
sin(45) + cos(45)	≈ 1.414
sqrt(16)	4
sin(30)	≈ 0.5
2 × π × √9	≈ 18.85
🔹 C. Memory Function Tests
Test Case	Result
5 M+ → 3 M+ → MR	8
🔹 D. Chained Expression Evaluation
5 + 3  → 8  
+2     → 10  
+1     → 11  


✔ Final output: 11

🔹 E. Parentheses / Nested Logic
((2+3) × (4-1)) ÷ 5


✔ Output: 3

🔹 F. Programmer Mode (Bitwise)
Test	Output
0x0F OR 0xF0	0xFF
0xAA XOR 0x55	0xFF
NOT 0x00	0xFFFFFFFF
0x03 << 1	0x06
0x08 >> 1	0x04
HEX FF → DEC	255
HEX A5 → BIN	10100101
DEC 64 → HEX	40
▶️ Running the Tests
Run all:
flutter test

Run one file:
flutter test test/calculator_test.dart

🏁 Summary

⭐ All unit tests passed successfully
🧠 Expression parsing is stable
🔬 Scientific & programmer modes work as expected
💾 Memory & history behave correctly
🧱 Safe for refactoring & adding new features

<div align="center">
✨ Made with care for reliability
<span style="background: linear-gradient(90deg, #6a11cb, #2575fc); -webkit-background-clip: text; color: transparent;">Calculator App — Fully Tested & Ready</span>
</div>