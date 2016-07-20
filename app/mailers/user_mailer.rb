class UserMailer < ApplicationMailer
	def deletion_email(user)
		@user = user
		mail(to: @user.email, subject: "Your account has been deleted")
	end
end
