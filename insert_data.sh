#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# traer el archivo y armar variables
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#si evito la primer fila
  if [[ $YEAR != 'year' ]]
  then
    # verificar si el team esta cargado
    TEAM_WINNER=$($PSQL "SELECT name FROM teams  WHERE name='$WINNER'")
    if [[ -z $TEAM_WINNER ]]
    then
      CARGA_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    # si está se carga el opponent
    TEAM_OPPONENT=$($PSQL "SELECT name FROM teams  WHERE name='$OPPONENT'")
    if [[ -z $TEAM_OPPONENT ]]
    then
    CARGA_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    # siguiente query
    fi


    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    VER_ROUND=$($PSQL "SELECT * FROM games WHERE winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID AND round='$ROUND'")
    if [[ -z $VER_ROUND ]]
    then
      CAR_ROUND=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
  fi
done

