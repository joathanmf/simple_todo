class Task < ApplicationRecord
  validates :name, length: { minimum: 1 }

  enum :status, %i[ incompleto completo ]
end
