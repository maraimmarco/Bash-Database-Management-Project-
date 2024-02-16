#!/bin/bash
#create database ->dir done 
#connect to database schema doneeeeeeeeeee
#create table database -> file
#list table -> list only files
#connect database doneeeeeeeee
#select data from table 
#isnert and update from database 
#handle all input and cirtical 
#priamry key -> unique and not null 

select option in createDB connectDB
do 
    case $option in
        "createDB")
            read -p "please enter data base name to create " DBNMAE
            #if string empty
            if [[ -z $DBNMAE ]]
            then 
            echo "input is empty"
            continue
            fi 

            if [[ ! -e $DBNMAE ]]
            then 
            pwd
            mkdir ${DBNMAE/}
            echo database created successfully 
            else 
                echo "database already exist" 
            fi 
            ;;
        "connectDB")
            read -p "please enter database name " conDB
            #if string empty
            if [[ -z $conDB ]]
            then 
            echo "input is empty"
            continue
            fi
            if [[ -e $conDB ]]
            then
            cd  $conDB
            #connect on database         
            # Define variables
            user_name="casestudy"
            password="root"
            host_name="MariamMarcos"
            port="1521"
            service_name="XE"
            sqlplus -s "${user_name}/${password}@${host_name}:${port}/${service_name}" <<EOF
            --select * from instructor;
EOF
            echo "connected done "
            echo "DataBase connected successfully"
            #need to call function here 
            select option in createTB listTB
        do 
            case $option in 
                "createTB")
                    read -p "please enter table name :" TBname
                    read -p "please enter column number: " colNumber
                    line=""
                    for ((i=0;i<$colNumber;i++))
                    do
                        read -p "enter column name:" colName
                        line+=:$colName
                        read -p "enter column data type: " colDatatype
                        line+=:$colDatatype
                        
                    done
                    echo "table is created"
                    touch $TBname
                    echo $line>>$TBname
                ;;
                "listTB")
                    result=cat metastd | cut -d: -f1
                ;;
            esac
        done 
            else 
            echo "database is not exist"
            fi
            ;;
    esac
done 
#craete tables and list tables 
displayDatabaseOption(){
    clear
    select option in createTB listTB
        do 
            case $option in 
                "createTB")
                    read -p "please enter table name :" TBname
                    read -p "please enter column number: " colNumber
                    line=""
                    for ((i=0;i<$colNumber;i++))
                    do
                        read -p "enter column name:" colName
                        line+=:$colName
                        read -p "enter column data type: " colDatatype
                        line+=:$colDatatype
                        echo $line>>$TBname
                    done
                    echo "table is created"
                    touch $TBname
                ;;
                "listTB")
                    result=cat metastd | cut -d: -f1
                ;;
            esac
        done 
}