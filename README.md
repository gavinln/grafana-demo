# Grafana demo

* Source code - [Github][1]
* Author - Gavin Noronha

[1]: https://github.com/gavinln/grafana-demo

## About

Demo the use of [Grafana][10] to visualize time series.

[10]: https://grafana.com/docs/grafana/latest/getting-started/

## Setup the project

1. Run Grafana with Clickhouse plugin

```
docker run -d \
    -p 3000:3000 \
    --name=grafana \
    -e "GF_INSTALL_PLUGINS=vertamedia-clickhouse-datasource" \
    grafana/grafana:7.5.10
```

2. Login to Grafana by open the browser to http://localhost:3000/

3. Use the admin/admin username and password

## Setup Clickhouse flight data

1. Create a view with date column

```
create view flight_dt as 
select toDate(arrayStringConcat(
   arrayMap(x -> toString(x),
            [Year, Month, DayofMonth]), '-')) as dt,
   DayOfWeek,
   DepTime,
   CRSDepTime,
   ArrTime,
   CRSArrTime,
   UniqueCarrier,
   FlightNum,
   TailNum,
   ActualElapsedTime,
   CRSElapsedTime,
   AirTime,
   ArrDelay,
   DepDelay,
   Origin,
   Dest,
   Distance,
   TaxiIn,
   TaxiOut,
   Cancelled,
   CancellationCode,
   Diverted,
   CarrierDelay,
   WeatherDelay,
   NASDelay,
   SecurityDelay,
   LateAircraftDelay
from flight
```
