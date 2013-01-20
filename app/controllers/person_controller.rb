class PersonController < ApplicationController
  def new
    @party = Person.new
    @party.base_address = Address.create!(:address => "")

    @party.party_roles << StudentRole.create!({:faculty => "",
                                               :member => 'f'})

    @party.surveys << StandardSurvey.create!({
                                                 :investigate => 'f',
                                                 :bible_study => 'f',
                                                 :small_event => 'f',
                                                 :notes => "",
                                             })

    render "parties/new_person"
  end

  def create
    @party = Person.new(params[:party])

    if !params[:base_address][:address].nil? then
      @party.base_address = Address.create!(params[:base_address])
    else
      @party.base_address = Res.create!(params[:base_address])
    end

    params[:role].values.each { |roleValue|
      if !roleValue[:faculty].nil? then
        @party.party_roles << StudentRole.create!(roleValue)
      end
    }

    params[:survey].values.each { |surveyValue|
      @party.surveys << StandardSurvey.create!(surveyValue)
    }

    addressTypeChanged = params[:address_type_changed]

    if addressTypeChanged != "Residence" && addressTypeChanged != "Street"
      if @party.save
        flash[:success] = "Created new person"
        #redirect_to '/parties/new_person'
        redirect_to new_person_path
      else
        render '/parties/new_person'
      end
    else
      @party.base_address = addressTypeChanged == "Residence" ? Res.create! : Address.create!
      render "parties/new_person"
    end

  end

end
