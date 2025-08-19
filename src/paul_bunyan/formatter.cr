require "json"

module PaulBunyan
  abstract class Formatter
    abstract def format(entry : LogEntry) : String
  end

  class DefaultFormatter < Formatter
    def format(entry : LogEntry) : String
      level_str = entry.level.to_s.upcase.ljust(5)
      timestamp = entry.timestamp.to_s("%Y-%m-%d %H:%M:%S UTC")

      if entry.tags.empty?
        "[#{timestamp}] #{level_str} #{entry.message}"
      else
        tags_str = entry.tags.map { |tag| "[#{tag}]" }.join(" ")
        "[#{timestamp}] #{level_str} #{tags_str} #{entry.message}"
      end
    end
  end

  class JSONFormatter < Formatter
    def format(entry : LogEntry) : String
      {
        timestamp: entry.timestamp.to_rfc3339,
        level:     entry.level.to_s.downcase,
        message:   entry.message,
        tags:      entry.tags,
      }.to_json
    end
  end
end
