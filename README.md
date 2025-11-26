# 📱 Advanced Calculator – Flutter Project
A fully featured **multi-mode calculator** built with **Flutter**, including  
**Basic**, **Scientific**, and **Programmer** modes, a persistent **History system**,  
a configurable **Settings screen**, **Graph plotting**, and **CSV/PDF export**.

This project is an extended implementation of **Lab 3 – Advanced Calculator**.
---
# 📌 Table of Contents

- [✨ Features Overview](#-features-overview)
- [🧮 Calculator Modes](#-calculator-modes)
- [📚 History System](#-history-system)
- [📈 Graph Plotting](#-graph-plotting)
- [📤 Export Functions](#-export-functions)
- [⚙ Settings](#-settings)
- [✋ Gestures](#-gestures)
- [🎨 Animations](#-animations)
- [🧪 Unit Tests](#-unit-tests)
- [🚀 Getting Started](#-getting-started)
- [📂 Project Structure](#-project-structure)
- [📸 Screenshots](#-screenshots)
- [🚧 Limitations & Future Improvements](#-limitations--future-improvements)

---

# ✨ Features Overview

| Category | Features |
|----------|----------|
| **Basic** | +, –, ×, ÷, parentheses, PEMDAS |
| **Scientific** | sin, cos, tan, sqrt, log, π, angle mode (DEG/RAD) |
| **Programmer** | AND, OR, XOR, NOT, shifts, HEX/DEC/BIN conversion |
| **Memory** | M+, MR, MC with persistence |
| **History** | Auto-save, swipe-up to open, tap to reuse |
| **Graph Plotting** | Plot f(x) using FLChart, axes, auto-scaling |
| **Export** | Export history to CSV and PDF |
| **Settings** | Theme, precision, angle, history size, clear all |
| **Unit Tests** | Full coverage for logic & programmer mode |

---

# 🧮 Calculator Modes

## 1️⃣ Basic Mode
- Standard operations: `+`, `-`, `×`, `÷`
- Correct order of operations (PEMDAS)
- Supports parentheses
- Multi-line display for long expressions

---

## 2️⃣ Scientific Mode
Includes advanced math functions:

- `sin(x)`, `cos(x)`, `tan(x)`
- `sqrt(x)`
- `π`
- `log(x)`, `ln(x)`
- Supports **Degrees** and **Radians**
- Complex expressions:
  - `(5 + 3) × 2`
  - `sin(45°) + cos(45°)`
  - `2 × π × sqrt(9)`

Angle mode is saved and applied automatically.

---

## 3️⃣ Programmer Mode
Supports low-level operations:

### 🟣 Bitwise Operations
- `AND`, `OR`, `XOR`, `NOT`
- `<<` (Shift Left)
- `>>` (Shift Right)

### 🔵 Number Bases
- HEX ↔ DEC ↔ BIN conversion  
Examples:
- `HEX FF → DEC 255`
- `HEX A5 → BIN 10100101`
- `DEC 64 → HEX 40`

### 🔥 Example Scenarios (also in unit tests)
- `0xFF AND 0x0F = 0x0F`
- `0x0F OR 0xF0 = 0xFF`
- `0xAA XOR 0x55 = 0xFF`
- `NOT 0x00 = FFFFFFFF`

---

# 📚 History System

- Saves **expression + result + timestamp**
- Keeps up to **25 / 50 / 100 entries**
- **Swipe up** on display → open history
- Tap an entry → reuse result
- Persists across app restarts (SharedPreferences)
- **Export PDF / CSV** button inside HistoryScreen

---

# 📈 Graph Plotting

The `GraphScreen` allows plotting any function of `x`, including:

- `sin(x)`
- `x^2`
- `x * sin(x)`
- `x^3 - 3x`
- `cos(2x)`
- `sqrt(abs(x))`

Features:
- Auto-scaling Y range
- X range: `-10` → `10`
- Clean axes (OX / OY)
- Smooth curves with FLChart
- Real-time re-plotting

---

# 📤 Export Functions

### 📄 PDF Export
- Generates professional table containing:
  - Expression
  - Result
  - Timestamp
- Supports printing / saving / sharing

### 📊 CSV Export
- Exports to `history_export.csv`
- Can be opened in Excel / Google Sheets
- Format:
Expression,Result,Timestamp
5+3,8,2024-11-26 08:00:00


---

# ⚙ Settings

The Settings screen includes:

| Setting | Description |
|--------|-------------|
| **Theme Mode** | Light / Dark / System |
| **Decimal Precision** | 2 → 10 decimal places |
| **Angle Mode** | Degrees / Radians |
| **History Size** | 25 / 50 / 100 entries |
| **Clear All History** | With confirmation dialog |

All settings are saved persistently.

---

# ✋ Gestures

| Gesture | Action |
|---------|--------|
| **Swipe Up** | Open calculation history |
| **(Optional)** Swipe Right | Delete last character |
| **(Optional)** Long Press C | Clear all history |
| **(Optional)** Pinch | Adjust display font size |

(Swipe up is implemented; others can be added.)

---

# 🎨 Animations

The UI supports:

- Button press animation (scale)
- Fade-in result animation
- Shake animation for errors
- Smooth theme changes (if enabled)

---

# 🧪 Unit Tests

Full test suite includes:

### ✔ Basic operations
`5 + 3 = 8`  
`10 - 4 = 6`
### ✔ Order of operations
`2 + 3×4 = 14`  
`(2 + 3)×4 = 20`
### ✔ Scientific
`sin(45°) + cos(45°)`  
`sqrt(16) = 4`  
`sin(30°) = 0.5`
### ✔ Memory
`5 M+ 3 M+ MR = 8`
### ✔ Complex expressions
`((2+3) × (4-1)) ÷ 5 = 3`
### ✔ Mixed scientific
`2 × π × sqrt(9) ≈ 18.85`
### ✔ Programmer Mode
AND, OR, XOR, NOT, SHIFT, base conversions
Run tests:

flutter test


---

# 🚀 Getting Started

### 1. Install dependencies
```bash
flutter pub get

2. Run the app
flutter run

3. Run unit tests
flutter test

📂 Project Structure
lib/
 ├── models/                 # Data models
 ├── providers/              # State management (Provider)
 ├── services/               # Storage & theme services
 ├── utils/                  # Parser & calculation logic
 ├── screens/                # Main screens
 ├── widgets/                # Reusable UI components
 🚧 Limitations & Future Improvements

Add multi-gesture support (pinch, swipe-right delete)
Improve keypad layout for scientific mode
Add sound / haptic toggles (if needed)
More advanced graph features: zoom, pan, multiple functions
Add internationalization (i18n)