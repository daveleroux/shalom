class PersonController < ApplicationController
  def new
    @person = Person.new
  end

  def create
      @person = Person.new(params[:person])
      if @person.save
        flash[:success] = "Created new person"
        redirect_to new_person_path
      else
        render 'new'
      end
    end

end
