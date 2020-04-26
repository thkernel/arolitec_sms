require "uri"
require_relative "exceptions"

module ArolitecSms
    class Client

        def send(sender, receiver, content)
            raise ArolitecSms::ArolitecSmsConfigurationError unless api_configured? 

            message = {}

            message[:charset] = ArolitecSms.configuration.charset.nil?
            message[:flash] = ArolitecSms.configuration.flash.nil? ? "" : ArolitecSms.configuration.flash
            message[:climsgid] = Time.now.strftime("%Y%m%d%H%M%S")
            message[:numericsender] = ""
            message[:sender] = sender
            message[:receiver] = receiver
            message[:content] = content

            puts "MESSAGE: #{message}"

            send_sms(message)
           

        end




        private

            def api_configured?

                if ArolitecSms.configuration != nil

                    api_base_url = ArolitecSms.configuration.api_base_url
                    send_sms_endpoint = ArolitecSms.configuration.send_sms_endpoint
                    api_user_name = ArolitecSms.configuration.api_user_name
                    api_user_password = ArolitecSms.configuration.api_user_password

                    if api_base_url.nil? || send_sms_endpoint.nil? || api_user_name.nil? || api_user_password.nil?
                        
                        return false

                    else
                        
                        return true
                    end
                else
                    return false
                end
            rescue StandardError => e 
                e.to_s
           
            end
            


            def send_sms(message)
                 
                
                    
                endpoint = ArolitecSms.configuration.send_sms_endpoint
                # Inialize a new connection.
                connexion = Faraday.new(ArolitecSms.configuration.api_base_url) 

                payload = "?user=#{ArolitecSms.configuration.api_user_name}&password=#{ArolitecSms.configuration.api_user_password}&sender=#{message[:sender]}&receiver=#{message[:receiver]}&content=#{message[:content]}"

                puts "LE PAYLOAD: #{URI.encode(payload)}"
                response =  connexion.post do |req|
                    req.url endpoint + URI.encode(payload)
                    #req.headers['Content-Type'] = 'application/json'
                    #req.headers['Authorization'] = 'Bearer ' + ArolitecSms.configuration.access_token
                    #req.body = payload.to_json
                end
             

                if response.status == 200
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                    return response
                    
                elsif response.status == 401
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"
                    return response

                end
                
            
            end

    end
end