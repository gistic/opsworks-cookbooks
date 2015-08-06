require 'resolv'

execute "backup the dfs dir" do
  command "cp -rf /home/ubuntu/dfs-backup /mnt/dfs"
  command "chown cloudera-scm:cloudera-scm /mnt/dfs"
end