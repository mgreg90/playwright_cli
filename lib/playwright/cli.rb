require 'playwright/play'

require 'playwright/cli/directory_builder'
require 'playwright/cli/get'
require 'playwright/cli/install'
require 'playwright/cli/new'
require 'playwright/cli/publish'
require 'playwright/cli/renderer'

module Playwright
  class Cli < Play

    class NoRubyClassError < StandardError; end

    NO_COMMAND_MSG = "$ playwright what?\nYou need to enter a command.".freeze
    INVALID_COMMAND_MSG = "Playwright doesn't know that command.".freeze
    COMMANDS = [
      { klass:'get', terms: ['get'] },
      { klass: 'new', terms: ['generate', 'g', 'new'] },
      { klass: 'install', terms: ['install'] },
      { klass: 'publish', terms: ['publish'] }
    ].freeze

    map_params :command

    validate proc { !params.command },
      NO_COMMAND_MSG
    validate proc { !self.class.terms.include?(params.command) },
      INVALID_COMMAND_MSG

    def run
      params.to_a.length > 1 ? klass.run(params.to_a[1..-1]) : klass.run
    end

    def klass
      Object.const_get("#{self.class}::#{params.command.capitalize}")
    rescue NameError => e
      raise NoRubyClassError, "There's no ruby class for this command!"
    end

    def self.terms
      COMMANDS.map{|com|com[:terms]}.flatten
    end

  end
end
