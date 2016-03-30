class SearchController < ApplicationController

# Upgrade 2.0.0 inizio
	extend GroupSupport
	
  def index
    current_group_identifier_set(params[:group_id])
    if isSearchAvailable?
      prv_search_execute
    else
      redirect_to current_context_searchunavailable_url
    end
  end

  def searchunavailable
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)
  end
# Upgrade 2.0.0 fine

  private

  def prv_search_execute
    begin
      starting = Integer(params[:start]) rescue 0
      ending   = Integer(params[:end])   rescue 0

      with = {}
      with[:start_year] = starting..DateTime.now.year unless starting.zero?
      with[:end_year] = 0..ending unless ending.zero?
      with[:root_fond_id] = params[:root_fond_id] unless params[:root_fond_id].blank?
# Upgrade 2.0.0 inizio
# vedi http://stackoverflow.com/questions/6610426/cancan-thinking-sphinx-current-ability-questions
# negli indici e' stato aggiunto anche group_id in modo da poterlo usare per impostare una condizione di filtro in piu'
			group_id = SearchController.get_group_id_from_params(params, :group_id)
			if group_id != -1
        with[:group_id] = group_id
			end
      current_group_identifier_set(params[:group_id])
      @group = SiteController.get_group_from_params(params, :group_id)
# Upgrade 2.0.0 fine

      without = {}
      without[:digital_object_id ] = 0 if params[:dob].to_i == 1

      scopes = [Fond, Unit, Creator, Custodian]

      prv_counts_by_scopes(scopes, with, without)

      scopes.delete_if {|x| x != params[:scope].camelize.constantize } if params[:scope].present?

      # TODO: completare aggiornamento del codice
      # ==> http://pat.github.io/thinking-sphinx/upgrading.html

      # FIXME: q.downcase non necessario + vedi Riddle::Query.escape

      params[:sort] ||= 'weight'
      order = params[:sort] == 'weight' ? 'weight() DESC' : 'order_date ASC'

      @results = ThinkingSphinx.search(params[:q].downcase,
        :with => with,
        :without => without,
        # FIXME: diminuire numero di query
        # :sql => {:include => [:first_digital_object, :preferred_name, :preferred_event]},
        :sql => {:include => :first_digital_object},
        :page => params[:page],
        :per_page => 20,
        :field_weights => {
          :display_name  => 5,
          :content => 3,
        },
        :excerpts => {
          :before_match    => '<b>',
          :after_match     => '</b>',
          :chunk_separator => ' &#8230; '
        },
        # # opzione non piu' esistente ?
        # :excerpts => {
        #  :limit_words => 100
        # },
        # :match_mode => :extended, # The match mode is always extended - SphinxQL doesn't know any other way.
        # # opzione non piu' esistente ?
        # :sort_mode => :extended,
        :order => order,
        :classes => scopes)

      @results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane

      if scopes.include?(Unit)
        @facets = Unit.facets(params[:q].downcase, :with => with.reject{|k, v| k == :root_fond_id}, :without => without)
        @facets = @facets[:root_fond_id].sort_by{|a| a[1]}.reverse
        if @facets.size > 20
          @other_facets = @facets.slice(20, @facets.size - 1)
          @facets = @facets.slice(0, 19)
        end
      end

      prv_paths_of(@results)

    end
  rescue Exception => e
    ThinkingSphinx::SphinxError
  end

# Upgrade 2.0.0 inizio
# rinominata da counts_by_scopes a prv_counts_by_scopes
# Upgrade 2.0.0 fine
  def prv_counts_by_scopes(scopes, with, without)
    @counts = ActiveSupport::OrderedHash.new
    scopes.each do |klass|
      facet = klass.facets(params[:q].downcase, :class_facet => true, :with => with, :without => without)
      @counts[klass.name.downcase.pluralize] = Integer(facet[:class][klass.to_s]) rescue 0
    end
  end

# Upgrade 2.0.0 inizio
# rinominata da paths_of a prv_paths_of
# Upgrade 2.0.0 fine
  def prv_paths_of(results)
    @paths = {}
    results.each do |result|
      path = []
      case result.class.name.downcase
      when 'unit'
        unless @paths.has_key?(result.fond_id)
          result.fond.path_items.each do |fond|
            path << fond.name
          end
          @paths[result.fond_id] = path.join(' / ')
        end
      when 'fond'
        unless @paths.has_key?(result.id)
          result.path_items.each do |fond|
            path << fond.name
          end
          @paths[result.id] = path.join(' / ')
        end
      end
    end
  end

end