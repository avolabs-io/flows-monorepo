if [ ! -f ../.env ]
then
  export $(cat .env | xargs)
fi

# get data from production db (for now just an example, put the real tables in)
pg_dump -Fp --data-only -h localhost -p 54321 -U postgres -d postgres -t "public.\"exampleTable\"" > ./pg/exampleTable.sql
