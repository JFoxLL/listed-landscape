Rails.application.routes.draw do
  
  # Home page
  root "lics#index"

  # Lic show pages
  get "listed-investment-companies/:id" => "lics#show", as: "listed-investment-company"

  # Dedicated summary pages
  get "share-price-vs-nta" => "share_price_vs_ntas#index"
  get "performance" => "performances#index"
  get "dividend-yields" => "dividend_yields#index"
  
  # Redirects
  get '/listed-investment-companies', to: redirect('/')   # This was an only page, no longer in use. 

end
