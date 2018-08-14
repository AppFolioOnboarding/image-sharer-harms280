class ApplicationController < ActionController::Base
  helper_method :add_active_class

  protect_from_forgery with: :exception

  def add_active_class(*actions)
    actions.include?(action_name) ? 'active' : ''
  end
end
