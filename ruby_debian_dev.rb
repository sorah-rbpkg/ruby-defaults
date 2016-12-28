module RubyDebianDev

  RUBY_INTERPRETERS = {}

  def self.has_support_for(ruby)
    RUBY_INTERPRETERS[ruby] = yield
  end

  has_support_for 'ruby2.4' do
    {
      version:             '2.4',
      binary:              '/usr/bin/ruby2.4',
      api_version:         '2.4.0',
      shared_library:      'libruby2.4',
      min_ruby_dependency: 'ruby (>= 1:2.4~0)',
    }
  end

  def self.min_ruby_dependency_for(shared_library)
    RUBY_INTERPRETERS.each do |int,data|
      if data[:shared_library] == shared_library
        return data[:min_ruby_dependency]
      end
    end
    return nil
  end

  #################################################################
  # These constants below are kept here for backwards compatibility
  #################################################################
  SUPPORTED_RUBY_VERSIONS = RUBY_INTERPRETERS.keys.inject({}) do |supported,interpreter|
    supported[interpreter] = RUBY_INTERPRETERS[interpreter][:binary]
    supported
  end

  RUBY_CONFIG_VERSION = RUBY_INTERPRETERS.keys.inject({}) do |supported,interpreter|
    supported[interpreter] = RUBY_INTERPRETERS[interpreter][:version]
    supported
  end

  RUBY_API_VERSION = RUBY_INTERPRETERS.keys.inject({}) do |supported,interpreter|
    supported[interpreter] = RUBY_INTERPRETERS[interpreter][:api_version]
    supported
  end

  SUPPORTED_RUBY_SHARED_LIBRARIES = RUBY_INTERPRETERS.map { |k,v| v[:shared_library] }

end
