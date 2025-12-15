# SmartSpend Blueprint

## Overview

SmartSpend is a Flutter application designed to help users manage their personal finances. It provides a simple and intuitive interface for tracking income and expenses, categorizing transactions, and generating insightful reports.

## Style, Design, and Features

### Initial Version

- **Bottom Navigation:** A bottom navigation bar with five tabs: Input, Bazar, Bazar Report, Expense Report, and History.
- **Input Screen:** A screen for adding new transactions (income and expenses).
- **Bazar Screen:** A screen for tracking bazar expenses.
- **Bazar Report Screen:** A screen for displaying a report of bazar expenses.
- **Expense Report Screen:** A screen for displaying a report of all expenses.
- **History Screen:** A placeholder screen for transaction history.
- **State Management:** The application uses the `provider` package for state management.
- **Routing:** The application uses the `go_router` package for navigation.
- **Styling:** The application uses Google Fonts and a custom theme.

### Current Version

- **Categorization:** Added a `category` field to the `Transaction` and `BazarItem` models to allow for categorization of expenses.
- **Categorized Input:** Updated the `NewTransactionCard` and `BazarScreen` to include a dropdown menu for selecting a category when adding a new transaction or bazar item.
- **Full Monthly Report:** Created a `FullMonthlyReportScreen` that displays a comprehensive overview of the user's finances for the month. The report includes:
  - **End of Month Status:** A grid view of all accounts and their current balances.
  - **Monthly Flow:** A summary of total income, total expenses, and net flow.
  - **Categorical Breakdown:** An expandable list of all expense categories and the total amount spent in each category.
- **Updated Providers:** Updated the `TransactionProvider` and `AccountProvider` with more sample data and getters for total income and expenses.
- **UI Enhancements:** Added a new tab to the bottom navigation bar for the "Full Monthly Report" and updated the icons.
- **Error Handling:** Implemented basic error handling for input forms.

## Plan and Steps for Current Request

I have finished implementing the requested features. The next step is to test the application and ensure that all features are working as expected. I will then deploy the application to a web server.
