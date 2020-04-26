module ArolitecSms
    class ArolitecSmsError < StandardError
    end
    
    class ArolitecSmsConfigurationError < ArolitecSmsError
    	def initialize(msg="Erreur de configuration de l'API")
    		super
    	end
    end
  end