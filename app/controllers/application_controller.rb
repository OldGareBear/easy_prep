class ApplicationController < ActionController::Base
  def after_sign_in_path_for(user)
    if user.is_a_teacher?
      courses_path
    else
      student_dashboard_path
    end
  end
end
