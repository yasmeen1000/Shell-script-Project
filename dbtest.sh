#!/bin/bash

#If condition to check if the file of application exist or not
if [ ! -d "DBMS" ]; 
then
	mkdir "DBMS"
fi


# Function to create a database
create_database() {
    echo "Enter database name:"
    read dbname

    # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        echo "Error: Database name cannot contain spaces."
        return
    fi

     # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Database name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        echo "Error: Database name cannot start with a number."
        return
    fi

    if [ -d "DBMS/$dbname" ]; then
        echo "Database already exists!"
    else
        mkdir "DBMS/$dbname/"
        echo "Database created successfully!"
    fi
}



# Function to list databases
list_databases() {
    echo "List of databases:"
    ls -F DBMS/ | grep '/' | sed 's/\///'
}



# Function to drop a database
drop_database() {
    echo "Enter database name:"
    read dbname

   # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        echo "Error: Database name cannot contain spaces."
        return
    fi

     # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Database name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        echo "Error: Database name cannot start with a number."
        return
    fi


    if [ -d "DBMS/$dbname" ]; then
        rm -r "DBMS/$dbname/"
        echo "Database dropped successfully!"
    else
        echo "Database not found!"
    fi
}

# Function to create a table
create_table() {
    #echo "Current directory"
    #pwd

    #if [ -z "$current_db" ]; then
    #    echo "No database connected!"
    #    return
    #fi

    echo "Enter table name:"
    read tablename
    
    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi

    if [ -d "$tablename" ]; then
        echo "Table already exists!"
        return
    fi

    #if [ -z "$tablename" ]; then
    #    echo "Invalid table name!"
     #   return
    #fi

    echo "Enter the number of columns:"
    read num_columns

    if ! [[ "$num_columns" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid number of columns!"
        return
    fi
    
    if [ "$num_columns" -eq 0 ]; then
        echo "Error: You can not creat table with 0 columns"
        return
    fi
        

    declare -a columns
    declare -a datatypes
    primarykey=""
    
    for ((i=1; i<=num_columns; i++))
    do
        echo "Enter column $i name:"
        read column_name

        # Validate column name
        if [[ $column_name =~ \  ]]; then
            echo "Error: Column name cannot contain spaces."
            return
        fi

        if [[ ! $column_name =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo "Error: Column name can only contain alphanumeric characters and underscores."
            return
        fi
        
        # Check if the input starts with a number or not
        if [[ $column_name =~ ^[0-9] ]]; then
           echo "Error: Table name cannot start with a number."
           return
        fi

        #Column DataType
        echo "Enter column $i datatype(int or string):"
        read column_datatype

        # Validate column datatype
        if [[ ! "$column_datatype" =~ ^(int|string)$ ]]; then
            echo "Error: Invalid datatype, must be 'int' or 'string'."
            return
        fi

        if [ $i == 1 ];then
           primarykey=$column_name
        fi
           
        columns+=("$column_name")
        datatypes+=("$column_datatype")
        
    done

    #Primary Key
    #echo "Enter primary key column name:"
    #read primarykey

    # Check if primary key exists in the array
    #found=false
    #for column in "${columns[@]}"; do
    #    if [ "$column" == "$primarykey" ]; then
    #        found=true
    #        break
    #    fi
    #done

    #if [ "$found" != true ]; then
    #    echo "Primary key '$primarykey' does not exist in the array."
    #    return
        
    #else
     #   mkdir "${tablename}"
        
      #  echo "PrimaryKey:${primarykey}" >> "${tablename}/meta"    
       # echo "Columns:${columns[@]}" >> "${tablename}/meta"
        #echo "Datatypes:${datatypes[@]}" >> "${tablename}/meta"
        #touch "${tablename}/data"
        
        
    #fi
     
        mkdir "${tablename}"
        
        echo "PrimaryKey:${primarykey}" >> "${tablename}/meta"    
        echo "Columns:${columns[@]}" >> "${tablename}/meta"
        echo "Datatypes:${datatypes[@]}" >> "${tablename}/meta"
        touch "${tablename}/data"
        
    
    echo "Table created successfully!"
}


# Function to list tables
list_tables() {

    echo "List of tables:"
    ls -F | grep '/' | sed 's/\///'
}

# Function to drop a table
drop_table() {
   

    echo "Enter table name:"
    read tablename

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi


    if [ -d "$tablename" ]; then
        rm -r "$tablename"
        echo "Table dropped successfully!"
    else
        echo "Table not found!"
    fi
}


#Function to insert into table
insert_into_table() {
    echo "Enter table name:"
    read tablename
    
    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi
    
    if [ ! -d "$tablename" ]; then
        echo "Table does not exist!"
        return
    fi
    
    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    
    #echo "$primaryKey"
    
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))


    #echo "Columns array: ${columns[@]}"
    #echo "Datatypes array: ${datatypes[@]}"
    
    
    declare -A columns_datatypes

   
    for ((i=0; i<${#columns[@]}; i++)); do
        columns_datatypes["${columns[$i]}"]="${datatypes[$i]}"
    done


    declare -A column_data


    for column in "${columns[@]}"; do
        echo "Enter data for $column (${columns_datatypes[$column]}):"
        read data

       # Check if the input contains spaces or not
        if [[ $data =~ \  ]]; then
            echo "Error: Data cannot contain spaces."
            return
        fi
        
        
        case "${columns_datatypes[$column]}" in
            int)
                if ! [[ "$data" =~ ^[0-9]+$ ]]; then
                    echo "Error: Invalid data type for $column. Expected integer."
                    return
                fi
                ;;
            string)
                if [ -z "$data" ]; then
                   echo "Error: Data is empty."
                   return
                fi
                ;;
            *)
                echo "Error: Unknown data type for $column."
                return
                ;;
        esac

        # Save data in the array
        column_data["$column"]=$data
        
    done
    
    
    
     # Check for primary key constraint
    if [ -n "$primaryKey" ]; then
        
        primary_key_value="${column_data[$primaryKey]}"

  
        existing_primary_keys=$(cut -d ':' -f 1 "${tablename}/data")
 

       
       if [[ $existing_primary_keys == *"$primary_key_value"* ]]; then
           echo "Error: Primary key constraint violation. Duplicate value found for $primaryKey."
           return
       fi

    fi
    
    
    
    data_line=""
    for column in "${columns[@]}"; do
        data_line+="${column_data[$column]}:"
    done


    echo "$data_line" >> "${tablename}/data"

    echo "Data inserted successfully."

}


#Function to select from table
select_from_table() {
    echo "Enter table name:"
    read tablename

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi

    if [ ! -d "$tablename" ]; then
        echo "Table does not exist!"
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    

    # Show menu for selecting columns or conditions
    typeset PS3="Select Query options: "
    
    select option in "Select All" "Select with Condition" "Back to Main Menu"; do
        case $REPLY in
            1)
                echo "Selected Data: "
                echo "${columns[@]}"
                sed 's/:/ /g' "${tablename}/data"

                #cat "${tablename}/data"
                ;;
            2)
               echo "Enter column name:"
               read colname
               
               echo "Enter value of column:"
               read colvalue
               
               found=false
               feild=1
               counter=1
               
               for column in "${columns[@]}"; do
                   if [ "$column" == "$colname" ]; then
                       found=true
                       field=$counter
                       
                       break
                   fi
                   ((counter++))
               done
               
               if [ "$found" == true ]; then
               
                   echo "Selected Data: "
                   echo "${columns[@]}" 
                   awk -F':' -v field="$field" -v value="$colvalue" '$field == value' "${tablename}/data" | sed 's/:/ /g'



                   #awk -F':' -v field="$field" -v value="$colvalue" '$field == value' "${tablename}/data"
               else
                   echo "Column not found."
               fi
               
               ;;
            3)
            
                break
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac
    done
}



# Function to delete from table
delete_from_table() {
    echo "Enter table name:"
    read tablename

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi

    if [ ! -d "$tablename" ]; then
        echo "Table does not exist!"
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    

    # Show menu for deleting options
    typeset PS3="Delete Query options: "

    select option in "Delete All" "Delete with Condition" "Back to Main Menu"; do
        case $REPLY in
            1)
                
                > "${tablename}/data"
                
                echo "All data deleted successfully."
                ;;
            2)
                
                echo "Enter column name:"
                read colname

                echo "Enter value of column:"
                read colvalue

                found=false
                field=1
                counter=1

                for column in "${columns[@]}"; do
                    if [ "$column" == "$colname" ]; then
                        found=true
                        field=$counter
                        break
                    fi
                    ((counter++))
                done

                if [ "$found" == true ]; then

                    awk -F':' -v field="$field" -v value="$colvalue" '$field != value' "${tablename}/data" > "${tablename}/data_tmp"
                    mv "${tablename}/data_tmp" "${tablename}/data"
                    
                    echo "Data deleted successfully."
                else
                    echo "Column not found."
                fi
                ;;
            3)
                break
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac
    done
}



# Function to update data in a table
update_table() {
    echo "Enter table name:"
    read tablename

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        echo "Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        echo "Error: Table name cannot start with a number."
        return
    fi

    if [ ! -d "$tablename" ]; then
        echo "Table does not exist!"
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))
    
    
    declare -A columns_datatypes

    for ((i=0; i<${#columns[@]}; i++)); do
        columns_datatypes["${columns[$i]}"]="${datatypes[$i]}"
    done

    # Show menu for selecting update options
    typeset PS3="Select Update options: "

    select option in "Update All" "Update with Condition" "Back to Main Menu"; do
        case $REPLY in
            1)
               echo "Enter column name to update:"
               read update_column

               found=false
               field=1
               counter=1

               for column in "${columns[@]}"; do
                   if [ "$column" == "$update_column" ]; then
                           found=true
                           field=$counter               
                       break
                   fi
                   ((counter++))
               done

               if [ "$found" == false ]; then
                   echo "Error: Column not found."
               else
                   if [ "$update_column" == "${columns[0]}" ]; then
                       echo "Error: Cannot update the primary key column."
                   else
                       echo "Enter new value for $update_column:"
                       read new_value



               if [ -z "$new_value" ]; then
                   echo "Error: New value cannot be empty."
                   break
               fi

               if [ columns_datatypes["${update_column}"] == "int" ];then
               if ! [[ "$new_value" =~ ^[0-9]+$ ]]; then
                   echo "Error: Invalid data type for $update_column. Expected integer."
                   break
               fi

               fi


        
               awk -F':' -v field="$field" -v value="$new_value" -v OFS=':' '{ $field = value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"

                       echo "Data updated successfully."
                   fi
               fi

                
             
                ;;

            2)
                echo "Enter column name to update:"
                read update_column

                found=false
                field=1
                counter=1

                for ((i=0; i<${#columns[@]}; i++)); do
                    if [ "${columns[$i]}" == "$update_column" ]; then
                        found=true
                        field=$((i+1))
                        break
                    fi
                done

if [ "$found" == false ]; then
    echo "Error: Column not found."
else
    if [ "$update_column" == "${columns[0]}" ]; then
        echo "Error: Cannot update the primary key column."
    else
    
        echo "Enter old value for $update_column:"
        read old_value
    
        echo "Enter new value for $update_column:"
        read new_value
        

        if [ -z "$new_value" ] && [ -z "$old_value" ]; then
            echo "Error: Both new and old values cannot be empty."

        else
           
            if [ "${columns_datatypes[$update_column]}" == "int" ]; then
            
                if ! [[ "$new_value" =~ ^[0-9]+$ ]] && ! [[ "$old_value" =~ ^[0-9]+$ ]]; then
               echo "Error: Invalid data type for $update_column. Both new and old values should be integers."
                    
                else
                
                awk -F':' -v field="$field" -v old_value="$old_value" -v new_value="$new_value" -v OFS=':' '$field == old_value { $field = new_value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"

                    
#                    awk -F':' -v field="$field" -v value="$new_value" -v OFS=':' '$field == value { $field = #new_value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"
                    
                    echo "Data updated successfully."
                fi
            else
                
                awk -F':' -v field="$field" -v old_value="$old_value" -v new_value="$new_value" -v OFS=':' '$field == old_value { $field = new_value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"

#                awk -F':' -v field="$field" -v value="$new_value" -v OFS=':' '$field == value { $field = #new_value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"
                
                echo "Data updated successfully."
            fi
        fi
    fi
fi
;;

            3)
                break
                ;;
            *)
                echo "Invalid option!"
                ;;
        esac
    done
}



export -f create_table 
export -f list_tables 
export -f drop_table 
export -f insert_into_table
export -f select_from_table
export -f delete_from_table
export -f update_table

#Function to connect to a database
connect_to_database(){
	echo "Enter database name:"
    read dbname
    
    # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        echo "Error: Database name cannot contain spaces."
        return
    fi

     # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Database name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        echo "Error: Database name cannot start with a number."
        return
    fi


    if [ -d "DBMS/$dbname" ]; then
        gnome-terminal -- bash -c "
	cd DBMS/$dbname
        PS3='Select an option: '
        select option in 'Create Table' 'List Tables' 'Drop Table' 'Insert into Table' 'Select from Table' 'Delete from Table' 'Update Table' 'Exit'
        do
            case \$REPLY in
                1)
		    create_table
                    ;;
                2)
		    list_tables 
                    ;;
                3)
                    drop_table
                    ;;
                4)
		    insert_into_table
                    ;;
                5)
                    select_from_table
                    ;;
                6)
                    delete_from_table
                    ;;
                7)
                    update_table
                    ;;
                8)
                    break
                    ;;
                *)
                    echo 'Invalid option!'
                    ;;
            esac
        done
        "

    else
        echo "Database not found!"
    fi


}



# Main menu
PS3="Select an option: "
select option in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
do
    case $REPLY in
        1)
            create_database
            ;;
        2)
            list_databases
            ;;
        3)
            connect_to_database
            ;;
        4)
            drop_database
            ;;
     
        5)
            exit
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done
