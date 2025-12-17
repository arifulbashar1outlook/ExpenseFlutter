# Spend Smart - Personal Finance Tracker

## Overview

Spend Smart is a Flutter application designed to help users track their income and expenses. It provides a clear overview of financial transactions, allows users to manage different accounts, and leverages generative AI with Gemini to provide summaries of their spending habits.

## Features & Design

### Core Functionality
- **Transaction Management:** Users can add, view, and categorize income and expense transactions.
- **Account Management:** Users can create and manage multiple financial accounts (e.g., checking, savings).
- **Local Storage:** All data is persisted locally on the device using `shared_preferences`.

### AI-Powered Insights
- **Financial Summary:** The application uses the Gemini AI model via the `firebase_ai` package to generate natural language summaries of the user's financial activity.

### Visual Design & Theming
- **Theme:** The app features a modern, consistent theme for both light and dark modes.
- **Color Scheme:** A defined color palette is used for branding and to differentiate between income (green) and expenses (red).
- **Typography:** The app will use the `google_fonts` package for clean and readable typography.

## Current Plan

The application is currently in a broken state due to multiple configuration and code errors. The following steps will be taken to get the application to a runnable state.

1.  **Add `firebase_ai` Dependency:** The `pubspec.yaml` file is missing the `firebase_ai` package, which is required for the Gemini integration.
2.  **Create Theming Constants:** The color constants used in the `AppTheme` are undefined. I will create a new file `lib/core/constants/app_constants.dart` to define these.
3.  **Implement Local Storage Methods:** The `LocalStorageService` is missing the implementation for saving and retrieving account and transaction data. I will implement these methods.
4.  **Fix UI Code:** There is a string formatting error in the `TransactionList` widget that needs to be corrected.
5.  **Correct Model Instantiation:** The code for creating new `Account` and `Transaction` objects is missing required parameters (`id` and `accountId`). This will be fixed.
6.  **Resolve Imports & Dependencies:** I will run `flutter pub get` and then `flutter run` to verify the fixes.
