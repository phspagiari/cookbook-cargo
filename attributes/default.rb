default[:cargo][:os][:packages] = [ "git", "bzr", "nginx-full" ]
default[:cargo][:docker][:images] = [ "flynn/slugbuilder", "flynn/slugrunner" ]
default[:cargo][:go][:packages] = [ "github.com/flynn/gitreceive-next/gitreceived", "github.com/rochacon/cargo" ]
default[:cargo][:home] = "/home/git"
default[:cargo][:user] = "git"
default[:cargo][:group] = "docker"
default[:cargo][:dirs] = [ ".ssh", "keys", "hosts", "repositories" ]
default[:cargo][:port] = "2222"
default[:cargo][:bucket] = nil
default[:cargo][:aws_access_key] = ""
default[:cargo][:aws_secret_key] = ""
default[:cargo][:base_domain] = "localhost"
default[:cargo][:server_locaton] = "#{node[:cargo][:home]}/hosts/*.conf"

