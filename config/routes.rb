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
  get "listed-investment-companies/:id/share-price-vs-nta" => "share_price_vs_ntas#show", as: "lics_share_price_vs_ntas"
  get "listed-investment-companies/:id/portfolio-holdings" => "portfolio_holdings#show", as: "lics_portfolio_holdings"
  get "listed-investment-companies/:id/performance" => "performances#show", as: "lics_performances"
  get "listed-investment-companies/:id/management-fees" => "expenses#show", as: "lics_expenses"
  get "listed-investment-companies/:id/annual-reports" => "annual_reports#show", as: "lics_annual_reports"
  
  # Redirects
  get '/listed-investment-companies', to: redirect('/')   # This was an only page, no longer in use. 

end
