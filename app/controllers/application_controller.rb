class ApplicationController < ActionController::API
  def current_ip
    request.env["HTTP_X_FORWARDED_FOR"].to_s.split(",").map(&:strip).first || request.remote_ip
  end
end
