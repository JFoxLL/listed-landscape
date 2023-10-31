# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.listedlandscape.com"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do

  add '/listed-investment-companies', :priority => 0.8, :changefreq => 'weekly'

  Lic.find_each do |lic|
    add listed_investment_company_path(lic), :priority => 0.7, :changefreq => 'monthly'
  end

end


# Notes:
  # To refresh the sitemap:
    # run: rake sitemap:refresh:no_ping
    # Push to Heroku
    # Update sitemap in Google Cloud Storage bucket



# Gem default instructions:
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
