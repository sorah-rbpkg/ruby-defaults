module RubyDebianDev

  RUBY_INTERPRETERS = {}

  def self.has_support_for(ruby)
    RUBY_INTERPRETERS[ruby] = yield
  end

  # XXX the default Ruby must come first here

  has_support_for 'ruby3.0' do
    {
      version:             '3.0',
      binary:              '/usr/bin/ruby3.0',
      api_version:         '3.0.0',
      shared_library:      'libruby3.0',
      min_ruby_version:    '1:3.0~0',
      ruby_upper_bound:    '1:3.1~',
    }
  end

  has_support_for 'ruby3.1' do
    {
      version:             '3.1',
      binary:              '/usr/bin/ruby3.1',
      api_version:         '3.1.0',
      shared_library:      'libruby3.1',
      min_ruby_version:    '1:3.1~0',
      ruby_upper_bound:    '1:3.2~',
    }
  end

  def self.min_ruby_dependency_for(shared_library)
    RUBY_INTERPRETERS.each do |int,data|
      if data[:shared_library] == shared_library
        return "libruby (>= %s)" % data[:min_ruby_version]
      end
    end
    return nil
  end

  def self.ruby_upper_bound
    sort = IO.popen('sort -V', 'w+')
    RUBY_INTERPRETERS.values.map do |data|
      sort.puts(data[:ruby_upper_bound])
    end
    sort.close_write()
    version = sort.read.split.last
    "libruby (<< #{version})"
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
