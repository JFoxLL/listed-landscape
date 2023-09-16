Rails.application.routes.draw do

  root "lics#index"
  get "listed-investment-companies" => "lics#index"

end
