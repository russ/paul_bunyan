require "./paul_bunyan/*"

module PaulBunyan
  VERSION = "0.1.0"

  @@logger : Logger?

  def self.logger
    @@logger ||= Logger.new
  end

  def self.logger=(logger : Logger)
    @@logger = logger
  end
end
