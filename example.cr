require "./src/paul_bunyan"

puts "=== PaulBunyan Logging Library Example ==="
puts

# Use the default logger
puts "1. Basic logging:"
PaulBunyan.logger.info { "Basic logging message" }
puts

# Tagged logging - the main feature!
puts "2. Tagged logging:"
PaulBunyan.logger.tagged("Big Blue") do
  PaulBunyan.logger.debug { "Choppin' those logs!" }
  PaulBunyan.logger.info { "Another message with the same tag" }
end
puts

# Nested tags
puts "3. Nested tags:"
PaulBunyan.logger.tagged("Outer") do
  PaulBunyan.logger.tagged("Inner") do
    PaulBunyan.logger.warn { "Deeply nested logging" }
  end
end
puts

# Multiple tags at once
puts "4. Multiple tags at once:"
PaulBunyan.logger.tagged("Tag1", "Tag2", "Tag3") do
  PaulBunyan.logger.error { "Multi-tagged message" }
end
puts

# Different log levels
puts "5. Different log levels:"
PaulBunyan.logger.debug { "Debug info" }
PaulBunyan.logger.info { "General info" }
PaulBunyan.logger.warn { "Warning message" }
PaulBunyan.logger.error { "Error occurred" }
PaulBunyan.logger.fatal { "Fatal error" }
puts

# Custom logger with different output
puts "6. Custom logger with file output:"
File.open("app.log", "w") do |file|
  custom_logger = PaulBunyan::Logger.new(
    output: file,
    level: PaulBunyan::Logger::Level::Info
  )
  
  # Temporarily use custom logger
  original_logger = PaulBunyan.logger
  PaulBunyan.logger = custom_logger
  
  PaulBunyan.logger.info { "This goes to app.log" }
  PaulBunyan.logger.debug { "This won't appear (level too low)" }
  
  # Restore original logger
  PaulBunyan.logger = original_logger
end

puts "Custom logger output written to app.log"
puts "Contents of app.log:"
if File.exists?("app.log")
  puts File.read("app.log")
end
puts

# JSON formatting
puts "7. JSON formatting:"
json_logger = PaulBunyan::Logger.new
json_logger.formatter = PaulBunyan::JSONFormatter.new
json_logger.tagged("JSON", "Example") do
  json_logger.info { "This is formatted as JSON" }
end
puts

puts "=== Example Complete ==="