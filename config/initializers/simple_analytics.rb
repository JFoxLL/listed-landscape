SimpleAnalyticsRails.configure do |configuration|
    configuration.hostname = "listedlandscape.com"
    configuration.mode = "hash"
    configuration.collect_dnt = false
    configuration.ignore_pages = ""
    configuration.sa_global = "sa_event"
    configuration.auto_collect = true
    configuration.onload_callback = "onloadCallback()"
    configuration.custom_domain = ""
    configuration.enabled = Rails.env.production?
end
  