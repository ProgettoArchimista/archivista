module Tree

# Upgrade 2.0.0 inizio
#  def fast_subtree_to_jstree_hash(prepared_subtree=nil)
  def fast_subtree_to_jstree_hash(str_group_context_path, prepared_subtree=nil)
# Upgrade 2.0.0 fine
	prepared_subtree ||= subtree.select_for_tree.active.order_for_tree

# Upgrade 2.0.0 inizio
=begin
    groups = break_groups_by_key(prepared_subtree,
      :key => 'ancestor_ids',
      :attr => 'prepared_jstree_hash',
      :seed => true)
=end
    groups = break_groups_by_key(prepared_subtree,
      :key => 'ancestor_ids',
      :attr => 'prepared_jstree_hash',
      :group_context_path => str_group_context_path,
      :seed => true)
# Upgrade 2.0.0 fine

    list = [groups.first.second]

    groups[1..-1].each do |ancestor_ids, *hashes|
      target_element = find_in_nested_list(list, ancestor_ids[depth..-1])
      target_element[:children] = hashes if target_element
    end

    list
  end

# Upgrade 2.0.0 inizio
=begin
  def to_jstree_hash
    {
      :data => {
        :title => name,
        :attr => {
          :href => "/fonds/#{id}",
          :class => "changeable",
        }
      },
      :attr => {
        :id => "node-#{id}",
        :class => "node",
        :'data-units' => units_count
      }
    }
  end
=end
  def to_jstree_hash(str_group_context_path)
    {
      :data => {
        :title => name,
        :attr => {
          :href => "#{str_group_context_path}/fonds/#{id}",
          :class => "changeable",
        }
      },
      :attr => {
        :id => "node-#{id}",
        :class => "node",
        :'data-units' => units_count
      }
    }
  end
# Upgrade 2.0.0 fine

# Upgrade 2.0.0 inizio
=begin
  def prepared_jstree_hash
    {:id => id}.update(to_jstree_hash)
  end
=end
  def prepared_jstree_hash(str_group_context_path)
    {:id => id}.update(to_jstree_hash(str_group_context_path))
  end
# Upgrade 2.0.0 fine

  def break_groups_by_key(array, opts={})

    return self if array.empty?

    seed        = opts[:seed]
    key_attr    = opts[:key].to_sym
    group_attr  = opts[:attr].to_sym
# Upgrade 2.0.0 inizio
    str_group_context_path = opts[:group_context_path]
# Upgrade 2.0.0 fine

    groups = []

    # seed the groups
    if seed || array.size == 1
# Upgrade 2.0.0 inizio
#      groups << [array.first.send(key_attr), array.first.send(group_attr)]
# Upgrade 2.0.0 fine
      groups << [array.first.send(key_attr), array.first.send(group_attr, str_group_context_path)]
    end

    # create the groups
# Upgrade 2.0.0 inizio
=begin
    array.each_cons(2) do |a,b|
      if b.send(key_attr) != a.send(key_attr)
        groups << [b.send(key_attr), b.send(group_attr)]
      else
        groups.last << b.send(group_attr)
      end
    end
=end
    array.each_cons(2) do |a,b|
      if b.send(key_attr) != a.send(key_attr)
        groups << [b.send(key_attr), b.send(group_attr, str_group_context_path)]
      else
        groups.last << b.send(group_attr, str_group_context_path)
      end
    end
# Upgrade 2.0.0 fine

    groups
  end

  def find_in_nested_list(list, ids)
    last_id = ids.pop

    element_before_last = ids.inject(list) do |restricted_list, current_id|
      restricted_list.find{|el| el[:id] == current_id}[:children]
    end

    element_before_last.find{|el| el[:id] == last_id}
  end

end
