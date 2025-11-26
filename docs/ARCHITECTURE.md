
---

# ✅ FILE 2 — ARCHITECTURE.md (English, Beautiful, Professional)

Copy vào `/docs/ARCHITECTURE.md` hoặc root folder:

```md
# 🏛 ARCHITECTURE – Advanced Calculator (Flutter)

This document describes the internal architecture, folder structure, data flow,  
and the responsibilities of each component in the **Advanced Calculator** project.

---

# 📌 Table of Contents
- [1. Overview](#1-overview)
- [2. Folder Structure](#2-folder-structure)
- [3. Component Responsibilities](#3-component-responsibilities)
- [4. Data Flow](#4-data-flow)
- [5. Providers (State Management)](#5-providers)
- [6. Calculation Pipeline](#6-calculation-pipeline)
- [7. History Architecture](#7-history-architecture)
- [8. Settings Architecture](#8-settings-architecture)
- [9. Storage Layer](#9-storage-layer)
- [10. UI Architecture](#10-ui-architecture)
- [11. Testing Architecture](#11-testing-architecture)

---

# 1. Overview

The project follows a clean, layered architecture:

UI (Screens & Widgets)
↓
State Management (Provider)
↓
Business Logic (Parser + Calculator Logic)
↓
Data Layer (StorageService)


Each layer is independent, testable, and easy to extend.

---

# 2. Folder Structure
lib/
├── models/
│ ├── calculator_settings.dart
│ ├── calculation_history.dart
│
├── providers/
│ ├── calculator_provider.dart
│ ├── history_provider.dart
│ ├── settings_provider.dart
│
├── services/
│ ├── storage_service.dart
│ ├── theme_service.dart (optional)
│
├── utils/
│ ├── expression_parser.dart
│ ├── calculator_logic.dart
│ ├── programmer_logic.dart
│
├── screens/
│ ├── calculator_screen.dart
│ ├── history_screen.dart
│ ├── settings_screen.dart
│ ├── graph_screen.dart
│
├── widgets/
│ ├── display_area.dart
│ ├── button_grid.dart
│ ├── mode_selector.dart


---

# 3. Component Responsibilities

### 📌 Models
| File | Purpose |
|------|---------|
| `calculation_history.dart` | Represents a single calculation record |
| `calculator_settings.dart` | Stores user preferences (theme, angle, precision, history size) |

---

# 4. Data Flow

User Input
↓
CalculatorProvider
↓
ExpressionParser
↓
CalculatorLogic
↓
Result
↓
HistoryProvider → save to storage

---

# 5. Providers

### 🔵 calculator_provider.dart
- Manages:
  - Expression
  - Result
  - Current mode (basic/scientific/programmer)
- Calls:
  - ExpressionParser
  - CalculatorLogic
- Manages memory functions: M+, MR, MC
- Pushes results to HistoryProvider

### 🟣 history_provider.dart
- Stores list of calculations
- Ensures max size (25/50/100)
- Adds/removes entries
- Saves to StorageService

### 🟢 settings_provider.dart
- Stores:
  - Theme mode
  - Precision
  - Angle (DEG/RAD)
  - History limit
- Saves to StorageService

---

# 6. Calculation Pipeline

String input → ExpressionParser → Parsed Tree → CalculatorLogic → Result

### 🔹 ExpressionParser
- Tokenizes operators and operands
- Handles:
  - Parentheses
  - PEMDAS
  - Functions: sin, cos, sqrt, log
  - Implicit multiplication (e.g., 2π)
### 🔹 CalculatorLogic
- Evaluates parsed expression
- Applies:
  - Angle mode conversion (DEG/RAD)
  - Floating point precision
  - Safe operations (divide by zero handling)
### 🔹 ProgrammerLogic
- Bitwise operations
- Base conversions (HEX / DEC / BIN)
---
# 7. History Architecture

CalculatorProvider → addEntry()
HistoryProvider → save to storage
HistoryScreen → display + export


Supports:
- Reverse chronological order
- Tap-to-insert
- Clear with confirmation
- Export CSV + PDF

---

# 8. Settings Architecture

Settings are saved persistently:

| Setting | Saved as |
|---------|----------|
| Theme Mode | `theme_mode` |
| Angle Mode | `angle_mode` |
| Decimal Precision | `decimal_precision` |
| History Size | `history_size` |
| Memory Value | `memory_value` |

---

# 9. Storage Layer

`storage_service.dart` wraps **SharedPreferences**:

- `saveHistory()` / `readHistory()`
- `saveSettings()`
- `saveMemory()`
- `saveMode()`
- `saveAngle()`

This abstraction enables easy replacement for:
- SQLite
- Hive
- Cloud sync (future upgrade)

---

# 10. UI Architecture

### calculator_screen.dart
- AppBar: History, Settings, Graph buttons
- DisplayArea: Shows expression + result
- ButtonGrid: Numeric, operators, scientific & programmer keys
- ModeSelector: Switch between modes

### history_screen.dart
- ListView of previous calculations
- Export to CSV/PDF
- Delete all entries

### settings_screen.dart
- Sliders, toggles, and selectors for app preferences

### graph_screen.dart
- FLChart line plot
- Handles input field + dynamic graph rendering

---

# 11. Testing Architecture

Test coverage includes:

- Basic arithmetic
- Operator precedence
- Scientific functions
- Memory operations
- Complex expressions
- Bitwise logic
- Base conversion
- Edge cases (Infinity, NaN)

Extremely easy to extend due to modular architecture.

---

# 🏁 Conclusion

This architecture ensures:

- **High modularity**
- **Easy testing**
- **Clean separation of concerns**
- **Scalable project structure**
- **Robust state management**