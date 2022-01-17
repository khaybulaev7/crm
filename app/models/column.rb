# frozen_string_literal: true

class Column < ApplicationRecord
  acts_as_list add_new_at: :bottom, scope: :category

  belongs_to :category

  has_many :items

  before_update :check_bottom_position

  private

  def check_bottom_position
    return unless position_changed?

    self.position = [bottom_position_in_list, position].min
  end
end
