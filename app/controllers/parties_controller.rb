require 'csv'

class PartiesController < ApplicationController
  before_filter :authenticate
  respond_to :html

  def index
    if !params[:q].blank?
      #logger.info params[:q].inspect

      params[:q].each_pair do |k, v|
        if v == "Any"
          params[:q].delete(k)
        end
      end

      #if params[:q][:gender_eq] == "Any"
      #  params[:q].delete(:gender_eq)
      #end
      #if params[:q][:base_address_residence_eq] == "Any"
      #  params[:q].delete(:base_address_residence_eq)
      #end
      @search = Party.search(params[:q])
      #logger.info @search.inspect

      @search.build_grouping unless @search.groupings.any?
      @parties = @search.result(distinct: true)

      respond_to do |format|
        format.html {}
      end

    else
      @search = Party.search(params[:q])
      @search.build_grouping unless @search.groupings.any?
      @parties = []
    end

    #@q = Party.search(params[:q])
    #if !@q.empty?
    #  @parties = @q.result(:distinct => true)
    #end
    #@parties = Party.paginate(:page => params[:page])
  end

  def show
    @party = Party.find(params[:id])
  end

  #def new
  #  logger.info "new called"
  #  @party = Party.new
  #end


  #def create
  #@ = Group.new(params[:group])
  #if @group.save
  #  flash[:success] = "Created new group"
  #  redirect_to new_group_path
  #else
  #  render 'new'
  #end
  #end

  def edit
    @party = Party.find(params[:id])
  end

  def update
    @party = Party.find(params[:id])

    @party.update_attributes(params[:party])
    @party.base_address.update_attributes(params[:base_address])

    @party.party_roles.update params[:role].keys, params[:role].values

    @party.surveys.update params[:survey].keys, params[:survey].values

    addressTypeChanged = params[:address_type_changed]

    if addressTypeChanged != "Residence" && addressTypeChanged != "Street"
      if @party.save
        flash[:success] = "Party updated."
        redirect_to @party.partyize
      else
        flash[:notice] = 'Failed.'
        render 'edit'
      end
    else
      @party.base_address = addressTypeChanged == "Residence" ? Res.create! : Address.create!
      render 'edit'
    end
  end


  def destroy
    Party.find(params[:id]).destroy
    flash[:success] = "Party destroyed."
    redirect_to parties_path
  end

  def address_type_change
    @party = nil
    render :edit
  end

  def add_selected_to_group
    group = Group.find_by_id(params[:groups][:group_id])
    if (!group.nil?)
      params[:selected_ids_for_group].split(",").each { |id|
        party = Party.find(id)
        if (!party.nil?)
          group.addParty(party)
        end
      }
    end
    index
    render :index
  end

  def delete_selected
    found = false
    failed = false

    params[:selected_ids_for_delete].split(",").each { |id|
      found = true
      party = Party.find(id)
      if (!party.destroy)
        failed = true
      end
    }
    #if (found)
    #  if (failed)
    #    flash[:alert] = "Did not manage to delete all selected parties."
    #  else
    #    flash[:success] = "Deletion succeeded."
    #  end
    #end
    index
    render :index
  end

  def import
    uploaded_io = params[:csv]

    CSV.parse(uploaded_io.read, :headers => true) do |row|
      firstName = row['First Name']
      surname = row['Surname']
      email = row['Email Address']
      cell = row['Contact No.']
      residenceString = row['Residence']
      roomNumber = row['Room']
      genderString = row['m/f']
      member = row['Mem']
      christianFaith = row['CF']
      bibleStudy = row['BS']
      smallEvent = row['SE']
      faculty = row['Faculty']
      extraNotes = row['extra notes']
      postGrad = row['Postgrad']

      if genderString == "f" || genderString == "m" then
        gender = genderString == "f" ? Gender::FEMALE : Gender::MALE
      else
        gender = Gender::UNKNOWN
      end


      if !cell.nil? then
        cell = cell.gsub(/\s+/, "")

        if !cell.match(/^0/) then
          cell = "0" << cell
        end

        cell = "27" << cell[1..-1]

        if cell.length != 11 then
          cell = ""
        end
      end

      res = nil

      if !residenceString.nil? then
        residenceString.downcase!
        case residenceString
          when "baxter hall"
            res = Residence::BAXTER_HALL
          when "baxter"
            res = Residence::BAXTER_HALL
          when "clarinus village"
            res = Residence::CLARINUS_VILLAGE
          when "claredon"
            res = Residence::CLARINUS_VILLAGE
          when "clarinus"
            res = Residence::CLARINUS_VILLAGE
          when "college house"
            res = Residence::COLLEGE_HOUSE
          when "college"
            res = Residence::COLLEGE_HOUSE
          when "forest hill"
            res = Residence::FOREST_HILL
          when "fuller hall"
            res = Residence::FULLER_HALL
          when "fuller"
            res = Residence::FULLER_HALL
          when "glenres"
            res = Residence::GLENRES
          when "glendower"
            res = Residence::GLENRES
          when "graca machel hall"
            res = Residence::GRACA_MACHEL_HALL
          when "graca"
            res = Residence::GRACA_MACHEL_HALL
          when "groote schuur"
            res = Residence::GROOTE_SCHUUR
          when "kilindini"
            res = Residence::KILINDINI
          when "kopano"
            res = Residence::KOPANO
          when "leo marquard"
            res = Residence::LEO_MARQUARD
          when "liesbeeck gardens"
            res = Residence::LIESBEECK_GARDENS
          when "liesbeeck"
            res = Residence::LIESBEECK_GARDENS
          when "liesbeek"
            res = Residence::LIESBEECK_GARDENS
          when "medical residence"
            res = Residence::MEDICAL_RESIDENCE
          when "obz square"
            res = Residence::OBZ_SQUARE
          when "rochester house"
            res = Residence::ROCHESTER_HOUSE
          when "rochester"
            res = Residence::ROCHESTER_HOUSE
          when "smuts hall"
            res = Residence::SMUTS_HALL
          when "smuts"
            res = Residence::SMUTS_HALL
          when "the woolsack"
            res = Residence::THE_WOOLSACK
          when "woolsack"
            res = Residence::THE_WOOLSACK
          when "tugwell hall"
            res = Residence::TUGWELL_HALL
          when "tugwell"
            res = Residence::TUGWELL_HALL
          when "university house"
            res = Residence::UNIVERSITY_HOUSE
          when "varietas"
            res = Residence::VARIETAS
        end

        if res.nil? then
          puts residenceString
        end
      end

      person = Person.create!(:name => firstName,
                              :surname => surname,
                              :email => email,
                              :cell => cell,
                              :gender => gender,)


      if !res.nil? then
        person.base_address = Res.create!(:residence => res, :room => roomNumber)
      else
        person.base_address = Address.create!(:address => residenceString)
      end

      StudentRole.create!({:party_id => person.id,
                           :faculty => faculty,
                           :member => member == 'x' ? 't' : 'f'})

      person.surveys << StandardSurvey.create!({
                                                   :investigate => christianFaith == 'x' ? 't' : 'f',
                                                   :bible_study => bibleStudy == 'x' ? 't' : 'f',
                                                   :small_event => smallEvent == 'x' ? 't' : 'f',
                                                   :notes => extraNotes,
                                               })

    end

    index
    render :index
  end

  def export_selected_to_excel
    @selectedParties = []
    params[:selected_ids_for_export].split(",").each { |id|
      party = Party.find(id)
      @selectedParties << party
    }

    workBook = Spreadsheet::Workbook.new
    list = workBook.create_worksheet :name => 'Search Results'
    list.row(0).concat ["Name",
                        "Surname",
                        "Email",
                        "Cell",
                        "Residence",
                        "Room Number",
                        "Gender",
                        "Member",
                        "Interested in investigating the faith",
                        "Interested in a Bible study",
                        "Interested in a small event",
                        "Faculty",
                        "Notes"
                       ]
    @selectedParties.each_with_index { |selectedParty, i|

      studentRole = selectedParty.getStudentRole
      survey = selectedParty.getLastSurvey

      list.row(i+1).push selectedParty.name,
                         selectedParty.surname,
                         selectedParty.email,
                         selectedParty.cell,
                         selectedParty.base_address.residence,
                         selectedParty.base_address.room,
                         selectedParty.gender,
                         studentRole == nil ? nil : studentRole.member,
                         survey == nil ? nil : survey.investigate,
                         survey == nil ? nil : survey.bible_study,
                         survey == nil ? nil : survey.small_event,
                         studentRole == nil ? nil : studentRole.faculty,
                         selectedParty.notes,
    }
    header_format = Spreadsheet::Format.new :weight => :bold
    list.row(0).default_format = header_format
    blob = StringIO.new("")
    workBook.write blob
    send_data blob.string, :type => :xls, :filename => "search_results.xls"
  end


  def add_to_group
    @party = Party.find_by_id(params[:party_id])
    if (!@party.nil?)
      @group = Group.find_by_id(params[:groups][:group_id])
      if (!@group.nil?)
        @group.addParty(@party)
      end
      render 'show'
    else
      redirect_to(root_path)
    end
  end

  def search
    index
    render :index
  end

  private

  def authenticate
    redirect_to(root_path) unless signed_in?
  end

end
