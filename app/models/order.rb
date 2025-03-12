# frozen_string_literal: true

# we don't strictly validate hardly anything here because this is just a store
# of the raw imported csv data. We'll validate the data when we do our processing
# and normalization of the data later.
class Order < ApplicationRecord
  belongs_to :batch
end
