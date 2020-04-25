require_relative "exceptions"

module ArolitecSms
    class Client

        def send(sender, receiver, content)
            message = {}

            message[:charset] = ArolitecSms.configuration.charset
            message[:flash] = ArolitecSms.configuration.flash
            message[:climsgid] = Time.now.strftime("%Y%m%d%H%M%S")
            message[:numericsender] = ""
            message[:sender] = sender
            message[:receiver] = receiver
            message[:content] = content

            puts "MESSAGE: #{message}"

            post(ArolitecSms.configuration.send_sms_endpoint, message)
           
        rescue => e 

        end


        def api_configured?

            api_base_url = ArolitecSms.configuration.api_base_url
            send_sms_endpoint = ArolitecSms.configuration.send_sms_endpoint
            api_user_name = ArolitecSms.configuration.api_user_name
            api_user_password = ArolitecSms.configuration.api_user_password

            if api_base_url.present? || send_sms_endpoint.present? || api_user_name.present? || api_user_password.present?
                return true
            else
                return false 
            end
        
        end

        def post(endpoint, message)
             
            if api_configured? 
                 
                # Inialize a new connection.
                connexion = Faraday.new(ArolitecSms.configuration.api_base_url) 

                payload = "?user=#{ArolitecSms.configuration.api_user_name}&password=#{ArolitecSms.configuration.api_user_password}&sender=#{message[:sender]}&receiv
                er=#{message[:receiver]}&content=#{message[:content]}"

                response =  connexion.post do |req|
                    req.url(endpoint + payload)
                    #req.headers['Content-Type'] = 'application/json'
                    #req.headers['Authorization'] = 'Bearer ' + ArolitecSms.configuration.access_token
                    #req.body = payload.to_json
                end
             

                if response.status == 200
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                    return response
                    
                elsif response.status == 401
                    puts "LA REPONSE DE LA REQUETTE EST: #{response.body}"

                end
            else
                raise ArolitecSms::ArolitecSmsConfigurationError
            end
        end

    end
end