# Task Management App
## Architecture Overview

### 1. Architecture Implemented

The architecture of the Task Management App is based on the **Model-View-ViewModel (MVVM)** pattern,
utilizing **Riverpod** for state management. The key components of the architecture are:

- **Models**: The `Task` model represents the data structure for tasks, including fields
  for `id`, `title`, `description`, `isDone`, and `lastUpdated`. This model is annotated for Hive
  storage, allowing for local persistence and for firestore to map through the varriables.

- **Repositories**: The `TaskRepository` class acts as an intermediary between the data source (Hive
  and Firestore) and the application logic. It handles CRUD operations and data synchronization.

- **Providers**: The `StateNotifierProvider` is used to manage the state of the task list.
  The `TaskListNotifier` class extends `StateNotifier` and contains methods for adding, updating,
  deleting, and completing tasks. It notifies listeners of any state changes.

- **Views**: The UI components are built using Flutter widgets. The main screen displays the list of
  tasks, and each task can be interacted with through a `TaskItem` widget.

### Rationale Behind Choices

- **MVVM Pattern**: This pattern separates the UI from the business logic, making the codebase more
  maintainable and testable. It allows for easier unit testing of the business logic without
  involving the UI.

- **Riverpod**: Chosen for state management due to its simplicity and flexibility. It provides a
  robust way to manage state and dependencies, making it easier to test and maintain.

- **Hive for Local Storage**: Hive is a lightweight and fast key-value database that is well-suited
  for Flutter applications. It allows for efficient offline data persistence.

- **Firebase for Cloud Storage**: Firebase Firestore provides a scalable and real-time database
  solution, enabling seamless synchronization of tasks across devices.

## Challenges Encountered

### 1. Data Synchronization

**Challenge**: Ensuring that tasks created or modified while offline are correctly synchronized with
Firestore when the app goes online.

**Resolution**: Implemented a mechanism in the `TaskListNotifier` to track unsynced changes. When
the app toggles to online mode, it triggers a synchronization process that updates Firestore with
any local changes.

### 2. State Management Complexity

**Challenge**: Managing the state of tasks and ensuring that the UI reflects the current state
accurately.

**Resolution**: By using `StateNotifier` and `StateNotifierProvider`, I was able to encapsulate
the state management logic within the `TaskListNotifier`. This allowed for clear separation of
concerns and made it easier to notify the UI of changes.

### 3. Handling Conflicts

**Challenge**: Resolving conflicts when multiple devices modify the same task simultaneously.

**Resolution**: Implemented a simple conflict resolution strategy that prioritizes the most recent
update based on the `lastUpdated` timestamp. This ensures that the latest changes are preserved.

## Creative Features and Enhancements

### 2. User Authentication

Integrated Firebase Authentication to allow users to sign up and log in using email and password.
This feature ensures that each user's tasks are stored securely and can be accessed from multiple
devices.
## Suggested Improvements

### 3. Offline Notifications

This feature can help the User to not overlook tasks that are due when the app is offline. The app
### 4. Task Filtering
Allow filtering such that the user can measure their productivity

### 5. Dark Mode Support
implement dark mode to  enhances the user experience, especially in low-light environments.

## Overview

This is a Flutter-based Task Management App designed to help users manage their tasks efficiently.
The app supports offline functionality, data persistence using Hive, and real-time synchronization
with Firebase Firestore.

## Screen Recording

Screen
Recording [Link](https://drive.google.com/file/d/1e6cBBrHEKy_sWXhqon7Q6lpuzGMMNH9h/view?usp=drive_link)

## Features

- Create, update, and delete tasks.
- Offline data persistence using Hive.
- Real-time synchronization with Firebase Firestore.
- User authentication using email and password.
- Task completion tracking with timestamps.

## Setup Instructions

Follow these steps to set up the project locally:

### Prerequisites

- Flutter SDK installed on your machine.
- An IDE such as Visual Studio Code or Android Studio.
- Firebase project set up with Firestore and Authentication enabled.

### Clone the Repository

```bash
git clone https://github.com/frank7841/task_management_app.git
cd task_management_app

```

### install Dependencies

```bash
flutter pub get
``` 

### Generate Hive Adapter Files

```bash
flutter packages pub run build_runner build
```

### Configure Firebase

1. **Android**
    - Download the `google-services.json` file from the Firebase Console.
    - Place the file in the `android/app` directory.
2. **iOS**
    - Download the `GoogleService-Info.plist` file from the Firebase Console.
    - Place the file in the `ios/Runner` directory. TO:DO

### Run APP

 ```bash    
    flutter run
    ``` 
