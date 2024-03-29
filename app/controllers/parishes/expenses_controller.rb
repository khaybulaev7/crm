# frozen_string_literal: true

module Parishes
  class ExpensesController < ApplicationController
    before_action :set_expense, only: %i[update edit destroy]
    before_action :set_parish

    def index
      @parishes = Parish.all
      @expenses = @parish.expenses
    end

    def new
      @expense = Expense.new
    end

    def create
      @expense = @parish.expenses.new(expense_params)
      if @expense.save
        update_remainder
        redirect_to parish_expenses_path(@parish)
      else
        render 'new'
      end
    end

    def edit; end

    def update
      if @expense.update(expense_params)
        update_remainder
        redirect_to parish_expenses_path(@parish)
      else
        render 'edit'
      end
    end

    def destroy
      update_remainder if @expense.destroy
      redirect_to parish_expenses_path(@parish)
    end

    private

    def set_parish
      @parish = Parish.find(params[:parish_id])
    end

    def update_remainder
      set_parish_with_sum

      @parish
        .update(remainder: @parish_with_sum.quantity - (@parish_with_sum.sum_killed + @parish_with_sum.sum_sold_count))
    end

    def set_expense
      @expense = Expense.find(params[:id])
    end

    def expense_params
      params.require(:expense).permit(:killed, :killed_weight, :sold_count, :sold_weight, :date_of_create)
    end
  end
end
