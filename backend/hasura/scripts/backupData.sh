if [ ! -f ../.env ]
then
  export $(cat .env | xargs)
fi

# get data from production db
pg_dump -Fp --data-only -h localhost -p 54321 -U postgres -d postgres -t "public.\"time\"" > ./pg/time.sql
pg_dump -Fp --data-only -h localhost -p 54321 -U postgres -d postgres -t "public.\"Funds\"" > ./pg/Funds.sql
pg_dump -Fp --data-only -h localhost -p 54321 -U postgres -d postgres -t "public.\"historicStakeData\"" > ./pg/historicStakeData.sql
pg_dump -Fp --data-only -h localhost -p 54321 -U postgres -d postgres -t "public.\"intervalIssuanceRates\"" > ./pg/intervalIssuanceRates.sql
