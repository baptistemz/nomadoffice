module Account
  module Bookings
    class ConfirmationController < Account::Base
      before_action :set_booking
      require "stripe"

      def show
        @company = @booking.desk.company
        @desk = @booking.desk
        # @booking = @desk.bookings.find(params[:booking_id])
        @user = @booking.user || User.new(email: @booking.payment['source']['name'])
      end

      def create
        @booking.update(status: :confirmed)
        redirect_to account_booking_confirmation_path(@booking)
      end

      def destroy
        refund = Stripe::Refund.create(
          charge: @booking.payment['id']
        )

        @booking.update(status: :canceled, refund: refund.to_json)
        # @booking.invoice.update(refund: refund.to_json)
        redirect_to account_booking_confirmation_path(@booking)

      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to account_booking_confirmation_path(@booking)
      end

      private

      def set_booking
        @booking =  Booking.joins(:desk).where(desks: { company_id: current_user.company.id }).find(params[:booking_id])
      end
    end
  end
end
