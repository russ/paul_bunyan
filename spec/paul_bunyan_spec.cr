require "./spec_helper"

describe PaulBunyan do
  it "has a version" do
    PaulBunyan::VERSION.should_not be_nil
  end

  it "provides a default logger" do
    PaulBunyan.logger.should be_a(PaulBunyan::Logger)
  end

  it "allows setting a custom logger" do
    custom_logger = PaulBunyan::Logger.new
    PaulBunyan.logger = custom_logger
    PaulBunyan.logger.should eq(custom_logger)
  end
end

describe PaulBunyan::Logger do
  it "logs messages at different levels" do
    io = IO::Memory.new
    logger = PaulBunyan::Logger.new(io, PaulBunyan::Logger::Level::Debug)

    logger.debug { "Debug message" }
    logger.info { "Info message" }
    logger.warn { "Warn message" }
    logger.error { "Error message" }

    output = io.to_s
    output.should contain("DEBUG")
    output.should contain("INFO")
    output.should contain("WARN")
    output.should contain("ERROR")
  end

  it "supports tagged logging" do
    io = IO::Memory.new
    logger = PaulBunyan::Logger.new(io, PaulBunyan::Logger::Level::Debug)

    logger.tagged("Big Blue") do
      logger.debug { "Choppin' those logs!" }
    end

    output = io.to_s
    output.should contain("[Big Blue]")
    output.should contain("Choppin' those logs!")
  end

  it "supports nested tags" do
    io = IO::Memory.new
    logger = PaulBunyan::Logger.new(io, PaulBunyan::Logger::Level::Debug)

    logger.tagged("Outer") do
      logger.tagged("Inner") do
        logger.info { "Nested message" }
      end
    end

    output = io.to_s
    output.should contain("[Outer]")
    output.should contain("[Inner]")
    output.should contain("Nested message")
  end

  it "supports multiple tags at once" do
    io = IO::Memory.new
    logger = PaulBunyan::Logger.new(io, PaulBunyan::Logger::Level::Debug)

    logger.tagged("Tag1", "Tag2", "Tag3") do
      logger.info { "Multi-tagged message" }
    end

    output = io.to_s
    output.should contain("[Tag1]")
    output.should contain("[Tag2]")
    output.should contain("[Tag3]")
  end
end
