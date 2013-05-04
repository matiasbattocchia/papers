module RequestsHelper

  def iframe request
    ('<iframe src="' + request.url + '"></iframe>').html_safe
  end

  def request_path request
    "requests/#{request.id}"
  end

  def next_request
    request = Request.where(:status => 'active', :locked => false).order('updated_at ASC').first
    request_path request
  end

end
