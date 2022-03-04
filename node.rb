# frozen_string_literal: true

# Node class with three attributes: data, left children, right children
class Node

  def initialize(data, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

end
