# MockGame

MockGame is a lightweight demo project that showcases a **modern iOS MVVM architecture** built with **SwiftUI**, **Swift Concurrency**, and **Observation**.  
The app simulates **live match odds updates** using mock data and an async stream, focusing on **thread safety, testability, and clear separation of concerns**.

---

## Features

- 🏟 **Live Match List**
  - Displays a list of matches with teams and start times
  - Sorted by match start date

- 📈 **Live Odds Updates**
  - Simulates real-time odds changes via `AsyncStream`
  - Odds update automatically without manual refresh

- 🔄 **Pull to Refresh**
  - Reload initial match and odds data

- ⚠️ **State-driven UI**
  - Handles loading, success, and error states
  - UI updates reactively based on ViewModel state

- 🧪 **Testable Architecture**
  - Repository abstraction via protocol
  - ViewModel covered by unit tests using Swift Testing

---

## Architecture Overview

The project follows a **clean MVVM + Repository** architecture with explicit concurrency boundaries.

SwiftUI View
↓
ViewModel (@MainActor, @Observable)
↓
Repository (actor + protocol)
↓
Data Services (actors)


### Layer Responsibilities

#### View (SwiftUI)
- Renders UI based on ViewModel state
- Contains no business logic
- Does not manage threading or data fetching

#### ViewModel
- Acts as the single source of truth for UI state
- Coordinates data loading and live updates
- Exposes state in a UI-friendly form

```swift
@MainActor
@Observable
final class MatchListViewModel { ... }
Repository
```

#### Abstracts data sources

Combines initial data fetching and live updates

Implemented as an actor and accessed via a protocol
```swift
actor MatchRepository: MatchRepositoryProtocol { ... }
```

#### Data Services
- Provide mock data and simulated WebSocket updates
- Fully isolated using actor to guarantee thread safety


---
## Swift Concurrency & Combine Usage
## Swift Concurrency

Swift Concurrency is the primary concurrency model in this project.

Usage scenarios:

- async / await
Fetching initial match and odds data

- actor
Protecting shared mutable state
Ensuring data race–free access

- AsyncStream
Simulating real-time WebSocket updates

```swift
func startOddsStream() async -> AsyncStream<Odds>
```


---
## Combine usage
## Swift Concurrency
- Combine is not the core data flow mechanism in this project.
Reactive updates are handled via:
@Observable (Observation framework)
@MainActor isolation

- Combine may still be used for:
1. Legacy APIs
2. Notification-based bridging
3. Interoperability with existing Combine-based systems


---
## Thread-Safety Strategy
Thread safety is enforced by design, not by convention.

### Key Principles

1. Actors for Shared Mutable State

- MockDataService and WebSocketSimulator are actors

- Prevents data races automatically

2. Repository as an Actor

- Centralizes data coordination

- Guarantees safe concurrent access

3. MainActor for UI State

- All ViewModel mutations occur on the main thread

- Prevents UI-related threading bugs


---
## UI & ViewModel Data Binding
The project uses Swift Observation instead of Combine bindings.

### Binding Mechanism

- @Observable automatically publishes changes

- SwiftUI re-renders views when observed properties change

- No manual @Published or objectWillChange needed

like:
```swift
@Observable
@MainActor
final class MatchListViewModel {
    var state: State
    var matches: [MatchWithOdds]
}
```


## Testability

- ViewModel depends on MatchRepositoryProtocol

- Mock repository can be injected for tests

- Async behavior tested using Swift Testing

```swift
init(repository: MatchRepositoryProtocol)
```



## Key Design Takeaways

- Actors define concurrency boundaries

- @MainActor protects UI state

- Protocols enable testability

- SwiftUI Views stay thin and declarative

- State drives UI, not side effects


## Tech Stack

- SwiftUI

- Swift Concurrency (async/await, actor, AsyncStream)

- Observation (@Observable)

- Swift Testing

- MVVM + Repository Pattern


## Purpose

This project is intended as:

- A reference for modern SwiftUI + Concurrency architecture

- A demonstration of thread-safe, testable MVVM design

- A learning project for async data flows and real-time updates


----
## Demo video


https://github.com/user-attachments/assets/ff6c1d7a-37a7-43d6-818c-c53983393bc6


