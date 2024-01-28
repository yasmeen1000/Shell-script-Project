#!/bin/bash

#If condition to check if the file of application exist or not
if [ ! -d "DBMS" ]; 
then
	mkdir "DBMS"
fi


# Function to create a database
create_database() {
    # Use Zenity for input
    dbname=$(zenity --entry --width=500 --height=200 --title="Create Database" --text="Enter database name:")

    # Check if the user clicked Cancel
    if [[ $? -eq 1 ]]; then
        return
    fi

    # Check if the input is empty
    if [[ -z $dbname ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot be empty." --width=500 --height=200
        return
    fi

    # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot contain spaces."--width=500 --height=200
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --title="Error" --text="Error: Database name can only contain alphanumeric characters and underscores." --width=300 --height=100
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot start with a number." --width=500 --height=200
        return
    fi

    # Check if the database directory exists
    if [ -d "DBMS/$dbname" ]; then
        zenity --info --title="Info" --text="Database already exists!" --width=500 --height=200
    else
        mkdir "DBMS/$dbname/"
        zenity --info --title="Success" --text="Database created successfully!" --width=500 --height=200
    fi
}




# Function to list databases
list_databases() {
    # Get the list of databases
    databases=$(ls -F DBMS/ | grep '/' | sed 's/\///')

    # Check if there are no databases
    if [ -z "$databases" ]; then
        zenity --info  --width=500 --height=200 --title="List Databases" --text="No databases found."
        return
    fi

    # Display the list of databases using Zenity
    zenity --list --width=500 --height=200 --title="List Databases" --column="Databases" $databases 
}



# Function to drop databases
drop_database() {
    # Use Zenity for input
    dbname=$(zenity --entry --width=500 --height=200 --title="Drop Database" --text="Enter database name:")

    # Check if the user clicked Cancel
    if [[ $? -eq 1 ]]; then
        return
    fi

    # Check if the input is empty
    if [[ -z $dbname ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Database name cannot be empty."
        return
    fi

    # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Database name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Database name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Database name cannot start with a number." 
        return
    fi

    # Check if the database directory exists
    if [ -d "DBMS/$dbname" ]; then
        # Remove the database directory
        rm -r "DBMS/$dbname/"
        zenity --info --width=500 --height=200 --title="Success" --text="Database $dbname dropped successfully!"
    else
        zenity --error --width=500 --height=200 --title="Error" --text="Database not found!"
    fi
}


# Function to create a table 
create_table() {
    tablename=$(zenity --entry --width=500 --height=200 --text="Enter table name:" )

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        zenity --error --text="Error: Table name cannot contain spaces."--width=500 --height=200
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Error: Table name can only contain alphanumeric characters and underscores."--width=500 --height=200
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --text="Error: Table name cannot start with a number."--width=500 --height=200
        return
    fi

    if [ -d "$tablename" ]; then
        zenity --error --text="Table already exists!"--width=500 --height=200
        return
    fi

    num_columns=$(zenity --entry --width=500 --height=200 --text="Enter the number of columns:")

    if ! [[ "$num_columns" =~ ^[0-9]+$ ]]; then
        zenity --error --text="Error: Invalid number of columns!"--width=500 --height=200
        return
    fi
    
    if [ "$num_columns" -eq 0 ]; then
        zenity --error --text="Error: You cannot create a table with 0 columns."--width=500 --height=200
        return
    fi

    declare -a columns
    declare -a datatypes
    primarykey=""

    for ((i=1; i<=num_columns; i++))
    do
        column_name=$(zenity --entry --width=500 --height=200 --text="Enter column $i name:")

        # Validate column name
        if [[ $column_name =~ \  ]]; then
            zenity --error --text="Error: Column name cannot contain spaces."--width=500 --height=200
            return
        fi

        if [[ ! $column_name =~ ^[a-zA-Z0-9_]+$ ]]; then
            zenity --error --text="Error: Column name can only contain alphanumeric characters and underscores."--width=500 --height=200
            return
        fi

        # Check if the input starts with a number or not
        if [[ $column_name =~ ^[0-9] ]]; then
           zenity --error --text="Error: Table name cannot start with a number."--width=500 --height=200
           return
        fi

        # Column DataType
        column_datatype=$(zenity --entry --width=500 --height=200 --text="Enter column $i datatype (int or string):" )

        # Validate column datatype
        if [[ ! "$column_datatype" =~ ^(int|string)$ ]]; then
            zenity --error --text="Error: Invalid datatype, must be 'int' or 'string'."--width=500 --height=200
            return
        fi

        if [ $i == 1 ]; then
           primarykey=$column_name
        fi

        columns+=("$column_name")
        datatypes+=("$column_datatype")
    done

    mkdir "${tablename}"

    echo "PrimaryKey:${primarykey}" >> "${tablename}/meta"
    echo "Columns:${columns[@]}" >> "${tablename}/meta"
    echo "Datatypes:${datatypes[@]}" >> "${tablename}/meta"
    touch "${tablename}/data"

    zenity --info --width=500 --height=200 --text="Table created successfully!"
}

# Function to list tables 
list_tables() {
    tables=$(ls -F | grep '/' | sed 's/\///')
    zenity --list --width=500 --height=200 --title="List Tables:" --column="Tables:" $tables 
}
    


# Function to drop a table
drop_table() {
    tablename=$(zenity --entry --width=500 --height=200 --text="Enter table name:")

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        zenity --error --width=500 --height=200 --text="Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --width=500 --height=200 --text="Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --width=500 --height=200 --text="Error: Table name cannot start with a number."
        return
    fi

    if [ -d "$tablename" ]; then
        rm -r "$tablename"
        zenity --info --width=500 --height=200 --title="Success" --text="Table dropped successfully!"
    else
        zenity --info --width=500 --height=200 --title="Error" --text="Table not found!"
    fi
}

#Function to insert into table
insert_into_table() {
    tablename=$(zenity --entry --width=500 --height=200 --text="Enter table name:")

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        zenity --error --text="Error: Table name cannot contain spaces."--width=500 --height=200
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Error: Table name can only contain alphanumeric characters and underscores."--width=500 --height=200
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --text="Error: Table name cannot start with a number."--width=500 --height=200
        return
    fi
    
    if [ ! -d "$tablename" ]; then
        zenity --error --text="Table does not exist!"--width=500 --height=200
        return
    fi
    
    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    declare -A columns_datatypes

    for ((i=0; i<${#columns[@]}; i++)); do
        columns_datatypes["${columns[$i]}"]="${datatypes[$i]}"
    done

    declare -A column_data

    for column in "${columns[@]}"; do
        data=$(zenity --entry --width=500 --height=200 --text="Enter data for $column (${columns_datatypes[$column]}):" )

        # Check if the input contains spaces or not
        if [[ $data =~ \  ]]; then
            zenity --error --text="Error: Data cannot contain spaces."--width=500 --height=200
            return
        fi
        
        case "${columns_datatypes[$column]}" in
            int)
                if ! [[ "$data" =~ ^[0-9]+$ ]]; then
                    zenity --error --text="Error: Invalid data type for $column. Expected integer."--width=500 --height=200
                    return
                fi
                ;;
            string)
                if [ -z "$data" ]; then
                    zenity --error --text="Error: Data is empty."--width=500 --height=200
                    return
                fi
                ;;
            *)
                zenity --error --text="Error: Unknown data type for $column."--width=500 --height=200
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

        if [[ $existing_primary_keys == "$primary_key_value" ]]; then
            zenity --error --text="Error: Primary key constraint violation. Duplicate value found for $primaryKey."--width=500 --height=200
            return
        fi
    fi
    
    data_line=""
    for column in "${columns[@]}"; do
        data_line+="${column_data[$column]}:"
    done

    echo "$data_line" >> "${tablename}/data"

    zenity --info --width=500 --height=200 --title="Success" --text="Data inserted successfully."
}


# Function to select from table
select_from_table() {
    # Use Zenity for input
    tablename=$(zenity --entry --width=500 --height=200 --title="Select from Table" --text="Enter table name:")

    # Check if the user clicked Cancel
    if [[ $? -eq 1 ]]; then
        return
    fi

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --width=500 --height=200  --title="Error" --text="Error: Table name cannot start with a number."
        return
    fi

    if [ ! -d "$tablename" ]; then
        zenity --error --width=500 --height=200  --title="Error" --text="Table does not exist!"
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    # Show menu for selecting columns or conditions
    option=$(zenity --list --width=500 --height=200  --title="Select Query Options" --column="Options" "Select All" "Select with Condition" "Back to Main Menu")

    case $option in
        "Select All")
            result=$(awk 'BEGIN {OFS=" "} {gsub(/:/, " ")} NR > 1 {print $0}' "${tablename}/data")
            zenity --info --width=500 --height=200  --title="Selected Data" --text="${columns[@]}\n$result"
            ;;
        "Select with Condition")
            colname=$(zenity --entry --width=500 --height=200 --title="Select with Condition" --text="Enter column name:")
            
            # Check if the user clicked Cancel
            if [[ $? -eq 1 ]]; then
                return
            fi

            colvalue=$(zenity --entry --width=500 --height=200 --title="Select with Condition" --text="Enter value of column:")

            # Check if the user clicked Cancel
            if [[ $? -eq 1 ]]; then
                return
            fi

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
                result=$(awk -F':' -v field="$field" -v value="$colvalue" '$field == value' "${tablename}/data" | awk 'BEGIN {OFS=" "} {gsub(/:/, " ")} NR > 1 {print $0}')
                zenity --info --width=500 --height=200 --title="Selected Data" --text="${columns[@]}\n$result"
            else
                zenity --error --width=500 --height=200 --title="Error" --text="Column not found."
            fi
            ;;
        "Back to Main Menu")
            return
            ;;
        *)
            zenity --error --width=500 --height=200 --title="Error" --text="Invalid option!"
            ;;
    esac
}

# Function to delete from table
delete_from_table() {
    # Use Zenity for input
    tablename=$(zenity --entry --width=500 --height=200 --title="Delete from Table" --text="Enter table name:")

    # Check if the user clicked Cancel
    if [[ $? -eq 1 ]]; then
        return
    fi

    # Check if the input contains spaces or not
    if [[ $tablename =~ \  ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Table name cannot contain spaces."
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Table name can only contain alphanumeric characters and underscores."
        return
    fi

    # Check if the input starts with a number or not
    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Error: Table name cannot start with a number."
        return
    fi

    if [ ! -d "$tablename" ]; then
        zenity --error --width=500 --height=200 --title="Error" --text="Table does not exist!"
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    # Show menu for deleting options
    option=$(zenity --list --width=500 --height=200  --title="Delete Query Options" --column="Options" "Delete All" "Delete with Condition" "Back to Main Menu")

    case $option in
        "Delete All")
            zenity --question --width=500 --height=200  --title="Delete Confirmation" --text="Are you sure you want to delete all data from the table?" --ok-label="Yes" --cancel-label="No"
            response=$?
            if [[ $response -eq 0 ]]; then
                > "${tablename}/data"
                zenity --info  --width=500 --height=200  --title="Success" --text="All data deleted successfully."
            else
                zenity --info --width=500 --height=200 --title="Info" --text="Deletion canceled."
            fi
            ;;
        "Delete with Condition")
            colname=$(zenity --entry --width=500 --height=200 --title="Delete with Condition" --text="Enter column name:")

            # Check if the user clicked Cancel
            if [[ $? -eq 1 ]]; then
                return
            fi

            colvalue=$(zenity --entry --width=500 --height=200  --title="Delete with Condition" --text="Enter value of column:")

            # Check if the user clicked Cancel
            if [[ $? -eq 1 ]]; then
                return
            fi

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
                zenity --question --width=500 --height=200 --title="Delete Confirmation" --text="Are you sure you want to delete data with condition?" --ok-label="Yes" --cancel-label="No"
                response=$?
                if [[ $response -eq 0 ]]; then
                    awk -F':' -v field="$field" -v value="$colvalue" '$field != value' "${tablename}/data" > "${tablename}/data_tmp"
                    mv "${tablename}/data_tmp" "${tablename}/data"
                    zenity --info --width=500 --height=200 --title="Success" --text="Data deleted successfully."
                else
                    zenity --info --width=500 --height=200 --title="Info" --text="Deletion canceled."
                fi
            else
                zenity --error --width=500 --height=200 --title="Error" --text="Column not found."
            fi
            ;;
        "Back to Main Menu")
            return
            ;;
        *)
            zenity --error --width=500 --height=200 --title="Error" --text="Invalid option!"
            ;;
    esac
}



update_table() {
    tablename=$(zenity --entry --width=500 --height=200 --title="Update from Table" --text="Enter table name:" 2>/dev/null)

    if [[ $tablename =~ \  ]]; then
        zenity --error --text="Error: Table name cannot contain spaces." 2>/dev/null
        return
    fi

    if [[ ! $tablename =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --text="Error: Table name can only contain alphanumeric characters and underscores." 2>/dev/null
        return
    fi

    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --text="Error: Table name cannot start with a number." 2>/dev/null
        return
    fi

    if [ ! -d "$tablename" ]; then
        zenity --error --text="Table does not exist!" 2>/dev/null
        return
    fi

    primaryKey=$(grep "PrimaryKey" "${tablename}/meta" | awk -F':' '{print $2}' | tr -d '[:space:]')
    columns=($(grep "Columns" "${tablename}/meta" | awk -F':' '{print $2}'))
    datatypes=($(grep "Datatypes" "${tablename}/meta" | awk -F':' '{print $2}'))

    declare -A columns_datatypes

    for ((i=0; i<${#columns[@]}; i++)); do
        columns_datatypes["${columns[$i]}"]="${datatypes[$i]}"
    done

    while true; do
        choice=$(zenity --list --title="Update Table" --text="Select Update options:" --radiolist --column="" --column="Options" FALSE "Update All" FALSE "Update with Condition" FALSE "Back to Main Menu" 2>/dev/null)

        case "$choice" in
            "Update All")
                update_column=$(zenity --entry --width=500 --height=200 --text="Enter column name to update:" 2>/dev/null)

                if [ -z "$update_column" ]; then
                    zenity --error --text="Error: Column name cannot be empty." 2>/dev/null
                    continue
                fi

                new_value=$(zenity --entry --width=500 --height=200 --text="Enter new value for $update_column:" 2>/dev/null)

                if [ -z "$new_value" ]; then
                    zenity --error --text="Error: New value cannot be empty." 2>/dev/null
                    continue
                fi

                if [ "${columns_datatypes["${update_column}"]}" == "int" ]; then
                    if ! [[ "$new_value" =~ ^[0-9]+$ ]]; then
                        zenity --error --text="Error: Invalid data type for $update_column. Expected integer." 2>/dev/null
                        continue
                    fi
                fi

                field=1
                counter=1

                for column in "${columns[@]}"; do
                    if [ "$column" == "$update_column" ]; then
                        break
                    fi
                    ((counter++))
                done

                awk -F':' -v field="$field" -v value="$new_value" -v OFS=':' '{ $field = value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"

                zenity --info --width=500 --height=200 --text="Data updated successfully." 2>/dev/null
                ;;

            "Update with Condition")
                update_column=$(zenity --entry --width=500 --height=200 --text="Enter column name to update:" 2>/dev/null)

                if [ -z "$update_column" ]; then
                    zenity --error --text="Error: Column name cannot be empty." 2>/dev/null
                    continue
                fi

                old_value=$(zenity --entry --width=500 --height=200 --text="Enter old value for $update_column:" 2>/dev/null)

                if [ -z "$old_value" ]; then
                    zenity --error --text="Error: Old value cannot be empty." 2>/dev/null
                    continue
                fi

                new_value=$(zenity --entry --width=500 --height=200 --text="Enter new value for $update_column:" 2>/dev/null)

                if [ -z "$new_value" ]; then
                    zenity --error --text="Error: New value cannot be empty." 2>/dev/null
                    continue
                fi

                field=1
                counter=1

                for ((i=0; i<${#columns[@]}; i++)); do
                    if [ "${columns[$i]}" == "$update_column" ]; then
                        field=$((i+1))
                        break
                    fi
                done

                if [ "$update_column" == "${columns[0]}" ]; then
                    zenity --error --text="Error: Cannot update the primary key column." 2>/dev/null
                    continue
                fi

                if [ "${columns_datatypes["$update_column"]}" == "int" ]; then
                    if ! [[ "$new_value" =~ ^[0-9]+$ ]] && ! [[ "$old_value" =~ ^[0-9]+$ ]]; then
                        zenity --error --text="Error: Invalid data type for $update_column. Both new and old values should be integers." 2>/dev/null
                        continue
                    fi
                fi

                awk -F':' -v field="$field" -v old_value="$old_value" -v new_value="$new_value" -v OFS=':' '$field == old_value { $field = new_value }1' "${tablename}/data" > tmpfile && mv tmpfile "${tablename}/data"

                zenity --info --width=500 --height=200 --text="Data updated successfully." 2>/dev/null
                ;;

            "Back to Main Menu")
                break
                ;;
            *)
                zenity --error --text="Invalid option!" 2>/dev/null
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
# Function to connect to a database
connect_to_database() {
    # Use Zenity for input
    dbname=$(zenity --entry --width=500 --height=200 --title="Connect to Database" --text="Enter database name:")

    # Check if the user clicked Cancel
    if [[ $? -eq 1 ]]; then
        return
    fi

    # Check if the input is empty
    if [[ -z $dbname ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot be empty." --width=500 --height=200
        return
    fi

    # Check if the input contains spaces or not
    if [[ $dbname =~ \  ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot contain spaces." --width=500 --height=200
        return
    fi

    # Check if the input contains special characters or not
    if [[ ! $dbname =~ ^[a-zA-Z0-9_]+$ ]]; then
        zenity --error --title="Error" --text="Error: Database name can only contain alphanumeric characters and underscores." --width=300 --height=100
        return
    fi

    # Check if the input starts with a number or not
    if [[ $dbname =~ ^[0-9] ]]; then
        zenity --error --title="Error" --text="Error: Database name cannot start with a number." --width=500 --height=200
        return
    fi

    if [ -d "DBMS/$dbname" ]; then
        # Open a new terminal tab for the database options
        gnome-terminal --tab -- bash -c "
        cd DBMS/$dbname
        while true; do
            # Present options using Zenity
            option=\$(zenity --list --width=600 --height=400 --title=\"Database Management ($dbname)\" --column=\"Options\" \"Create Table\" \"List Tables\" \"Drop Table\" \"Insert into Table\" \"Select from Table\" \"Delete from Table\" \"Update Table\" \"Exit\" --width=400 --height=200 --cancel-label="Back")

            # Check if the user clicked Cancel
            if [[ \$? -eq 1 ]]; then
                break
            fi

            case \$option in
                \"Create Table\")
                    create_table
                    ;;
                \"List Tables\")
                    list_tables;
                    ;;
                \"Drop Table\")
                    drop_table
                    ;;
                \"Insert into Table\")
                    insert_into_table
                    ;;
                \"Select from Table\")
                    select_from_table
                    ;;
                \"Delete from Table\")
                    delete_from_table
                    ;;
                \"Update Table\")
                    update_table
                    ;;
                \"Exit\")
                    break
                    ;;
                *)
                    zenity --error --title=\"Error\" --text=\"Invalid option!\"
                    ;;
            esac
        done
        "
    else
        zenity --error --title="Error" --text="Database not found!"--width=300 --height=100
    fi
}




# Main menu loop
while true; do
    option=$(zenity --list --title="Database Management" --column="Options" "Create Database" "List Databases" "Connect To Database" "Drop Database" "Execute SQL Command" "Exit" --width=700 --height=500 --cancel-label="Exit")

    # Check if the user clicked Cancel or closed the window
    if [[ $? -ne 0 ]]; then
        exit 0
    fi

    case $option in
        "Create Database")
            create_database
            ;;
        "List Databases")
            list_databases
            ;;
        "Connect To Database")
            connect_to_database
            ;;
        "Drop Database")
            drop_database
            ;;
        "Execute SQL Command")
         sql_command=$(zenity --text-info --width=500 --height=200 --title="Execute SQL Command" --editable)
            execute_sql_command "$sql_command"
            ;;

        "Exit")
            exit 0
            ;;
        *)
            zenity --error --title="Error" --text="Invalid option!"
            ;;
    esac
done

