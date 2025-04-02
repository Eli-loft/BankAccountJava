# BankAccount Java Project

## Overview
This project is one of my first explorations into Object-Oriented Programming (OOP), completed during my freshman year. It demonstrates basic OOP principles through the simulation of a simple bank account. The project separates concerns by dividing the work into two distinct components:

- **`BankAccount.java`**: Contains the methods and logic related to managing the account balance, including methods for deposit and withdrawal.
- **`Tester.java`**: Acts as the user interface, allowing interaction with the bank account via command-line inputs.

## Features
- **Deposits**: Users can add funds to the account balance.
- **Withdrawals**: Users can withdraw funds, which are subtracted from the account balance.
- **Balance Inquiry**: After each transaction, the updated account balance is displayed.
- **Error Handling**: Prompts the user for correct input if an invalid option is selected.

## How to Run
1. Compile both Java files:
   ```bash
   javac BankAccount.java Tester.java
   ```

2. Run the Tester program:
   ```bash
   java Tester
   ```

3. Follow the on-screen prompts to deposit, withdraw, or exit the application.

## Example Interaction
```
What would you like to do: withdraw, deposit, or exit
deposit
How much would you like to deposit?
100
Your new balance: $100.0
What would you like to do: withdraw, deposit, or exit
withdraw
How much would you like to withdraw?
25
Your new balance: $75.0
What would you like to do: withdraw, deposit, or exit
exit
```

## Purpose
This introductory project was designed to reinforce fundamental concepts of OOP, such as encapsulation, class creation, method invocation, and basic user interaction. It provided practical experience with Java syntax, control flow structures (such as loops and switch statements), and handling user inputs using a `Scanner` object.

