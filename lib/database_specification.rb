require "database_specification/version"
require 'uri'
require 'cgi'

# Translate beween different ways of describing a database connection
# Currently supports
#
# - ActiveRecord hash
# - Sequel hash
# - URL (Sequel/Heroku)
#
# Construct an object with the appropriate from-database constructor,
# and then use the appopriate to-database accessor.
class DatabaseSpecification
  # The database driver type: postgres, sqlite, etc.
  attr_reader :adapter
  # Database name within the server
  attr_reader :database
  attr_reader :user
  attr_reader :password
  attr_reader :host
  attr_reader :port
  # Misc extra options, ex: pool, timeout
  attr_reader :options

  # How we store the information internally
  STANDARD = [
    :adapter,
    :database,
    :user,
    :username,
    :password,
    :host,
    :port,
  ]

  # ActiveRecord constructor
  # @param [Hash] config ActiveRecord style db hash
  def self.active_record(config)
    new.from_active_record(config)
  end

  # Sequel hash constructor
  # @param [Hash] config Sequel style db hash
  def self.sequel(config)
    new.from_sequel(config)
  end

  # URL constructor (Sequel/Heroku)
  # @param [String] url
  def self.url(url)
    new.from_url(url)
  end

  # Performs the work of setting up from an ActiveRecord style hash
  # @param [Hash] config ActiveRecord style db hash
  # @return [DatabaseSpecification]
  def from_active_record(config)
    @adapter = ar_to_sequel(config[:adapter])
    @database = config[:database]
    @user = config[:username]
    @password = config[:password]
    @host = config[:host]
    @port = config[:port]
    @options = (config.keys - STANDARD).map {|k| [k, config[k]]}
    self
  end

  # Performs the work of setting up from a Sequel style hash
  # @param [Hash] config Sequel style db hash
  # @return [DatabaseSpecification]
  def from_sequel(config)
    @adapter = config[:adapter]
    @database = config[:database]
    @user = config[:user]
    @password = config[:password]
    @host = config[:host]
    @port = config[:port]
    @options = (config.keys - STANDARD).map {|k| [k, config[k]]}
    self
  end

  # Performs the work of setging up from a url
  # @param [String] url
  # @return [DatabaseSpecification]
  def from_url(url)
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      raise "Invalid DATABASE_URL"
    end
    @adapter = uri.scheme
    @database = uri.path.split('/')[1]
    @user = uri.user
    @password = uri.password
    @host = uri.host
    @port = uri.port
    @options = parse_query(uri.query)

    if @adapter == 'sqlite'
      @database = [@host, @database].join('/')
      @host = nil
    end
    self
  end

  # @return [Hash] ActiveRecord style hash
  def active_record
    Hash[[
      [:adapter, sequel_to_ar(adapter)],
      [:database, database],
      [:username, user],
      [:password, password],
      [:host, host],
      [:port, port],
    ].select {|x| x.last} + options]
  end

  # @return [Hash] Sequel style hash
  def sequel
    Hash[[
      [:adapter, adapter],
      [:database, database],
      [:user, user],
      [:password, password],
      [:host, host],
      [:port, port],
    ].select {|x| x.last} + options]
  end

  # @return [String] DB url with query paramters
  def url
    [url_bare, query].compact.join('?')
  end

  # @return [String] DB url without query parameters
  def url_bare
    if adapter == 'postgres'
      h = host || 'localhost'
    else
      h = host
    end
    uri = URI::Generic.build({
      :scheme => adapter,
      :userinfo => userinfo,
      :host => h,
      :port => port,
      :path => '/' + database, # wants an absolute component
    }).to_s
    # URI is overly agressive in removing leading /
    if adapter == 'sqlite'
      uri.gsub!(':/', '://')
    end
    uri
  end

  private
  def ar_to_sequel(adapter)
    case adapter
    when 'sqlite3'; 'sqlite'
    when 'postgresql'; 'postgres'
    else; adapter
    end
  end

  def sequel_to_ar(adapter)
    case adapter
    when 'sqlite'; 'sqlite3'
    when 'postgres'; 'postgresql'
    else; adapter
    end
  end

  def userinfo
    if user || password
      [user, password].join(':')
    end
  end

  def query
    q = options.map do |k,v|
      k.to_s + '=' + v.to_s
    end.join('&')
    q unless q.empty?
  end

  def parse_query(q)
    CGI.parse(q || '').to_a.map do |k, v|
      n = v.first
      if n.match(/\d+/)
        n = n.to_i
      end
      [k.to_sym, n]
    end
  end
end
