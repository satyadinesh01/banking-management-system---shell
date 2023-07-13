#!/bin/bash

# Define the file that stores the user information
USER_FILE=login.txt

if [ ! -f "$login" ]; then
    touch "$login"
fi



# for storing the data of user balance
DATA_FILE=data.txt

if [ ! -f "$data" ]; then
    touch "$data"
fi



# loacl veriables
PIN=0
cdepo=0
name=""
flag=1
depo=0

#menu function for user
menu() {
        BALANCE=$(cat data.txt | grep "$username" | cut -d':' -f2)

    echo "BANKING MANAGEMENT SYSTEM"
while true
do
  echo "+------------------------------+"
  echo "|            Menu              |"
  echo "|      SELECT AN OPTION        |"
  echo "+------------------------------+"
  echo "| 1. account detalis           |"
  echo "| 2. change PIN                |"
  echo "| 3. Deposit                   |"
  echo "| 4. Withdraw                  |"
  echo "| 5. Check Balance             |"
  echo "| 6. Exit                      |"
  echo "+------------------------------+"

  read -p "Enter your choice: " choice

  case $choice in
    1)
        accdetails
      ;;


    2)
        changepin
      ;;

    3)
        Deposit
      ;;

    4)
        withdrawal
      ;;

    5)
        Check_Balance
      ;;

    6)
      echo "Thank you for using the banking system"
      exit 0
      ;;

    *) # Invalid option
      echo "Invalid option. Please select again"
      ;;
  esac
done
}

# Define the function to register a new user
register() {
    read -p "Enter your username: " username
    read -p "Enter your password: " password

    # Check if the username already exists
    if grep -q "^${username}:" $USER_FILE; then
        echo "Username already exists."
    else
        # Add the new user to the user file
        echo "${username}:${password}" >> $USER_FILE
        BALANCE=5000
        echo "${username}:${BALANCE}" >> $DATA_FILE
        echo "Registration successful."
        echo "Account already exists for user $username"
    fi
}

# Define the function to login a user
login() {
    read -p "Enter your username: " username
    read -p "Enter your password: " password

    # Check if the username and password match
    if grep -q "^${username}:${password}$" $USER_FILE; then
        echo "Login successful."
        echo "You can enjoy our services now."
        menu
    else
        echo "Invalid username or password."
    fi
}

# Define the main function
main() {
    echo "Welcome to the Banking system."

    while true; do
        read -p "Do you want to login or register? (l/r): " choice

        if [ "$choice" = "l" ]; then
            login
            break
        elif [ "$choice" = "r" ]; then
            register
        else
            echo "Invalid choice."
        fi
    done
}


accdetails(){
    echo "Name: $username"
    echo "PIN: $password"
#    echo "No of Deposits: $cdepo"
#    echo "No of Withdrawals: $cwith"

    bal1=$(cat data.txt | grep "$username" | cut -d':' -f2)
    echo "Current Balance: $bal1"
}


changepin(){
    echo "Welcome $username"
    read -p "Please Enter your current PIN: " pin
    if [ $pin -eq $password ]; then
        echo "Pin Matched"
        read -p "Enter you new pin: " pin1
        read -p "Confirm your PIN: " cpin
        if [ $cpin -eq $pin1 ]; then
            password=$cpin
            sed -i "s/^${username}:.*/${username}:${cpin}/" $USER_FILE
            echo "PIN changed Succesfully"
        else
            echo "  YOU ENTERD INVALID PINS"
        fi
    else
        echo "Incorrect PIN"
    fi
}


Deposit(){
    echo "Enter amount to deposit:"
    read amount
    BALANCE=$((BALANCE + amount))
    sed -i "s/^${username}:.*/${username}:${BALANCE}/" $DATA_FILE
    echo "Deposit successful. Your new balance is: $BALANCE"

}


withdrawal() {
    echo "Enter amount to withdraw:"
    read cwith
    depo=$BALANCE
    depo=$((depo - cwith))

    if [ $depo -le 0 ]; then
        echo "Withdrawal unsuccessful. Insufficient balance."
    else
        BALANCE=$depo
        sed -i "s/^${username}:.*/${username}:${BALANCE}/" $DATA_FILE
        echo "Withdrawal successful. Your new balance is: $BALANCE"
    fi
}

Check_Balance(){
    bal=$(cat data.txt | grep "$username" | cut -d':' -f2)
    echo "THE CURRENT BALANCE IS: $bal"
}

# Call the main function
main
