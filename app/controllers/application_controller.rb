class ApplicationController < ActionController::API
  include LocaleDetection

  before_action :set_locale
end
