#require 'rubygems'
require 'aws-sdk'

AWS_ACCESS_KEY_ID="AKIAIV4DS254Y3ZEOOKA"
AWS_SECRET_ACCESS_KEY="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"
AWS_REGION="eu-central-1"

#credentials = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

#s3 = Aws::S3::Client.new(region:AWS_REGION, 
#    credentials: credentials)

s3 = AWS::S3.new

# Read paths

paths_object = s3.get_object(bucket: 'spatial-impala-jars', key: "paths.json")
paths_str = paths_object.body.read
paths = JSON.parse(paths_str)



# Read the files pointed to by the paths file
classpath_str = ""

paths['s3-to-local-map'].each do |prefix, target_prefix|
	
	files = s3.list_objects(bucket: 'spatial-impala-jars', prefix: prefix).contents	
	
	files.each do |file|

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
				file_object = s3.get_object(bucket: 'spatial-impala-jars', key: file.key)
				file_content = file_object.body.read
				
				puts file.key + " ---> " + targetPath

				if prefix =~ /.*deps.*/
					classpath_str += targetPath + ":"
				end

				file targetPath do
				  content file_content
				  action :create
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
log classpath_str do
    level :info
end
