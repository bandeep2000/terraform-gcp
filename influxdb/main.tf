provider "influxdb" {
  url      = "http://35.203.162.246:8086"
}

resource "influxdb_database" "metrics" {
  name = "awesome_app"
}

/*resource "influxdb_continuous_query" "minnie" {
  name     = "minnie"
  database = "${influxdb_database.metrics.name}"
  query    = "SELECT min(mouse) INTO min_mouse FROM zoo GROUP BY time(30m)"
}
*/

resource "influxdb_user" "paul" {
  name     = "paul"
  password = "super-secret"
}
