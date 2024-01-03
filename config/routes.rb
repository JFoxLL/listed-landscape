Rails.application.routes.draw do
  
  # Home page
  root "lics#index"

  # Lic show pages
  get "listed-investment-companies/:id" => "lics#show", as: "listed_investment_company"

  # Dedicated summary pages
  get "share-price-vs-nta" => "share_price_vs_ntas#index"
  get "performance" => "performances#index"
  get "dividend-yields" => "dividend_yields#index"

  # Level 3 SEO Pages
  get "listed-investment-companies/:id/dividend-history" => "dividend_histories#show", as: "lics_dividend_histories"
  
  # Redirects
  get '/listed-investment-companies', to: redirect('/')   # This was an only page, no longer in use. 

end
