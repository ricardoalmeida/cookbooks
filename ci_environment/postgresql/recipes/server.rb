#/postgresql.conf.
# Cookbook Name:: postgresql
# Recipe:: server
#
# Copyright 2009-2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

bash "export LC_ALL and LANG for current chef-solo session/root" do
  user "root"
  code "export LC_ALL='en_US.UTF-8' LANG='en_US.UTF-8'"
end

ENV['LC_ALL'] = "en_US.UTF-8"
ENV['LANG']   = "en_US.UTF-8"


# for the current chef-solo run, it restarts PG when files like pg_hba.conf change. MK.
%w(shmmax shmall).each do |setting|
  bash "bump kernel.#{setting} to #{node[:sysctl][:kernel_shmmax]}" do
    user "root"
    code "sysctl -w kernel.#{setting}=#{node[:sysctl][:kernel_shmmax]}"
  end
end

# this take effect after reboot. MK.
template "/etc/sysctl.d/30-shared-memory.conf" do
  source "30-shared-memory.conf.erb"
  owner "root"
  group "root"
  mode 0644
end


include_recipe "postgresql::client"

case node[:postgresql][:version]
when "8.3"
  node.default[:postgresql][:ssl] = "off"
when "8.4"
  node.default[:postgresql][:ssl] = "true"
else
  node.default[:postgresql][:ssl] = "true"
end

# Include the right "family" recipe for installing the server
# since they do things slightly differently.
case node.platform
when "redhat", "centos", "fedora", "suse"
  include_recipe "postgresql::server_redhat"
when "debian", "ubuntu"
  include_recipe "postgresql::server_debian"
end



[node.travis_build_environment.user, "rails"].each do |username|
  # drop first to make sure create user is a superuser even if it wasn't initially. MK.
  bash "drop superuser #{username}" do
    user "postgres"
    code "dropuser --username postgres #{username}"
    ignore_failure true
  end
  bash "create superuser #{username}" do
    user "postgres"
    code "createuser --no-password --superuser #{username}"

    # a very lame way to make sure 2nd and other runs do not fail.
    # the proper way is to simply use a .sql script to set up users. MK.
    ignore_failure true
  end
end