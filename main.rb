# frozen_string_literal: true

require_relative 'tree'

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
p tree.build_tree tree.children
