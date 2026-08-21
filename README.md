# UIKitPractice

An iOS Todo app built with UIKit (Storyboard), Combine, and Core Data following the MVVM pattern.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Data Model](#data-model)
- [How It Works](#how-it-works)
- [Key Components](#key-components)
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [License](#license)

## Features

### Authentication
- Login with email and password
- Create new account with name, email, and password
- Credentials stored securely in Core Data
- Automatic session persistence across app launches

### Todo Management
- Create todos with a description and category
- Edit existing todos via swipe action or tap
- Delete todos via swipe action or table view editing
- Toggle todo status between **Pending** and **Completed**
- Pull-to-refresh to reload the todo list

### Categories
- Filter todos by category using the segmented control: **All**, **Work**, **Personal**, **Shopping**
- Each category is color-coded (Blue for Work, Purple for Personal, Orange for Shopping)
- Category badge displayed on each todo cell

### Profile
- View logged-in user's name and avatar
- Logout button to end the session

### UI/UX
- Dark mode support with themed colors (background, accent, surface)
- Custom programmatic table view cell with accent bar, title, category badge, and status label
- Swipe actions: leading swipe for Edit, trailing swipe for Complete/Pending toggle and Delete
- Modal sheet presentation for Add/Edit Todo with grabber and rounded corners
- Cross-dissolve animated transitions between Auth and Main flows

## Screenshots
<img width="421" height="864" alt="Screenshot 2026-08-21 at 3 32 54 PM" src="https://github.com/user-attachments/assets/3cb8bebe-8bc3-4632-9223-e6cf1e106721" />
<img width="416" height="861" alt="Screenshot 2026-08-21 at 3 34 20 PM" src="https://github.com/user-attachments/assets/6f9f05b1-86fe-4a23-929c-6a2fc87d3ea5" />


## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern with **Combine** for reactive bindings and **Core Data** for local persistence.

```
View (Storyboard + UIViewController)
    |
    v
ViewModel (ObservableObject with @Published properties)
    |
    v
Model (Core Data entities: Todo, Users)
```

- **Views** (`AuthController`, `HomeController`, `AddTodoController`, `ProfileController`) handle UI rendering and user interactions.
- **ViewModels** (`AuthViewModel`, `DashboardViewModel`) encapsulate business logic and expose `@Published` properties for reactive UI updates.
- **Models** are Core Data entities (`Todo`, `Users`) managed through `CoreDataManager`.

### Reactive Bindings with Combine

- `AppState.$isLoggedIn` is observed to persist login state to `UserDefaults`.
- `AppState.$user` is observed to persist the current user ID.
- `DashboardViewModel.$todo` drives table view reloads.
- `AppState.$user` binds to the welcome label in `HomeController`.

## Project Structure

```
UIKitPractice/
├── AppRouter.swift                    # Routes root VC between Auth and Main flows
├── AppModel.xcdatamodeld/             # Core Data model (Todo, Users entities)
├── Assets.xcassets/                   # Theme colors (ThemeAccent, ThemeSurface) and app icon
├── Info.plist
│
├── cell/
│   └── TodoCell.swift                 # Programmatic UITableViewCell with accent bar,
│                                      #   title, category badge, and status label
│
├── controller/
│   ├── AuthController.swift           # Login and Create Account screens (Storyboard IBOutlets)
│   ├── HomeController.swift           # Todo list with UITableView, segmented control,
│   │                                  #   swipe actions, and pull-to-refresh
│   ├── AddTodoController.swift        # Add/Edit todo presented as a modal sheet
│   └── ProfileController.swift        # Displays user profile with logout button
│
├── core/
│   ├── AppState.swift                 # ObservableObject holding login state and current user,
│   │                                  #   persists to UserDefaults via Combine sinks
│   └── CoreDataManager.swift          # Singleton Core Data stack (NSPersistentContainer)
│
├── delegate/
│   ├── AppDelegate.swift              # App lifecycle delegate
│   └── SceneDelegate.swift            # Scene lifecycle, window setup, initial routing
│
├── extension/
│   └── Extensions.swift               # NSManagedObjectContext.saveData() convenience method
│
├── model/
│   └── TodoEnum.swift                 # StatusEnum (pending/completed) and TodoSections
│                                      #   (All, Work, Personal, Shopping) enums
│
├── storyboard/
│   ├── Auth.storyboard                # Login and Create Account UI
│   └── Main.storyboard                # Home, Add Todo, and Profile UI
│
└── viewModel/
    ├── AuthViewModel.swift            # Handles login and user creation against Core Data
    └── DashboardViewModel.swift       # Todo CRUD operations, category filtering, sign out
```

## Data Model

The Core Data model (`AppModel.xcdatamodeld`) contains two entities:

### Users
| Attribute  | Type   | Description                  |
|------------|--------|------------------------------|
| `id`       | String | Unique identifier (UUID)     |
| `name`     | String | User's display name          |
| `email`    | String | User's email (login key)     |
| `password` | String | User's password (plain text) |

### Todo
| Attribute   | Type   | Description                              |
|-------------|--------|------------------------------------------|
| `id`        | String | Unique identifier (UUID)                 |
| `desc`      | String | Todo description / title                 |
| `status`    | String | `"pending"` or `"completed"`             |
| `category`  | String | `"Work"`, `"Personal"`, `"Shopping"`, or `"All"` |
| `user_id`   | String | Foreign key linking to the owning `Users` entity |

### Relationships
- `Users` --(1:1)--> `Todo` via `user_todo_relation` / `todo_user_relation`

## How It Works

1. **App Launch**: `SceneDelegate.scene(_:willConnectTo:options:)` creates an `AppState` instance. Based on the persisted `isLoggedIn` flag in `UserDefaults`, it routes to either the Auth or Main storyboard via `AppRouter`.

2. **Routing**: `AppRouter.setRootViewController(to:appState:)` instantiates the appropriate storyboard, extracts the initial view controller (unwrapping `UINavigationController` if present), configures it with `AppState`, and performs a cross-dissolve animation on the window's root.

3. **Authentication**:
   - `AuthController` creates an `AuthViewModel` with the shared `AppState`.
   - **Login**: Queries Core Data for a `Users` record matching email + password. On success, sets `appState.isLoggedIn = true` and `appState.user`.
   - **Create Account**: Inserts a new `Users` entity into Core Data with a UUID, name, email, and password. Sets login state and navigates to Main.

4. **Todo List**:
   - `HomeController` creates a `DashboardViewModel` and binds to `appState.$user` for the welcome label.
   - `DashboardViewModel.fetchTodo()` queries Core Data for `Todo` records matching the current user's `user_id`, optionally filtered by category, sorted by `id`.
   - The segmented control (`UISegmentedControl`) is populated from `TodoSections.allCases` and triggers `viewModel.selectCategory()` on value change.
   - Pull-to-refresh calls `viewModel.fetchTodo()`.

5. **Todo CRUD**:
   - **Create**: `AddTodoController` collects description and category, calls `viewModel.createTodo(desc:category:)` which inserts a new `Todo` entity with status `"pending"`.
   - **Edit**: Swipe-to-edit or tapping opens `AddTodoController` in edit mode. Fields are pre-populated. Saving updates the `desc` and `category` fields.
   - **Toggle Status**: Swipe action calls `viewModel.toggleStatus(for:)` which flips between `"pending"` and `"completed"`.
   - **Delete**: Swipe action or table view editing calls `viewModel.deleteTodo(at:)` which deletes from Core Data and removes from the array.

6. **Session Persistence**:
   - `AppState.init()` reads `isLoggedIn` and `userId` from `UserDefaults`.
   - Combine sinks on `$isLoggedIn` and `$user` automatically persist changes.
   - On logout, `ProfileController` sets `isLoggedIn = false` and `user = nil`, then routes back to Auth.

## Key Components

### AppRouter
An enum-based router that switches the window's root view controller between Auth and Main storyboards. Uses `UIApplication.shared.connectedScenes` to access the active `SceneDelegate` and its window.

### AppState (ObservableObject)
Global state container with `@Published var isLoggedIn` and `@Published var user`. Uses Combine sinks to auto-persist state to `UserDefaults`. On init, restores previous session by fetching the user from Core Data using the stored `userId`.

### CoreDataManager
Singleton managing the `NSPersistentContainer` named `"AppModel"`. Provides a `context` property and a `saveContext()` method.

### DashboardViewModel
Handles all todo operations: `fetchTodo()`, `createTodo()`, `saveTodo()`, `toggleStatus()`, `deleteTodo()`, and `signOut()`. Supports category filtering via `selectedCategory`.

### AuthViewModel
Handles `login(email:pass:)` and `createUser(name:email:pass:)` against the Core Data `Users` entity. Updates `AppState` on success.

### TodoCell
A fully programmatic `UITableViewCell` with:
- Colored accent bar (matches category)
- Title label with truncation
- Category badge (colored pill)
- Status label (red for pending, green for completed)
- Dimmed appearance for completed todos

### TodoEnum
- `StatusEnum`: `.pending` / `.completed` with `displayTitle` and `statusColor` computed properties.
- `TodoSections`: `.all` / `.work` / `.personal` / `.shopping` for category filtering.

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd UIKitDemo
   ```

2. **Open in Xcode**
   ```bash
   open UIKitPractice.xcodeproj
   ```

3. **Select a simulator or device**
   - Choose an iOS 26.5+ simulator (e.g., iPhone 16) from the scheme selector.

4. **Build and run**
   - Press `Cmd + R` or click the Run button.

5. **Create an account** or **log in** to start managing your todos.

## Requirements

| Dependency | Version |
|------------|---------|
| Xcode      | 26+     |
| iOS        | 26.5+   |
| Swift      | 5       |
| UIKit      | Built-in |
| Combine    | Built-in |
| Core Data  | Built-in |
