module PaulBunyan
  class Logger
    enum Level
      Debug
      Info
      Warn
      Error
      Fatal
    end

    property level : Level = Level::Info
    property output : IO = STDOUT
    property formatter : Formatter = DefaultFormatter.new
    property current_tags : Array(String) = [] of String

    def initialize(@output : IO = STDOUT, @level : Level = Level::Info)
    end

    def debug(message = nil, &block : -> String)
      log(Level::Debug, message, &block)
    end

    def info(message = nil, &block : -> String)
      log(Level::Info, message, &block)
    end

    def warn(message = nil, &block : -> String)
      log(Level::Warn, message, &block)
    end

    def error(message = nil, &block : -> String)
      log(Level::Error, message, &block)
    end

    def fatal(message = nil, &block : -> String)
      log(Level::Fatal, message, &block)
    end

    def tagged(tag : String, &block)
      old_tags = @current_tags.dup
      @current_tags = old_tags + [tag]
      yield
      @current_tags = old_tags
    end

    def tagged(*tags : String, &block)
      old_tags = @current_tags.dup
      @current_tags = old_tags + tags.to_a
      yield
      @current_tags = old_tags
    end

    private def log(level : Level, message : String? = nil, &block : -> String)
      return if level < @level

      msg = message || yield
      entry = LogEntry.new(level, msg, Time.utc, @current_tags)
      formatted = @formatter.format(entry)
      @output.puts(formatted)
      @output.flush
    end

    private def log(level : Level, message : String?)
      return if level < @level

      msg = message || ""
      entry = LogEntry.new(level, msg, Time.utc, @current_tags)
      formatted = @formatter.format(entry)
      @output.puts(formatted)
      @output.flush
    end

    def log_with_tags(level : Level, message : String? = nil, tags : Array(String) = [] of String, &block)
      return if level < @level

      msg = message || (block ? yield.to_s : "")
      entry = LogEntry.new(level, msg, Time.utc, tags)
      formatted = @formatter.format(entry)
      @output.puts(formatted)
      @output.flush
    end
  end

  class TaggedLogger
    def initialize(@logger : Logger, @tags : Array(String))
    end

    def initialize(@logger : Logger, tag : String)
      @tags = [tag]
    end

    def debug(message = nil, &block)
      @logger.as(Logger).log_with_tags(Logger::Level::Debug, message, @tags, &block)
    end

    def info(message = nil, &block)
      @logger.as(Logger).log_with_tags(Logger::Level::Info, message, @tags, &block)
    end

    def warn(message = nil, &block)
      @logger.as(Logger).log_with_tags(Logger::Level::Warn, message, @tags, &block)
    end

    def error(message = nil, &block)
      @logger.as(Logger).log_with_tags(Logger::Level::Error, message, @tags, &block)
    end

    def fatal(message = nil, &block)
      @logger.as(Logger).log_with_tags(Logger::Level::Fatal, message, @tags, &block)
    end

    def tagged(tag : String, &block)
      TaggedLogger.new(@logger, @tags + [tag]).tap(&block)
    end

    def tagged(*tags : String, &block)
      TaggedLogger.new(@logger, @tags + tags.to_a).tap(&block)
    end
  end

  struct LogEntry
    getter level : Logger::Level
    getter message : String
    getter timestamp : Time
    getter tags : Array(String)

    def initialize(@level : Logger::Level, @message : String, @timestamp : Time, @tags : Array(String))
    end
  end
end
