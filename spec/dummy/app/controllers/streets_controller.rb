class StreetsController < ApplicationController
  has_crud_actions
  nested_of Country
  nested_of City
=begin
  before_filter :load_nested

  # GET /streets
  # GET /streets.json
  def index
    @streets = @city.streets

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @streets }
    end
  end

  # GET /streets/1
  # GET /streets/1.json
  def show
    @street = @city.streets.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @street }
    end
  end

  # GET /streets/new
  # GET /streets/new.json
  def new
    @street = @city.streets.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @street }
    end
  end

  # GET /streets/1/edit
  def edit
    @street = @city.streets.find(params[:id])
  end

  # POST /streets
  # POST /streets.json
  def create
    @street = @city.streets.build(params[:street])

    respond_to do |format|
      if @street.save
        format.html { redirect_to [@country, @city, @street], notice: 'Street was successfully created.' }
        format.json { render json: @street, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /streets/1
  # PUT /streets/1.json
  def update
    @street = @city.streets.find(params[:id])

    respond_to do |format|
      if @street.update_attributes(params[:street])
        format.html { redirect_to [@country, @city, @street], notice: 'Street was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @street.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streets/1
  # DELETE /streets/1.json
  def destroy
    @street = @city.streets.find(params[:id])
    @street.destroy

    respond_to do |format|
      format.html { redirect_to country_city_streets_url(@country, @city) }
      format.json { head :no_content }
    end
  end

  private

  def load_nested
    @country = Country.find(params[:country_id])
    @city = @country.cities.find(params[:city_id])
  end
=end
end
