# 💳 BankAccountMock

BankAccountMock is a modern iOS application built using SwiftUI that simulates a user's banking profile. It showcases a clean architectural approach with MVVM, modular networking, and accessibility support, all while maintaining a responsive and user-friendly design.

## 🧠 Architecture

- **MVVM**: Clear separation between Views, ViewModels, and Models.
- **SwiftUI + `@EnvironmentObject`**: For sharing global app state across views.
- **`@Environment`**: Used for injecting formatters (e.g., DateFormatter, NumberFormatter) across the UI.

## 🌗 Theming

- **Dark/Light Mode Support**: Fully dynamic color scheme using `EnvironmentKey` for centralized color definitions.

## 🔍 Search

- **Search by Account Name and Balance**: Interactive search functionality allows users to filter accounts by name or balance amount directly on the account list screen.

## 🔄 App States

- **Loading State**: Displays activity indicator during data loading.
- **Error State Handling**: Shows dedicated error UI with retry option.

## ♿ Accessibility

- Implements `AccessibilityLabel` and `AccessibilityIdentifier` for better accessibility and test automation.

## ✅ Testing

- **Unit Tests for Network Layer**: The networking module is covered by unit tests to ensure reliability and stability.

## 📦 Modularity

- **Network Layer via Swift Package Manager (SPM)**: Modularized and managed using SPM for clean dependency management and separation of concerns.

## 🧰 Development Tools

- **Mock Generators for Account Details**: Built-in mock data generator simplifies UI testing and preview rendering without relying on live data.


## 🚀 Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/capitan112/BankAccountMock.git
    cd BankAccountMock
    ```
2. Open the project in Xcode.
3. Build and run on Simulator or real device.


## 👨‍💻 Author

Oleksiy Chebotarov  
[LinkedIn](https://www.linkedin.com/in/chebotarevalexei) | [GitHub](https://github.com/capitan112)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
