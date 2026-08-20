# UIKitPractice

An iOS Todo app built with UIKit (Storyboard), Combine, and Core Data following the MVVM pattern.

## Features

- **Authentication**: Login and create-account screens backed by Core Data (`Users` entity)
- **Todo list**: Add, edit, delete, and toggle todo status (pending/completed)
- **Swipe actions**: Swipe to edit, complete, or delete a todo
- **Profile screen**: Shows the logged-in user's details with a logout button
- **Session persistence**: Login state is persisted across launches via `UserDefaults`
- **Dark mode support**: Themed colors (background, accent, surface) with dark variants

## Architecture

The app uses MVVM with Combine for bindings and Core Data for persistence.

```
UIKitPractice/
├── AppRouter.swift            # Switches root view controller between Auth/Main
├── AppModel.xcdatamodeld/     # Core Data model (Todo, Users entities)
├── cell/
│   └── TodoCell.swift         # Programmatic custom table view cell
├── controller/
│   ├── AddTodoController.swift    # Add/edit todo sheet
│   ├── AuthController.swift       # Login + create account
│   ├── HomeController.swift       # Todo list
│   └── ProfileController.swift    # User profile + logout
├── core/
│   ├── AppState.swift             # Global app state (login state, current user)
│   └── CoreDataManager.swift      # Core Data stack singleton
├── delegate/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── extension/
│   └── Extensions.swift           # NSManagedObjectContext.saveData() helper
├── model/
│   └── TodoEnum.swift             # StatusEnum (pending/completed)
├── storyboard/
│   ├── Auth.storyboard            # Login + create account UI
│   └── Main.storyboard            # Home, Add Todo, Profile UI
├── viewModel/
│   ├── AuthViewModel.swift        # Login / create user
│   └── DashboardViewModel.swift   # Todo CRUD
└── Assets.xcassets/               # Theme colors and app icon
```

## How it works

- `SceneDelegate` creates an `AppState` and routes the user to the Auth or Main screen based on the persisted login flag.
- `AuthViewModel` authenticates against or creates records in the Core Data `Users` entity.
- `HomeController` uses `DashboardViewModel` to fetch, create, edit, toggle, and delete `Todo` records.
- `AppRouter` swaps the root view controller with a cross-dissolve transition on login/logout.

## Requirements

- Xcode 26+
- iOS 26.5+
- Swift 5

## Getting started

1. Open `UIKitPractice.xcodeproj` in Xcode.
2. Select a simulator or device.
3. Build and run (⌘R).