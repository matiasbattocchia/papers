class ResponseMailer < ActionMailer::Base
  default from: "minimal@eudemocracia.org"

  def respond(request)
      # Guarda que el método es put.
      #@repost_url  = url_for(:action => "#{request.id}/repost", :controller => 'requests', :only_path => false)
      attachments[ request.attachment.identifier ] = request.attachment
      mail(:to => request.user.email, :subject => "Paper solicitado")
  end

end
