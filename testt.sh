#!/bin/bash
#create zenity to button user choose from it (int string)
#need to validate the choose of int and string
echo hello
while true; do
    option=$(zenity --list --title="Select Option" --column="Options" "createDB" "listDB" "dropDB" "connectDB" "Exit" --width=250 --height=200 --hide-header)
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
        "listDB")
            # List existing databases
            result=$(ls -d */)
            zenity --info --title="Existing Databases" --text="$result" --width=400 --height=300
            ;;
			
					   
				"dropDB")
					    db_name=$(zenity --entry --title="Drop DB" --text="Enter DB name:")

			    if [[ -z "$db_name" ]] || [[ "$db_name" =~ ^[0-9] ]] || [ ! -d "$db_name" ]; then
				zenity --error --title="Error" --text="Invalid DB name"
			    else
				rm -r "$db_name"
				zenity --info --title="Success" --text="$db_name dropped successfully"
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
		if [[ -d $conDB ]]; then  # Check if the entered database name is a directory
		    cd "$conDB" || exit  # Change directory to the selected database
		    echo "Connected to $conDB"
		    zenity --notification --text="Database connected: $conDB"
		    while true; do
		        # List contents of the current directory (tables in the database)
		        tables=$(ls | grep -v '^\.')  # Exclude hidden files/directories
		        
		        option=$(zenity --list --title="Select Option" --column="Options" "Create Table" "Insert Values" "List Table" "Drop Table" "Back" --width=250 --height=200 --hide-header)
                case $option in
                            "Create Table")
                                TBNAME=$(zenity --entry --title="Create Table" --text="Please enter table name:")
                                tbnamem=$TBNAME
                                # Check if the table name is empty
                                if [[ -z $TBNAME ]]; then
                                    echo "Table name is empty"
                                    zenity --notification --text="Table name is empty"
                                    continue
                                fi
                                colNumber=$(zenity --entry --title="Create Table" --text="Please enter column number:")
                                # Check if the column number is not empty and is a valid number
                                if [[ -z $colNumber || ! $colNumber =~ ^[1-9][0-9]*$ ]]; then
                                    echo "Invalid column number"
                                    zenity --notification --text="Invalid column number"
                                    continue
                                fi
                               
                                for ((i=0; i<$colNumber; i++))
                                do
                                    line=""
                                    colName=$(zenity --entry --title="Create Table" --text="Enter column name:")
                                    # Check if the column name is empty
                                    if [[ -z $colName ]]; then
                                        echo "Column name cannot be empty"
                                        zenity --notification --text="Column name cannot be empty"
                                        continue 
                                    fi  
                                    colDatatype=$(zenity --list --title="Select Data Type" --column="Options" "Int" "String" "Back" --width=250 --height=200 --hide-header)
                                    case $colDatatype in
                                        "Int" | "String")
                                            # Check if the column data type is empty
                                            if [[ -z $colDatatype ]]; then
                                                echo "Column data type cannot be empty"
                                                zenity --notification --text="Column data type cannot be empty"
                                                continue 
                                            fi
                                            ;;
                                        "Back")
                                            continue 2
                                            ;;
                                        *)
                                            echo "Invalid option"
                                            zenity --notification --text="Invalid option"
                                            continue 
                                            ;;
                                    esac
                                    line+="$colName:$colDatatype"
                                    echo "$line" >>".$tbnamem"
                                done
                                echo "Table created"
                                touch ".$tbnamem"
                                touch "$TBNAME"
                                
                                zenity --notification --text="Table created: $TBNAME"
                                ;;
                            "Insert Values")
                                TBname=$(zenity --list --title="Select Table" --column="Tables" $(ls | grep -v '^\.'))
                                if [[ -z $TBname ]]; then
                                    echo "No table selected"
                                    zenity --notification --text="No table selected"
                                    continue
                                fi
                                # Get the column names from the metadata file
                                columns=$(cut -d: -f1 ".$TBname")
                                # Create an associative array to store the column names and their respective values
                                declare -A values
                                for column in $columns; do
                                    # Prompt the user to enter the value for each column using Zenity entry dialog
                                    value=$(zenity --entry --title="Insert Value" --text="Enter value for column '$column' in table '$TBname':")
                                    if [[ -z $value ]]; then
                                        echo "Value for column '$column' cannot be empty"
                                        zenity --notification --text="Value for column '$column' cannot be empty"
                                        continue 2
                                    fi
                                    values["$column"]=$value
                                done
                                # Construct the line to insert into the table
                                line=""
                                for column in $columns; do
                                    line+="${values[$column]}:"
                                done
                                # Append the line to the table file
                                echo "${line::-1}" >> "$TBname"
                                zenity --notification --text="Values inserted into: $TBname"
                                ;;
                            "List Table")
		    # Debug statement to check the execution of the loop
		    echo "Entering loop to collect table names"
		    
		    # Reset the tables variable
		    tables=""

		    # Iterate over files in the database folder
		    for file in "$conDB"/*; do
			# Debug statement to print the current file being checked
			echo "Checking file: $file"
			
			# Check if the file is a regular file (i.e., a table)
			if [[ -f $file ]]; then
			    # Extract the table name from the file path and append it to the list of tables
			    tables+="$(basename "$file")"$'\n'
			fi
		    done

		    # Debug statement to check if tables are collected
		    echo "Tables found: $tables"

		    # Display the list of tables using Zenity
		    zenity --info --title="Tables in $conDB" --text="$tables" --width=400 --height=300
		    ;;
		            "Drop Table")
			# Prompt the user to enter the name of the table to drop
			table_to_drop=$(zenity --entry --title="Drop Table" --text="Enter the name of the table to drop:")

			# Check if the input is empty
			if [[ -z $table_to_drop ]]; then
			    zenity --error --text="Table name is empty"
			    exit
			fi

			# Check if the table exists
			if [[ ! -f "tables/$table_to_drop" ]]; then
			    zenity --error --text="Table does not exist: $table_to_drop"
			    exit
			fi

			# Prompt the user to confirm the deletion
			confirmation=$(zenity --question --text="Are you sure you want to drop the table '$table_to_drop'?")

			# Check if the user confirmed the deletion
			if [[ $confirmation == "TRUE" ]]; then
			    # Remove both the table and its associated metadata file
			    rm -f "tables/$table_to_drop"
			    rm -f "metaData/${table_to_drop}meta"
			    zenity --info --text="Table dropped: $table_to_drop"
			else
			    zenity --info --text="Drop operation canceled"
			fi

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
