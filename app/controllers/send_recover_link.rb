require 'mailgun'

class SendRecoverLink

 def initialize(mailer: nil)
   @mailer = mailer || Mailgun::Client.new(ENV["key-921b47c1c41dc9d844963b22712a3e51"])
 end

 def self.call(user, mailer = nil)
   new(mailer: mailer).call(user)
 end

 def call(user)
   mailer.send_message(ENV["sandbox9fdef33821a345d58ecce5d3c451cfb8.mailgun.org"], {from: "bookmarkmanager@mail.com",
       to: user.email,
       subject: "reset your password",
       text: "click here to reset your password http://bookymarky.herokuapp.com/users/reset_password?token=#{user.password_token}" })
 end

 private
 attr_reader :mailer
end
