module SousChef
  module Resource
    autoload :Base,      'sous_chef/resource/base'
    autoload :Directory, 'sous_chef/resource/directory'
    autoload :Execute,   'sous_chef/resource/execute'
    autoload :File,      'sous_chef/resource/file'
    autoload :Gemfile,   'sous_chef/resource/gemfile'
    autoload :Log,       'sous_chef/resource/log'
  end
end
