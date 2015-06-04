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

template "/etc/pam.d/su" do
  source "pam.erb"    
  user "root"
  group "root"
  mode 0440
end


