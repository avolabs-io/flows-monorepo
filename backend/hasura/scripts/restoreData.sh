if [ ! -f ../.env ]
then
  export $(cat .env | xargs)
fi

# clean database
psql -h localhost -p 5432 -U postgres -d postgres -c 'TRUNCATE "intervalIssuanceRate","time","Funds","historicStakeData" RESTART IDENTITY CASCADE'

# publish data (for now just an example, put the real tables in)
psql postgres -h localhost -p 5432 -U postgres -f ./pg/exampleTable.sql
