# Task Manager - Isar CRUD Application

## Overview
This repository contains a Flutter-based mobile application developed for the **Section 4: Form & CRUD** course. The project demonstrates a practical implementation of local data persistence using the **Isar Database**, organized within a clean and maintainable **MVC-like architecture**.

The primary goal of this task was to create a robust task management system that ensures data integrity and provides a smooth user experience across multiple platforms, including **Web (Chrome)** and native mobile environments.

## Core Features
*   **Reactive UI**: Leverages Isar Streams to automatically synchronize and reflect database changes in the user interface.
*   **Complete CRUD Functionality**: Users can create, read, update (including toggling task status), and delete records effortlessly.
*   **Modern Aesthetics**: Designed using Material 3 principles with a professional "Teal" theme for a polished look and feel.
*   **Cross-Platform Optimization**: Specifically configured to maintain stability when running in browser environments.

## Architecture (MVC Logic)
To maintain a high standard of code quality and separation of concerns, the project is structured follows:
*   **Model** (`lib/models/`): Definitions for the `Task` entity, using Isar's annotation-based collection system.
*   **Controller** (`lib/controllers/`): The bridge between the database and the UI, handling all business logic and data manipulation.
*   **View & Widgets** (`lib/views/`): The presentation layer, modularized into reusable screens and components like `TaskTile`.
*   **Service** (`lib/services/`): A dedicated singleton for database initialization and lifecycle management.

## Getting Started

### Prerequisites
- **Flutter SDK**: v3.41.6 (Stable)
- **FVM** (Flutter Version Management) is recommended for consistency.

### Installation & Execution
1.  **Initialize Packages**:
    ```bash
    fvm flutter pub get
    ```
2.  **Generate Schema Code**:
    Isar requires a generation step to prepare the database schema:
    ```bash
    fvm dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Launch the Application**:
    To run on **Chrome**:
    ```bash
    fvm flutter run -d chrome
    ```

## Deployment Notes
The Web version of this application includes a tailored adjustment in the generated schema to ensure full compatibility with the browser's JavaScript environment. This ensures that the application remains stable and functional despite the inherent precision differences of integers on the web.

---
**re1c**  
*Pemrograman Perangkat Bergerak (E)*  
*Institut Teknologi Sepuluh Nopember (ITS)*
