if [ ! -f ../.env ]
then
  export $(cat .env | xargs)
fi

# clean database
psql -h localhost -p 5432 -U postgres -d postgres -c 'TRUNCATE "intervalIssuanceRate","time","Funds","historicStakeData" RESTART IDENTITY CASCADE'

# publish data
psql postgres -h localhost -p 5432 -U postgres -f ./pg/time.sql
psql postgres -h localhost -p 5432 -U postgres -f ./pg/Funds.sql
psql postgres -h localhost -p 5432 -U postgres -f ./pg/historicStakeData.sql
psql postgres -h localhost -p 5432 -U postgres -f ./pg/intervalIssuanceRates.sql
