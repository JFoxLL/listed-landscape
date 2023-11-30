# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.listedlandscape.com"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do

  Lic.find_each do |lic|
    add listed_investment_company_path(lic), :priority => 0.7, :changefreq => 'monthly'
  end

  add share_price_vs_nta_path, :priority => 0.5, :changefreq => 'monthly'
  add performance_path, :priority => 0.5, :changefreq => 'monthly'

end


# Steps to refresh the sitemap:
  # In development:
    # Update sitemap code above
    # Command to update sitemap: rake sitemap:refresh:no_ping
    # Merge changes into main
    # Push to origin (github) (git push origin main)
  # Push to production on Heroku (git push heroku main)
  # Restart Heroku server (heroku restart)
  # Resubmit updated sitemap in Google Search Consol



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
