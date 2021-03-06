include_recipe "applications::default"

::RBENV_HOME = "#{node['current_user']['dir']}/.rbenv"
::RBENV_COMMAND = "/usr/local/bin/rbenv"

package "rbenv" do
  action [:install, :upgrade]
end

package "ruby-build" do
  action [:install, :upgrade]
end

dotfiles_bash_it_enable_feature "plugins/rbenv"

node["rbenv"]["rubies"].each do |version, options|
  rbenv_ruby_install version do
    options options
  end
end

execute "making #{node["rbenv"]["default_ruby"]} with rbenv the default" do
  not_if { node["rbenv"]["default_ruby"].nil? }
  command "rbenv global #{node["rbenv"]["default_ruby"]}"
  user node['current_user']
end
