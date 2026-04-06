# Task Master - CRUD with Isar DB

## Introduction
This project is a Flutter application built to fulfill the **Section 4: Form & CRUD** assignment for the **Mobile Programming** course. It demonstrates a practical implementation of local data persistence using the **Isar Database**, structured with a clean, **MVC-like architecture** to ensure the code remains organized, readable, and easy to maintain.

Unlike traditional SQLite implementations, this project leverages **Isar**, a fast and modern NoSQL database that provides a great developer experience and high performance for local storage in Flutter.

## Core Features
- **Real-time Synchronization**: Uses Isar Streams to automatically update the UI when the database changes.
- **Full CRUD Operations**:
  - **Create**: Add tasks with dedicated titles and descriptions.
  - **Read**: View your list of tasks, sorted by the latest creation date.
  - **Update**: Modify existing tasks or mark them as completed/uncompleted.
  - **Delete**: Cleanly remove tasks from the local storage.
- **Multi-Platform Support**: Optimized for **Chrome (Web)**, as well as Android and iOS.

## Project Structure (MVC)
To satisfy the course requirements, the code is separated into several layers:

- **`lib/models/`**: Contains the `Task` entity definition with Isar annotations.
- **`lib/views/`**: Contains the main screens (`HomeView`) and modular components like the task entry form.
- **`lib/controllers/`**: Handles the communication between the UI and the database, managing the CRUD logic.
- **`lib/services/`**: Provides a singleton database service for centralized Isar management and initialization across different platforms.

## Getting Started

### Prerequisites
- **FVM (Flutter Version Management)** is used for this project.
- **Flutter SDK**: v3.41.2 (channel stable)

### Installation
1. **Install dependencies**:
   ```bash
   fvm flutter pub get
   ```
2. **Generate Database Code**:
   Isar requires generated code for its queries. Run the build runner to prepare the project:
   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```
3. **Run the Application**:
   To launch in **Chrome**:
   ```bash
   fvm flutter run -d chrome
   ```

## Acknowledgments & Best Practices
- **Clean Code**: Follows Dart's best practices and linting rules.
- **State Management**: Uses built-in `StreamBuilder` and `StatefulWidget` for a lightweight yet efficient state management approach.
- **Modern UI**: Designed with Material 3 styling and a "Teal" theme for a premium look and feel.

---
**Developed by re1c**  
*Pemrograman Perangkat Bergerak (E) - April 2026*
