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
      params[:selected_ids].split(",").each { |id|
        party = Party.find(id)
        if (!party.nil?)
          group.parties << party
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

  def export_selected_to_excel
    @selectedParties = []
    params[:selected_ids_for_export].split(",").each { |id|
      party = Party.find(id)
      @selectedParties << party
    }



    #respond_to do |format|
    #  format.xls {
    #    workBook = Spreadsheet::Workbook.new
    #    list = workBook.create_worksheet :name => 'Search Results'
    #    list.row(0).concat %w{Name Surname}
    #    @selectedParties.each_with_index { |selectedParty, i|
    #      list.row(i+1).push selectedParty.name, selectedParty.surname
    #    }
    #    #header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
    #    #list.row(0).default_format = header_format
    #    #output to blob object
    #    blob = StringIO.new("")
    #    workBook.write blob
    #    #respond with blob object as a file
    #    send_data blob.string, :type => :xls, :filename => "search_results.xls"
    #  }
    #end
        workBook = Spreadsheet::Workbook.new
        list = workBook.create_worksheet :name => 'Search Results'
        list.row(0).concat %w{Name Surname}
        @selectedParties.each_with_index { |selectedParty, i|
          list.row(i+1).push selectedParty.name, selectedParty.surname
        }
        #header_format = Spreadsheet::Format.new :color => :green, :weight => :bold
        #list.row(0).default_format = header_format
        #output to blob object
        blob = StringIO.new("")
        workBook.write blob
        #respond with blob object as a file
        send_data blob.string, :type => :xls, :filename => "search_results.xls"



  end


  def add_to_group
    @party = Party.find_by_id(params[:party_id])
    if (!@party.nil?)
      @group = Group.find_by_id(params[:groups][:group_id])
      if (!@group.nil?)
        @group.parties << @party
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
