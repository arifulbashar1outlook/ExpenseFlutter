# Paisa Manager - Your Personal Finance Companion

**Paisa Manager** is a comprehensive mobile application built with Flutter that empowers you to take control of your finances. It provides a user-friendly interface to track your income, expenses, and loans, helping you make informed financial decisions and achieve your financial goals.

## Key Features:

*   **Income and Expense Tracking:** Easily record your daily transactions, categorize them, and monitor your spending habits.
*   **Bazar/Grocery Management:** Keep a detailed list of your grocery expenses, making it easy to manage your household budget.
*   **Loan and Lending Management:** Track money you've borrowed or lent, with details on amounts, dates, and repayment status.
*   **Financial Reports:** Generate insightful reports to understand your financial health, including monthly and yearly summaries.
*   **Account Management:** Manage multiple accounts, such as cash, bank accounts, and digital wallets.
*   **Dark Mode:** Enjoy a comfortable viewing experience in low-light environments.
*   **Cross-Platform:** Available on both Android and iOS devices.

## App Architecture

The app follows a clean and scalable architecture, leveraging the following:

*   **Provider:** For state management, ensuring a clear separation of concerns between the UI and business logic.
*   **GoRouter:** For declarative routing, providing a robust and flexible navigation system.
*   **Firebase:** For backend services, including authentication and database.

## Current Task: Refactoring and Code Cleanup

This update focused on a comprehensive cleanup of the codebase to improve its quality, maintainability, and ensure compliance with the latest Dart and Flutter standards. All warnings from the Dart analyzer have been systematically addressed, and the project structure has been improved.

### Changes Made:

*   **Resolved Analysis Issues:** Addressed all warnings from the `flutter analyze` command, including:
    *   Fixed `library_private_types_in_public_api` warnings.
    *   Replaced the deprecated `value` property with `initialValue` in `DropdownButtonFormField`.
    *   Corrected `use_build_context_synchronously` warnings by ensuring `BuildContext` is not used across async gaps.
    *   Removed all `unused_import` statements.
    *   Fixed `unrelated_type_equality_checks`.
    *   Resolved `argument_type_not_assignable` errors.
*   **Formatted Code:** Ran `dart format .` across the entire project to ensure consistent styling.
*   **Deleted Unused File:** Removed the `lib/screens/test_screen.dart` file as it was no longer needed.
*   **Updated Project Structure:** Refactored the file structure for better organization.

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/paisa-manager.git
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the app:**

    ```bash
    flutter run
    ```

## Contributing

We welcome contributions from the community! If you have any ideas, a bug to report, or a feature to request, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
