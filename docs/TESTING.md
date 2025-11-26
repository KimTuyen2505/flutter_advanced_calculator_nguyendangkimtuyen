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

<img width="373" height="24" alt="image" src="https://github.com/user-attachments/assets/210c2d1f-84eb-4104-bb80-64ba5215fa3a" />

10 - 4	6

<img width="330" height="25" alt="image" src="https://github.com/user-attachments/assets/48a89be5-3dc0-4499-b375-12bf79813b4d" />

2 + 3 × 4	14

<img width="440" height="22" alt="image" src="https://github.com/user-attachments/assets/eb2e4c4f-2116-4e44-a7fd-d9b4fc8fac47" />

(2 + 3) × 4	20

<img width="451" height="27" alt="image" src="https://github.com/user-attachments/assets/c0106186-b837-40a2-b24f-135c2d0287d5" />

5 ÷ 0	Infinity

<img width="301" height="28" alt="image" src="https://github.com/user-attachments/assets/0ed1c2eb-380c-4932-897b-0914613ffac9" />

sqrt(-4)	NaN

<img width="289" height="27" alt="image" src="https://github.com/user-attachments/assets/c067a27c-d7bb-4d90-99be-f6f725661540" />


🔹 B. Scientific Mode Tests

Expression	Expected

sin(45) + cos(45)	≈ 1.414

<img width="442" height="25" alt="image" src="https://github.com/user-attachments/assets/aba93575-9cda-4ab8-a821-84526b8b8c93" />

sqrt(16)	4

<img width="305" height="23" alt="image" src="https://github.com/user-attachments/assets/a0bcae71-5116-4679-8cd3-39e25e4dd526" />

sin(30)	≈ 0.5

<img width="306" height="26" alt="image" src="https://github.com/user-attachments/assets/29f3960e-3be0-4e92-a13c-31aed74b4220" />


2 × π × √9	≈ 18.85

<img width="432" height="20" alt="image" src="https://github.com/user-attachments/assets/91765feb-56b5-4c7b-b61d-d8abff915754" />

🔹 C. Memory Function Tests

Test Case	Result

5 M+ → 3 M+ → MR	8

<img width="400" height="23" alt="image" src="https://github.com/user-attachments/assets/5d62839f-0484-46a2-9da1-6a5a5d8a7bf3" />

🔹 D. Chained Expression Evaluation

5 + 3  → 8  

+2     → 10  

+1     → 11  

<img width="422" height="25" alt="image" src="https://github.com/user-attachments/assets/35c5a133-424f-445c-89cd-b2ed2b5b4bbd" />


✔ Final output: 11

🔹 E. Parentheses / Nested Logic

((2+3) × (4-1)) ÷ 5

<img width="430" height="26" alt="image" src="https://github.com/user-attachments/assets/2c1d8270-ffc0-491a-b7de-797bb2583afd" />

✔ Output: 3

🔹 F. Programmer Mode (Bitwise)

Test	Output

0x0F OR 0xF0	0xFF

<img width="551" height="23" alt="image" src="https://github.com/user-attachments/assets/7dff1bef-f05d-4b3d-a151-4fc659470650" />

0xAA XOR 0x55	0xFF

<img width="356" height="21" alt="image" src="https://github.com/user-attachments/assets/57a73428-0859-4cea-aed0-262744131325" />

NOT 0x00	0xFFFFFFFF
<img width="349" height="25" alt="image" src="https://github.com/user-attachments/assets/ed9ac4ad-77c1-4419-83eb-f5a197f6688d" />

0x03 << 1	0x06

<img width="322" height="21" alt="image" src="https://github.com/user-attachments/assets/19b130b0-a34e-4100-bb91-a49f111f80a1" />

0x08 >> 1	0x04

<img width="345" height="25" alt="image" src="https://github.com/user-attachments/assets/610c3179-9124-4ad5-92e9-46a686a18273" />

HEX FF → DEC	255

<img width="339" height="26" alt="image" src="https://github.com/user-attachments/assets/4edfcad7-9dda-494a-b5f8-398c2ccf5b76" />


HEX A5 → BIN	10100101

<img width="374" height="23" alt="image" src="https://github.com/user-attachments/assets/e5089706-bc58-4b39-b00e-3a0ad2abd6c6" />


DEC 64 → HEX	40

<img width="355" height="23" alt="image" src="https://github.com/user-attachments/assets/a3011c5f-08f8-4d80-9548-2f6dc43aea9b" />

▶️ Running the Tests

Run all:

flutter test
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
