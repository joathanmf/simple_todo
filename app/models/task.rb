class Task < ApplicationRecord
  validates :name, presence: true

  enum :status, { incomplete: 0, complete: 1 }

  def toggle_status
    update(status: self.complete? ? :incomplete : :complete)
  end
end
