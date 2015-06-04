directory "/cm/" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

remote_file "/cm/cdh5-repository_1.0_all.deb" do
   source "http://archive.cloudera.com/cdh5/one-click-install/wheezy/amd64/cdh5-repository_1.0_all.deb"
end

execute "install cdh" do
  command "sudo dpkg -i /cm/cdh5-repository_1.0_all.deb"  
end