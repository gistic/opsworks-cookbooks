require 'resolv'

execute "backup the dfs dir" do
  command "cp -rf /mnt/dfs /home/ubuntu/dfs-backup"
end