
node["java"]["install_flavor"] = "oracle"
node["java"]["jdk_version"] = "7"
node["java"]["oracle"]["accept_oracle_download_terms"] = true

include_recipe "java"