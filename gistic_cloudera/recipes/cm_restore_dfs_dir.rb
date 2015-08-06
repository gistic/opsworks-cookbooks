require 'resolv'

execute "backup the dfs dir" do
  command "cp -rf /home/ubuntu/dfs-backup /mnt/dfs"
  command "rm -rf /home/ubuntu/dfs-backup"
  command "chown cloudera-scm:cloudera-scm /mnt/dfs"
end