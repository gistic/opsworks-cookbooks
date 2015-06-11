directory "/cm/dep" do
  owner 'cloudera-scm'
  group 'cloudera-scm'
  action :create
end

remote_file "/cm/dep/spatialHDFSReplicator.jar" do
  source "https://s3-eu-west-1.amazonaws.com/gistic-hadoop/jars/spatialHDFSReplicator.jar"
  mode '0644'  
end

env "HADOOP_CLASSPATH" do
  attribute "/cm/dep/*" # see attributes section below
  action :modify
end