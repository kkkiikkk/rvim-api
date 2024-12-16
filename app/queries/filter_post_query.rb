class FilterPostQuery
  attr_reader :records, :params

  def initialize(records, params)
    @records = records
    @params = params
  end

  def call
    @records = @records.filter_by_year(@params[:year]) if @params[:year].present?
    @records = @records.seach_by_title(@params[:title]) if @params[:title].present?
    @records = @records.filter_by_category(@params[:category_id]) if @params[:category_id].present?

    @records
  end
end
