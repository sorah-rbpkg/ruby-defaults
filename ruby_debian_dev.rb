module RubyDebianDev

  RUBY_INTERPRETERS = {}

  def self.skip
    @skip ||= (ENV["RUBY_ALL_DEV_SKIP"] || "").split
  end

  def self.has_support_for(ruby)
    return if skip.include?(ruby)
    RUBY_INTERPRETERS[ruby] = yield
  end

  has_support_for 'ruby4.0' do
    {
      version:             '4.0',
      binary:              '/usr/bin/ruby4.0',
      api_version:         '4.0.0',
      shared_library:      'libruby4.0',
      min_ruby_version:    '1:4.0~0',
      ruby_upper_bound:    '1:4.0~',
    }
  end

  has_support_for 'ruby3.4' do
    {
      version:             '3.4',
      binary:              '/usr/bin/ruby3.4',
      api_version:         '3.4.0',
      shared_library:      'libruby3.4',
      min_ruby_version:    '1:3.4~0',
      ruby_upper_bound:    '1:3.4~',
    }
  end

  has_support_for 'ruby3.3' do
    {
      version:             '3.3',
      binary:              '/usr/bin/ruby3.3',
      api_version:         '3.3.0',
      shared_library:      'libruby3.3',
      min_ruby_version:    '1:3.3~0',
      ruby_upper_bound:    '1:3.3~',
    }
  end

  has_support_for 'ruby3.2' do
    {
      version:             '3.2',
      binary:              '/usr/bin/ruby3.2',
      api_version:         '3.2.0',
      shared_library:      'libruby3.2',
      min_ruby_version:    '1:3.2~0',
      ruby_upper_bound:    '1:3.2~',
    }
  end

  has_support_for 'ruby3.1' do
    {
      version:             '3.1',
      binary:              '/usr/bin/ruby3.1',
      api_version:         '3.1.0',
      shared_library:      'libruby3.1',
      min_ruby_version:    '1:3.1~0',
      ruby_upper_bound:    '1:3.1~',
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
