#require 'rubygems'
require 'aws-sdk'

AWS_ACCESS_KEY_ID="AKIAIV4DS254Y3ZEOOKA"
AWS_SECRET_ACCESS_KEY="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"
AWS_REGION="eu-central-1"

credentials = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);

s3 = Aws::S3::Client.new(region:AWS_REGION, 
    credentials: credentials)

# Read paths

paths_object = s3.get_object(bucket: 'spatial-impala-jars', key: "paths.json")
paths_str = paths_object.body.read
paths = JSON.parse(paths_str)


# Read the files pointed to by the paths file
files = s3.list_objects(bucket: 'spatial-impala-jars').contents

files.each do |file|
	paths['s3-to-local-map'].each do |key_pattern, target_path|
		if(file.key =~ Regexp.new(key_pattern) )
			file_object = s3.get_object(bucket: 'spatial-impala-jars', key: file.key)
			file_content = file_object.body.read

			file target_path do
			  content file_content
			  action :create
			end

			break
		end		
	end  
end
