class Lic < ApplicationRecord

    before_save :set_slug

    def to_param
        slug
    end


    private

    def set_slug
        self.slug = "#{ticker}-#{name}".parameterize
    end

end