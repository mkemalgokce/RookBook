# RookBook
[![CI-iOS](https://github.com/mkemalgokce/RookBook/actions/workflows/CI-iOS.yml/badge.svg)](https://github.com/mkemalgokce/RookBook/actions/workflows/CI-iOS.yml) [![CI-macOS](https://github.com/mkemalgokce/RookBook/actions/workflows/CI-macOS.yml/badge.svg)](https://github.com/mkemalgokce/RookBook/actions/workflows/CI-macOS.yml)

RookBook is an iOS application built with Clean Architecture principles and Test-Driven Development (TDD) practices. The project demonstrates the implementation of robust software design patterns and best practices in iOS development.

## Project Architecture

The project follows Clean Architecture with clear separation of concerns:

### Core Layers

- **Domain Layer**
  - Contains business logic and entities
  - Defines repository interfaces
  - Pure Swift with no dependencies on external frameworks
  - Located in `RookBookCore/Features/*/Domain`

- **Data Layer**
  - Implements repository interfaces
  - Handles data operations and transformations
  - Contains DTOs and mappers
  - Located in `RookBookCore/Features/*/Data`

- **Infrastructure Layer**
  - Implements concrete data storage (CoreData)
  - Handles external services and API communication
  - Located in `RookBookCore/Features/*/Infrastructure`

### Key Features

- **Book Management**
  - Composite pattern for book operations
  - Local and remote data synchronization
  - CRUD operations with proper separation

## Testing Strategy

The project emphasizes comprehensive testing:

- **Unit Tests**: `RookBookCoreTests/`
  - Tests for mappers, factories, and business logic
  - Follows TDD principles with high coverage
  - Isolated tests for each component

- **Integration Tests**: `RookBookCoreStoreIntegrationTests/`
  - Tests for data persistence
  - CoreData integration testing
  - End-to-end feature testing

## Project Structure

```
RookBook/
├── RookBookCore/           # Core business logic and implementation
│   ├── Common/            # Shared utilities and protocols
│   └── Features/          # Feature modules
│       └── Book/          # Book feature implementation
│           ├── Domain/    # Business logic and interfaces
│           ├── Data/      # Data layer implementation
│           └── Infrastructure/ # External frameworks integration
├── RookBookCoreTests/     # Unit tests
├── RookBookCoreStoreIntegrationTests/ # Integration tests
└── RookBookIOSApp/        # iOS UI Implementation
```

## Development Practices

- **Clean Architecture**: Strict separation of concerns with clear boundaries between layers
- **TDD**: All features are developed using test-driven development
- **SOLID Principles**: Adherence to SOLID principles throughout the codebase
- **Swift Style**: Follows SwiftLint and SwiftFormat guidelines
- **Dependency Injection**: Used throughout the project for better testability
- **Repository Pattern**: Abstracts data sources and provides clean interfaces
- **Factory Pattern**: Used for object creation and dependency management

## Getting Started

1. Clone the repository
2. Open the project in Xcode
3. Run the tests to ensure everything is working
4. Build and run the application

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

## Code Quality

The project maintains high code quality standards through:
- SwiftLint integration
- SwiftFormat configuration
- Comprehensive test coverage
- Clean Architecture principles
- SOLID design principles

