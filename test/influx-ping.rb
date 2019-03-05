describe command('curl -I http://GCP_INFLUX:8086/ping') do
  its('stdout') { should match /No Content/ }
end
