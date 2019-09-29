

module ArolitecSms
    class Client
        include ArolitecSms::HttpInterceptor

        def send_sms(sender, receiver, content)
            message = {}

            message[:charset] = ""
            message[:flash] = ""
            message[:climsgid] = Time.now.strftime("%Y%m%d%H%M%S")
            message[:numericsender] = ""
            message[:sender] = sender
            message[:receiver] = receiver
            message[:content] = content

            puts "MESSAGE: #{message}"

            post(ArolitecSms.configuration.send_sms_endpoint, message)
           
               
        end
    end
end