#require 'rubygems'
require 'aws-sdk'
include_recipe 'aws'

#credentials = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

#s3 = Aws::S3::Client.new(region:AWS_REGION, 
#    credentials: credentials)

s3 = AWS::S3.new

# Read paths

#paths_object = s3.get_object(bucket: 'spatial-impala-jars', key: "paths.json")
bucket = s3.buckets['spatial-impala-deploy']
paths_object = bucket.objects['paths.json']
paths_str = paths_object.read
paths = JSON.parse(paths_str)

Chef::Log.level = :debug

# Read the files pointed to by the paths file
classpath_str = ""

bucket.objects.each do |file|
	paths['s3-to-local-map'].each do |prefix, target_prefixes|
		target_prefixes.each do |target_prefix|
			if file.key.start_with? prefix

				targetPath = file.key.gsub prefix, target_prefix		

				if file.key.end_with? "/"  # Directory
					puts "Dir : " + targetPath				
					
					directory targetPath do
						mode 0755
						recursive true
						owner 'cloudera-scm'
						action :create
					end
				else
					puts "Reading file contents : " + file.key												
					
					puts "Putting file '" + file.key + "' into ---> " + targetPath

					if prefix =~ /.*deps.*/
						classpath_str += targetPath + ":"
					end

					puts "Creating the file ... "

					remote_file targetPath do
						source file.url_for(:read, :expires => 6000).to_s.gsub(/https:\/\/([\w\.\-]*)\.{1}s3.amazonaws.com:443/, 'https://s3.amazonaws.com:443/\1') # Fix for ssl cert issue
					  	action :create
					  	owner 'cloudera-scm'
					  	group 'cloudera-scm'
					  	mode '0755'
					end

				end
			end
		end
	end
end

paths['configurations-dirs'].each do |dir|
	classpath_str += dir + ":"
end 

logs_msg = "########################################################################\n"
logs_msg += "##################                                  ####################\n"
logs_msg += "##################      SpatialImpala deps          ####################\n"
logs_msg += "##################                                  ####################\n"
logs_msg += "########################################################################\n"
logs_msg += "\n"
logs_msg += ""
logs_msg += "CLASSPATH String"
logs_msg += ""
logs_msg += classpath_str
log logs_msg do
    level :info
end
