# Copyright 2009 Michael Edwards, Brendan Taylor
# This file is part of free-library-on-rails.
#
# free-library-on-rails is free software: you can redistribute it
# and/or modify it under the terms of the GNU Affero General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.

# free-library-on-rails is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with free-library-on-rails.
# If not, see <http://www.gnu.org/licenses/>.

class LoansController < ApplicationController
	before_filter :login_required

	def index
		@title = 'Your Loans'
		@borrowed_and_pending = self.current_user.borrowed_and_pending
		@lent_and_pending = self.current_user.lent_and_pending
	end

	def new
		@item = Item.find(params[:item_id])
	end

	def create
		@item = Item.find(params[:item_id])

		@loan = Loan.create_request(self.current_user, @item)

		if @item.owner == self.current_user and params[:return_date]
			return_date = Date.parse(params[:return_date])
			memo = params[:memo]

			@loan.lent!(return_date, memo)
		else
			flash[:notice] = "Loan request sent."
		end

		redirect_to polymorphic_path(@item)
	end

	def update
		@loan = Loan.find(params[:id])

		unless @loan.item.owner == self.current_user
			unauthorized "you don't have permission to modify this loan"; return
		end

		if @loan.status == "requested"
			update_requested
		elsif @loan.status == "lent"
			update_lent
		end

		redirect_back_or_to polymorphic_path(@loan.item)
	end

	def destroy
		@loan = Loan.find(params[:id])

		unless @loan.borrower == self.current_user
			unauthorized "can't delete somebody else's loan request"; return
		end

		unless @loan.status == 'requested'
			unauthorized "can only cancel a pending request"; return
		end

		@loan.destroy

		redirect_to :action => 'index'
	end

	private
	def update_requested
		if params[:status] == 'rejected'
			@loan.rejected!
		elsif @loan.item.loaned?
			flash[:error] = "Can't loan an item that is already loaned."
		else
			if params[:return_date].empty?
				flash[:error] = 'You need to enter a return date.'
				return
			end

			begin
				return_date = Date.parse(params[:return_date])
			rescue ArgumentError
				flash[:error] = 'Not a valid return date.'
				return
			end

			if return_date <= Date.today
				flash[:error] = "Can't have a return date in the past."
				return
			end

			memo = params[:memo]

			@loan.lent!(return_date, memo)
			flash[:notice] = "Request approved."
		end
	end

	def update_lent
		@loan.returned!
		flash[:notice] = "Return acknowledged."
	end
end
