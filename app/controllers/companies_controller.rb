class CompaniesController < ApplicationController
  respond_to :html, :json, :js

  def index
    respond_to do |format|
      format.html { }
      format.json do
        @companies = Company.order(:name)
      end
    end
  end
end