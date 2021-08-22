# Grafana demo

* Source code - [Github][1]
* Author - Gavin Noronha

[1]: https://github.com/gavinln/grafana-demo

## About

Demo the use of [Grafana][10] to visualize time series.

[10]: https://grafana.com/docs/grafana/latest/getting-started/

## Setup the project

### Install Grafana


1. Install pre-requisites

```bash
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
```

2. Install Grafana repositories

```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

3. Install Grafana

```bash
sudo apt-get update
sudo apt-get install grafana=7.5.10
```

4. Start Grafana

```
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server.service
sudo systemctl status grafana-server
```

5. Install the Clickhouse Grafana plugin

```bash
sudo grafana-cli plugins install vertamedia-clickhouse-datasource
```

6. Restart Grafana:

```
sudo systemctl restart grafana-server
```

### Setup Grafana

1. Login to Grafana by open the browser to http://localhost:3000/

3. Use the admin/admin username and password

4. Click on the configuration option (on the left) and data sources

5. Click on add data sources and select Clickhouse

6. Enter the URL as http://localhost:8123

7. Click "Save and Test"

## Setup Clickhouse flight data

https://docs.altinity.com/integrations/clickhouse-and-grafana/

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

2. Set up Grafana variables

```
--database-- : default
--table-- : flight_dt
Column:DateTime: toDateTime(dt)
```

3. Create query for Grafana

```sql
SELECT
    $timeSeries as t,
    UniqueCarrier,
    count() as Flights
FROM $table
WHERE $timeFilter
GROUP BY t, UniqueCarrier
ORDER BY t, UniqueCarrier
```

4. The generated SQL will be

```sql
SELECT
    (intDiv(toUInt32(toDateTime(dt)), 86400) * 86400) * 1000 as t,
    UniqueCarrier,
    count() as Flights
FROM default.flight_dt
WHERE toDateTime(dt) >= toDateTime(940273200) AND toDateTime(dt) <= toDateTime(945630000)
GROUP BY t, UniqueCarrier
ORDER BY t, UniqueCarrier
```

5. Make debugging easy by visualizing as a "Table" before using a "Graph" or
   "Time series"
