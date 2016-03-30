module HasArchidate

  attr_accessor  :archidate_class_name

  def has_many_archidates

    self.archidate_class_name = "#{self.name}Event"

# Upgrade 2.0.0 inizio
=begin
    has_many :events,
      :class_name => archidate_class_name,
      :order => 'preferred DESC, order_date'

    has_one :preferred_event,
      :class_name => archidate_class_name,
      :conditions => {:preferred => true}
=end
    has_many :events,
      -> { order 'preferred DESC, order_date' },
      :class_name => archidate_class_name

    has_one :preferred_event,
      -> { where :preferred == true },
      :class_name => archidate_class_name
# Upgrade 2.0.0 fine
  end

  def archidate_class
    @archidate_class ||= archidate_class_name.constantize
  end

  def archidate_table
    @archidate_table ||= archidate_class.table_name
  end

end
