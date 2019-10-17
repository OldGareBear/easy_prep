class ApplicationController < ActionController::Base
  def after_sign_in_path_for(_)
    courses_path
  end
end
