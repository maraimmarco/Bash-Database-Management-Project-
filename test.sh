#!/bin/bash

echo hello
while true; do
    option=$(zenity --list --title="Select Option" --column="Options" "createDB" "connectDB" "Exit" --width=250 --height=200 --hide-header)

    case $option in
        "createDB")
            DBNAME=$(zenity --entry --title="Create DataBase" --text="please enter database name to create:" --entry-text="New DataBase" --cancel-label="Back")
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
                    zenity --notification --text="Database already exists"
                fi
            fi
            ;;
        "connectDB")
            echo "Connect to database"
            conDB=$(zenity --entry --title="Connect to DataBase" --text="Please enter database name:" --cancel-label="Back")
            # Check if the input is empty
            if [[ -z $conDB ]]; then
                echo "Input is empty"
                zenity --notification --text="Input is Empty"
            else
                if [[ -e $conDB ]]; then
                    cd "$conDB" || exit
                    echo "Connected to $conDB"
                    zenity --notification --text="Database connected: $conDB"

                    while true; do
			option=$(zenity --list --title="Select Option" --column="Options" "Create Table" "List Table" "Back" --width=250 --height=200 --hide-header)

                        
                        case $option in
                            "Create Table")
                                TBname=$(zenity --entry --title="Create Table" --text="Please enter table name:")
                                colNumber=$(zenity --entry --title="Create Table" --text="Please enter column number:")
                                line=""
                                for ((i=0; i<$colNumber; i++)); do
                                    colName=$(zenity --entry --title="Create Table" --text="Enter column name:")
                                    colDatatype=$(zenity --entry --title="Create Table" --text="Enter column data type:")
                                    line+=":$colName:$colDatatype"
                                done
                                echo "Table created"
                                touch "$TBname"
                                echo "$line" >> "$TBname"
                                zenity --notification --text="Table created: $TBname"
                                ;;
                            "List Table")
                                result=$(ls)
                                zenity --info --title="Tables in $conDB" --text="$result" --width=400 --height=300
                                ;;
                            "Back")
                                break
                                ;;
                            *)
                                echo "Invalid option"
                                zenity --notification --text="Invalid option"
                                ;;
                        esac
                    done
                else
                    echo "Database does not exist"
                    zenity --notification --text="Database Does Not Exist"
                fi
            fi
            ;;
        "Exit")
            zenity --notification --text="Connection closed"
            exit 0
            ;;
        *)
            echo "Invalid option"
            zenity --notification --text="Invalid option"
            ;;
    esac
done

