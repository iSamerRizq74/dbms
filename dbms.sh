#!/bin/bash

# Configuration
DB_DIR="databases"
CURRENT_DB=""

# Main Menu
main_menu() {
    while true; do
        clear
        echo "Bash DBMS - Main Menu"
        echo "1. Create Database"
        echo "2. List Databases"
        echo "3. Connect to Database"
        echo "4. Drop Database"
        echo "5. Exit"
        read -p "Choice: " choice

        case $choice in
            1) create_db ;;
            2) list_dbs ;;
            3) connect_db ;;
            4) drop_db ;;
            5) exit 0 ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

# Database Functions
create_db() {
    read -p "Database name: " dbname
    mkdir -p "$DB_DIR/$dbname" && echo "Created" || echo "Error"
    sleep 1
}

list_dbs() {
    echo "Databases:"
    ls -1 "$DB_DIR" 2>/dev/null || echo "No databases"
    read -p "Press enter to continue..."
}

connect_db() {
    read -p "Database name: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        CURRENT_DB="$dbname"
        table_menu
    else
        echo "Database doesn't exist"
        sleep 1
    fi
}

drop_db() {
    read -p "Database to drop: " dbname
    rm -r "$DB_DIR/$dbname" 2>/dev/null && echo "Dropped" || echo "Error"
    sleep 1
}

# Table Menu
table_menu() {
    while true; do
        clear
        echo "Database: $CURRENT_DB"
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert Row"
        echo "5. View Table"
        echo "6. Delete Row"
        echo "7. Back"
        read -p "Choice: " choice

        case $choice in
            1) create_table ;;
            2) list_tables ;;
            3) drop_table ;;
            4) insert_row ;;
            5) view_table ;;
            6) delete_row ;;
            7) return ;;
            *) echo "Invalid option"; sleep 1 ;;
        esac
    done
}

# Table Functions
create_table() {
    read -p "Table name: " tname
    touch "$DB_DIR/$CURRENT_DB/$tname" && echo "Created" || echo "Error"
    sleep 1
}

list_tables() {
    echo "Tables:"
    ls -1 "$DB_DIR/$CURRENT_DB" 2>/dev/null || echo "No tables"
    read -p "Press enter to continue..."
}

drop_table() {
    read -p "Table to drop: " tname
    rm "$DB_DIR/$CURRENT_DB/$tname" 2>/dev/null && echo "Dropped" || echo "Error"
    sleep 1
}

insert_row() {
    read -p "Table name: " tname
    [ ! -f "$DB_DIR/$CURRENT_DB/$tname" ] && echo "Table doesn't exist" && sleep 1 && return
    
    read -p "Data (comma separated): " data
    echo "$data" >> "$DB_DIR/$CURRENT_DB/$tname" && echo "Inserted" || echo "Error"
    sleep 1
}

view_table() {
    read -p "Table name: " tname
    [ ! -f "$DB_DIR/$CURRENT_DB/$tname" ] && echo "Table doesn't exist" && sleep 1 && return
    
    echo "Table: $tname"
    echo "------------------------"
    cat "$DB_DIR/$CURRENT_DB/$tname" | column -t -s ","
    echo "------------------------"
    read -p "Press enter to continue..."
}

delete_row() {
    read -p "Table name: " tname
    [ ! -f "$DB_DIR/$CURRENT_DB/$tname" ] && echo "Table doesn't exist" && sleep 1 && return
    
    view_table
    read -p "Row number to delete: " row
    sed -i "${row}d" "$DB_DIR/$CURRENT_DB/$tname" && echo "Deleted" || echo "Error"
    sleep 1
}

# Initialize
mkdir -p "$DB_DIR"
main_menu

