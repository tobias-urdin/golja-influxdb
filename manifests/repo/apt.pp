# PRIVATE CLASS: do not use directly

class influxdb::repo::apt(
  $ensure = 'present',
) {

  #downcase operatingsystem
  $_operatingsystem = downcase($::operatingsystem)

  $key = {
    'id'     => '9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E',
    'source' => 'https://repos.influxdata.com/influxdata-archive_compat.key',
  }

  $include = {
    'src' => false,
  }

  apt::source { 'repos.influxdata.com':
    ensure   => $ensure,
    location => "https://repos.influxdata.com/${_operatingsystem}",
    release  => $::lsbdistcodename,
    repos    => 'stable',
    key      => $key,
    include  => $include,
  }

}
