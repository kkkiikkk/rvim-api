categories = [
  {
    title: {
      ua: "Фурі",
      ru: "Фурри",
      en: "Furry",
      de: "Pelzig"
    }
  }
]

categories.each do |category|
  attributes = {
    title_ua: category[:title][:ua],
    title_ru: category[:title][:ru],
    title_en: category[:title][:en],
    title_de: category[:title][:de]
  }

  SeedsHelper.create_category!(attributes)
end
