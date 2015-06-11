
execute "Restart the agent so that the hostname takes effect" do
  command "service cloudera-scm-agent restart"
end