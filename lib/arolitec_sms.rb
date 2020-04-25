# Gems
require "faraday"
require "json"

require "arolitec_sms/version"
require "arolitec_sms/configuration"
require "arolitec_sms/exceptions"
#require "arolitec_sms/interceptor"
require "arolitec_sms/client"

module ArolitecSms
  
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
