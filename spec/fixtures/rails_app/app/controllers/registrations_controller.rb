class RegistrationsController < Devise::RegistrationsController
  # Since this is an API only app we disable session storing on sign up
  # but we still allow signing in to set the `Authorization` header with JWT
  # strategy
  # Unfortunately there is no config to disable session storage on the
  # registerable module.
  #
  # https://github.com/heartcombo/devise/blob/fec67f98f26fcd9a79072e4581b1bd40d0c7fa1d/app/controllers/devise/registrations_controller.rb#L103-L107
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource, store: false)
  end
end
