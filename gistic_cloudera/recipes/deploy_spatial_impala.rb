#require 'rubygems'
require 'aws-sdk'

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



# Read the files pointed to by the paths file
classpath_str = ""

bucket.objects.each do |file|
	paths['s3-to-local-map'].each do |prefix, target_prefix|
		if file.key.start_with? prefix

			targetPath = file.key.gsub prefix, target_prefix		

			if file.key.end_with? "/"  # Directory
				puts "Dir : " + targetPath				
				
				directory targetPath do
					mode 0755
					owner 'cloudera-scm'
					action :create
				end
			else
				puts "Reading file contents : " + file.key				
				
				file_content = file.read
				
				puts "Putting file '" + file.key + "' into ---> " + targetPath

				if prefix =~ /.*deps.*/
					classpath_str += targetPath + ":"
				end

				puts "Creating the file ... "

				file targetPath do
				  owner 'cloudera-scm'
				  group 'cloudera-scm'
				  mode '0755'
				  force_unlink true
				  content file_content
				  action :create
				end

			end

			break
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
log classpath_str do
    level :info
end
