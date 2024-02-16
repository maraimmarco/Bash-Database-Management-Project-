#!/bin/bash

echo hello

option=$(zenity --list --title="Select Option" --column="Options" "createDB" "connectDB" --width=250 --height=200 --hide-header)

case $option in
    "createDB")
        DBNAME=$(zenity --entry --title="Create DataBase" --text="please enter database name to create:" --entry-text="New DataBase")
        # Check if the input is empty
        if [[ -z $DBNAME ]]; then
            echo "Input is empty"
            zenity --notification --text="Input Is Empty"
        else
            if [[ ! -e $DBNAME ]]; then
                mkdir "$DBNAME"
                echo "Database created successfully"
                zenity --notification --text="Database created: $DBNAME"
            else
                echo "Database already exists"
                zenity --notification --text="Database already exist"
            fi
        fi
        ;;
    "connectDB")
        echo "Connect to database"
        conDB=$(zenity --entry --title="Connect to DataBase" --text="Please enter database name:")
        # Check if the input is empty
        if [[ -z $conDB ]]; then
            echo "Input is empty"
            zenity --notification --text="Input is Empty"
        else
            if [[ -e $conDB ]]; then
                cd "$conDB" || exit
                echo "Connected to $conDB"
                zenity --notification --text="Database connected: $conDB"
            else
                echo "Database does not exist"
                zenity --notification --text="Database Doesnot Exist"
            fi
        fi
        ;;
    *)
        echo "Invalid option"
        zenity --notification --text="INVAILD OPTION"
        ;;
esac

