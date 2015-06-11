directory "/cm/dep" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

remote_file "/cm/dep/spatialHDFSReplicator.jar" do
  source "https://s3-eu-west-1.amazonaws.com/gistic-hadoop/jars/spatialHDFSReplicator.jar"
  mode '0644'  
end

template "/etc/profile.d/setup_gistic_hadoop_classpath.sh" do
  source "setup_gistic_hadoop_classpath.erb"      
  mode "0644"
end