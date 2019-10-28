class CustomFailureApp < Devise::FailureApp
  def route(scope)
    :new_user_registration_url
  end

  def redirect
    super

    if flash[:alert] == I18n.t('devise.failure.unauthenticated')
      flash.delete :alert
    end
  end
end
