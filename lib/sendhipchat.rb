module Sendhipchat
  ROOT = File.expand_path(File.dirname(__FILE__))

  autoload :Runner, "#{ROOT}/sendhipchat/runner"
end

require "#{Sendhipchat::ROOT}/sendhipchat/version"
