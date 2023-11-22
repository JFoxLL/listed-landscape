Rails.application.routes.draw do

  root "lics#index"

  get "listed-investment-companies" => "lics#index"
  get "listed-investment-companies/:id" => "lics#show", as: "listed-investment-company"

  get "share-price-vs-nta" => "share_price_vs_ntas#index"

end
