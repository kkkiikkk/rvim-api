module LocaleDetection
  extend ActiveSupport::Concern

  private

  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale]
    else
      country_code = IpGeolocationService.call(request.remote_ip)
      I18n.locale = map_country_to_locale(country_code) || I18n.default_locale
    end
  end

  def map_country_to_locale(country_code)
    {
      "UA" => :ua,
      "RU" => :ru,
      "DE" => :de,
      "US" => :en,
      "GB" => :en
    }[country_code]
  end
end
