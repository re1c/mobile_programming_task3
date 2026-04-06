# Task Manager - Isar CRUD Application

## Overview
This repository contains a Flutter mobile application developed for the **Section 4: Form & CRUD** course. The project explores local data persistence and reactive UI using the **Isar Database**, organized around a clean **MVC (Model-View-Controller)** architecture.

A key highlight of this project is its **Resilient Persistence Strategy**, which ensures the application remains functional across multiple environments, including Android, iOS, and Web (Chrome).

## Key Features
*   **Reactive Task Management**: Real-time synchronization between the database and the user interface using Isar Streams and broadcast streams.
*   **Dual-Layer Storage Architecture**: 
    *   **Mobile**: Utilizes high-performance **Isar NoSQL** for permanent, on-device storage.
    *   **Web (Chrome)**: Implements a reactive **In-Memory fallback** to ensure a smooth, crash-free demonstration experience without the limitations of the current Isar web-stubs.
*   **Clean MVC Structure**: Strict separation of data models, business logic, and UI components to ensure code maintainability and scalability.
*   **Material 3 UI**: A modern, professional interface with a focus on ease of use and visual clarity.

## Project Structure
*   **Model** (`lib/models/`): Defines the `Task` entity with necessary annotations for database mapping.
*   **Controller** (`lib/controllers/`): The core logic layer responsible for managing task operations across both persistent and in-memory stores.
*   **View & Widgets** (`lib/views/`): Responsive presentation layer built with reusable components like `TaskTile`.
*   **Service** (`lib/services/`): Handles environment detection and centralized database lifecycle management.

## Getting Started

### Prerequisites
- Flutter SDK (v3.41.6)
- **FVM (Flutter Version Management)** is recommended to ensure environment consistency.

### Installation & Execution
1.  **Initialize Packages**:
    ```bash
    fvm flutter pub get
    ```
2.  **Generate Database Schema**:
    ```bash
    fvm dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Launch the Application**:
    - **Chrome**: `fvm flutter run -d chrome`
    - **Mobile**: `fvm flutter run -d <device_id>`

## Persistence Strategy Note
Due to the architectural limitations of the current Isar 3.x library on the Web platform, this project implements a professional fallback mechanism. While Mobile devices benefit from full local persistence, the Web version maintains task state in memory. This ensures that the application remains 100% stable and fully functional for demonstration purposes on Chrome, allowing for comprehensive testing of all CRUD features.

---
**re1c**  
*Pemrograman Perangkat Bergerak (E)*  
*Institut Teknologi Sepuluh Nopember (ITS)*
