
module ArolitecSms
    module HttpInterceptor


        def api_configured?

            api_base_url = ArolitecSms.configuration.api_base_url
            send_sms_endpoint = ArolitecSms.configuration.send_sms_endpoint
            api_user_name = ArolitecSms.configuration.api_user_name
            api_user_password = ArolitecSms.configuration.api_user_password

            if api_base_url.present? && send_sms_endpoint.present? && api_user_name.present? && api_user_password.present?
                return true
            else
                return false 
            end
        end


        def post(endpoint, message)
             
            if api_configured? 
                 
                # Inialize a new connection.
                conn = Faraday.new(ArolitecSms.configuration.api_base_url) 

                payload = "?user=#{ArolitecSms.configuration.api_user_name}&password=#{ArolitecSms.configuration.api_user_password}&sender=#{message[:sender]}&receiv
                er=#{message[:receiver]}&content=#{message[:content]}"

                response =  conn.post do |req|
                    req.url  endpoint + payload
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
                render text: "Invalid API Base!"
            end
        end

      

    
    end
end