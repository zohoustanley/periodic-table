#!/bin/bash
#Check if argument is provided
if [[ $# -eq 0 ]]
    then echo -e "Please provide an element as an argument."
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
  
  #Check if argument is a number 
  if [[ "$1" =~ ^[0-9]+$ ]]
    then 
      #If number, make request on atomic number
      ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1 ");
   else
    ELEMENT_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1' ");
  fi
  
  #Check if result is found
  if [[ -z $ELEMENT_RESULT ]]
    then echo -e "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | while IFS="|" read atomic_number symbol name TYPE atomic_mass melting_point_celsius boiling_point_celsius
    do
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $TYPE, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done
  fi
fi