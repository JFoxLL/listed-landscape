class NumberShareholder < ApplicationRecord

    belongs_to :lic
    
end

# Notes:
# The the 'Lic' resource, and the 'NumberShareholder' resource, is a one-to-many relationship.
# The 'lics' db table has a an 'id' column (the left most column).
# The 'NumberShareholder' db table has a 'lic_id' column (the right most column).
# These tables are connected by inserting the lic 'id' (from the lic table) into the 'lic_id' column.
# These tables are now connected via a one-to-many relationship.