describe command('lsblk') do
  its('stdout') { should match /sdb/ }
  its('stdout') { should match /sdc/ }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

