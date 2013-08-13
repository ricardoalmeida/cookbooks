#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, Example Com
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
case node[:platform]
when "debian", "ubuntu"
    package "tomcat7" do
        action :install
    end

    # configuring tomcat
    template "/var/lib/tomcat7/conf/Catalina/localhost/solr.xml" do
        source "tomcat_solr.xml.erb"
        owner "root"
        group "tomcat7"
        mode "0664"
    end

    # creating solr home and solr core
    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}" do
        owner "root"
        group "tomcat7"
        mode "0777"
        action :create
        recursive true
    end

    directory "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf" do
        owner "root"
        group "tomcat7"
        mode "0777"
        action :create
    end

    # configuring solr
    template "#{node[:solr][:home]}/solr.xml" do
        source "solr.xml.erb"
        owner "root"
        group "root"
        mode "0664"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/solrconfig.xml" do
        source "solrconfig.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/schema.xml" do
        source "schema.xml.erb"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/var/lib/tomcat7/webapps/solr.war" do
        source "solr.war"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/jcl-over-slf4j-1.6.6.jar" do
        source "jars/jcl-over-slf4j-1.6.6.jar"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/jul-to-slf4j-1.6.6.jar" do
        source "jars/jul-to-slf4j-1.6.6.jar"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/log4j-1.2.16.jar" do
        source "jars/log4j-1.2.16.jar"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/slf4j-api-1.6.6.jar" do
        source "jars/slf4j-api-1.6.6.jar"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/slf4j-log4j12-1.6.6.jar" do
        source "jars/slf4j-log4j12-1.6.6.jar"
        owner "root"
        group "root"
        mode "0644"
    end

    cookbook_file "/usr/share/tomcat7/lib/log4j.properties" do
        source "jars/log4j.properties"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/elevate.xml" do
        source "elevate.xml"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/protwords.txt" do
        source "protwords.txt"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/scripts.conf" do
        source "scripts.conf"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/stopwords.txt" do
        source "stopwords.txt"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/synonyms.txt" do
        source "synonyms.txt"
        owner "root"
        group "root"
        mode "0644"
    end

    template "#{node[:solr][:home]}/#{node[:solr][:core_name]}/conf/spellings.txt" do
        source "spellings.txt"
        owner "root"
        group "root"
        mode "0644"
    end
end
