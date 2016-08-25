current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'chefroot'
client_key               "#{current_dir}/chefroot.pem"
#validation_client_name   'chef-validator'
validation_client_name   'demoorg-validator'
validation_key           "#{current_dir}/demoorg-validator.pem"
chef_server_url          'https://chefserver01.example.com/organizations/demoorg'
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
