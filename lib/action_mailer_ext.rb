module ActionMailer
  class Base
    cattr_accessor :delivery_reroute_to 
    cattr_accessor :delivery_reroute_method

    private

    def perform_delivery_reroute(mail)
      if (@@delivery_reroute_to && @@delivery_reroute_method)
        mail.subject += " [#{RAILS_ENV.upcase}, was to: #{mail.to.join(',')}"
        mail.subject += "; cc: #{mail.cc.join(',')}" unless mail.cc.nil?
        mail.subject += "; bcc: #{mail.bcc.join(',')}" unless mail.bcc.nil?
        mail.subject += "]"

        mail.to = quote_address_if_necessary(@@delivery_reroute_to, charset)
        mail.cc = mail.bcc = nil
        logger.info "Mail rerouted to: #{mail.to.join(',')}"
        return __send__("perform_delivery_#{@@delivery_reroute_method.to_s}", mail)
      else
        logger.warn "Please define ActionMailer::Base.delivery_reroute_to and ActionMailer::Base.delivery_reroute_method"
        perform_delivery_test(mail)
      end
    end

  end
end
