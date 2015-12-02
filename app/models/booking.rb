class Booking < ActiveRecord::Base
  extend Enumerize

  belongs_to :desk
  belongs_to :user

  validate  :user_cannot_be_from_the_company,
            :desk_cannot_be_fully_booked

  enumerize :time_slot_type, in: ["heure(s)", "jour(s)", "semaine(s)"], default: "heure(s)"

  private

  def user_cannot_be_from_the_company
    errors.add(:user, "Vous ne pouvez pas reserver dans votre entreprise") if
      user == desk.company.user
  end

  def desk_cannot_be_fully_booked
    errors.add(:desk, "Il n'y a plus de bureau disponible") if
      desk.bookings.where(start_datetime)
  end
end
