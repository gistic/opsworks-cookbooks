require 'resolv'

user "cloudera-scm" do   
  system true
  shell '/bin/bash'
  action :create
end

user "vagrant" do   
  system true
  shell '/bin/bash'
  action :create
end

execute "make cloudera-scm a sudoer" do
  command "usermod -a -G sudo cloudera-scm"
  command "usermod -a -G sudo vagrant"
end

template "/etc/sudoers" do
  source "sudoers.erb"    
  user "root"
  group "root"
  mode 0440
end

directory "/mnt/" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

directory "/cm/" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

directory "/var/lib/sqoop2" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

directory "/var/lib/oozie" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

directory "/var/lib/solr" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

directory "/var/lib/hadoop-httpfs" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

template "/etc/pam.d/su" do
  source "pam.erb"    
  user "root"
  group "root"
  mode 0440
end


template '/etc/hosts' do
  source "hosts.erb"
  mode "0644"
  variables(
    :localhost_name => node[:opsworks][:instance][:hostname],
    :nodes => search(:node, "name:*")
  )
end

template '/etc/hostname' do
  source "hostname.erb"
  mode "0644"
  variables(
    :localhost_name => node[:opsworks][:instance][:hostname]
  )
end

execute "Change the hostname" do
  command "sudo hostname -F /etc/hostname"
end

