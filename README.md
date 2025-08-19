# PaulBunyan

A straightforward logging library for Crystal that makes chopping through your logs as easy as Paul Bunyan chopping through trees! 🪓

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  paul_bunyan:
    github: russ/paul_bunyan
```

2. Run `shards install`

## Usage

```crystal
require "paul_bunyan"

# Use the default logger
PaulBunyan.logger.info { "Basic logging message" }

# Tagged logging - the main feature!
PaulBunyan.logger.tagged("Big Blue") do
  PaulBunyan.logger.info { "Choppin' those logs!" }
  PaulBunyan.logger.info { "Another message with the same tag" }
end

# Nested tags
PaulBunyan.logger.tagged("Outer") do
  PaulBunyan.logger.tagged("Inner") do
    PaulBunyan.logger.warn { "Deeply nested logging" }
  end
end

# Multiple tags at once
PaulBunyan.logger.tagged("Tag1", "Tag2", "Tag3") do
  PaulBunyan.logger.error { "Multi-tagged message" }
end

# Different log levels (note: debug won't show with default Info level)
PaulBunyan.logger.debug { "Debug info" }
PaulBunyan.logger.info { "General info" }
PaulBunyan.logger.warn { "Warning message" }
PaulBunyan.logger.error { "Error occurred" }
PaulBunyan.logger.fatal { "Fatal error" }

# Custom logger with different output and level
File.open("app.log", "w") do |file|
  custom_logger = PaulBunyan::Logger.new(
    output: file,
    level: PaulBunyan::Logger::Level::Debug
  )
  PaulBunyan.logger = custom_logger
  PaulBunyan.logger.debug { "This debug message will now appear" }
end

# JSON formatting
json_logger = PaulBunyan::Logger.new
json_logger.formatter = PaulBunyan::JSONFormatter.new
json_logger.tagged("JSON", "Example") do
  json_logger.info { "This message is formatted as JSON" }
end
```

## Example Output

Running the example code produces output like:

```
[2025-08-19 20:59:00 UTC] INFO  Basic logging message
[2025-08-19 20:59:00 UTC] INFO  [Big Blue] Choppin' those logs!
[2025-08-19 20:59:00 UTC] INFO  [Big Blue] Another message with the same tag
[2025-08-19 20:59:00 UTC] WARN  [Outer] [Inner] Deeply nested logging
[2025-08-19 20:59:00 UTC] ERROR [Tag1] [Tag2] [Tag3] Multi-tagged message
[2025-08-19 20:59:00 UTC] INFO  General info
[2025-08-19 20:59:00 UTC] WARN  Warning message
[2025-08-19 20:59:00 UTC] ERROR Error occurred
[2025-08-19 20:59:00 UTC] FATAL Fatal error
```

JSON format output:
```json
{"timestamp":"2025-08-19T20:59:00Z","level":"info","message":"This message is formatted as JSON","tags":["JSON","Example"]}
```

## Features

- **Tagged Logging**: Easily add context to your log messages with tags
- **Nested Tags**: Support for hierarchical tagging
- **Multiple Log Levels**: Debug, Info, Warn, Error, Fatal
- **Flexible Output**: Log to STDOUT, files, or any IO
- **Custom Formatters**: Default text format or JSON format
- **Block-based Logging**: Lazy evaluation of log messages
- **Clean API**: Simple and intuitive interface

## Development

To run the example:

```bash
crystal run example.cr
```

To run the tests:

```bash
crystal spec
```

## Contributing

1. Fork it (<https://github.com/russ/paul_bunyan/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Russell Smith](https://github.com/russ) - creator and maintainer

## License

Apache-2.0 License
