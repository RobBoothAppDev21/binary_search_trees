# frozen_string_literal: true

require_relative 'node'
require 'pry-byebug'

# Tree class - takes an array when initialized and has a root attribute
class Tree
  attr_accessor :root, :children

  def initialize(array)
    @children = clean_array(array)
    @root = build_tree(children)
  end

  def clean_array(array)
    array.sort.uniq
  end

  def build_tree(array)
    return nil if array.empty?

    mid_index = (array.size - 1) / 2
    root = Node.new(data: array[mid_index])

    root.left = build_tree(array[0...mid_index])
    root.right = build_tree(array[(mid_index + 1)..array.size])
    # binding.pry
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  # def search(root, value)
  #   return root if root.ni? || root == value

  #   return search(root.right, value) if root.data < value
  #   return search(root.left, value) if root.data < value
  # end

  def insert(root, value)
    return Node.new(data: value) if root.nil?

    if root.data == value
      root
    elsif root.data < value
      root.right = insert(root.right, value)
    else
      root.left = insert(root.left, value)
    end
    root
  end

  def min_value_node(node)
    current = node

    current = current.left until current.left.nil?

    current
  end

  def delete(root, value)
    return root if root.nil?

    if value < root.data
      root.left = delete(root.left, value)
    elsif value > root.data
      root.right = delete(root.right, value)
    else
      if root.left.nil?
        temp = root.right
        root = nil
        return temp
      elsif root.right.nil?
        temp = root.left
        root = nil
        return temp
      end

      temp = min_value_node(root.right)

      root.data = temp.data

      root.right = delete(root.right, temp.data)
    end

    root
  end

  def find(root, value)
    return root if root.nil? || value == root.data

    value > root.data ? find(root.right, value) : find(root.left, value)
  end

  def level_order(root, output = [], &block)
    if block_given?
      yield
    end

    return if root.nil?

    queue = []
    queue.push root

    until queue.empty?
      # binding.pry
      current_node = queue.first
      output.push current_node.data
      queue.push(current_node.left) unless current_node.left.nil?
      queue.push(current_node.right) unless current_node.right.nil?
      queue.delete_at(0)
    end
    output
  end

  def inorder(root, output = [], &block)
    return if root.nil?

    inorder(root.left, output, &block)
    output.push(block_given? ? block.call(root) : root.data)
    inorder(root.right, output, &block)
    output
  end

  def preorder(root, output = [], &block)
    return if root.nil?

    output.push(block_given? ? block.call(root) : root.data)
    preorder(root.left, output, &block)
    preorder(root.right, output, &block)
    output
  end

  def postorder(root, output = [], &block)
    return if root.nil?

    postorder(root.left, output, &block)
    postorder(root.right, output, &block)
    output.push(block_given? ? block.call(root) : root.data)
    output
  end

  def height(node, count = -1)
    return count if node.nil?

    count += 1
    [height(node.left, count), height(node.right, count)].max
  end

  def depth(node)
    return nil if node.nil?

    current_node = root
    count = 0
    until current_node.data == node.data
      count += 1
      current_node = current_node.left if node.data < current_node.data
      current_node = current_node.right if node.data < current_node.data
    end
    count
  end

  def balanced?
    left = height(root.left, 0)
    right = height(root.right, 0)
    (left - right).between?(-1, 1)
  end

  def rebalance!
    values = inorder(root)
    self.root = build_tree(values)
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
tree.build_tree tree.children
tree.pretty_print
# tree.insert(tree.root, 2)
tree.insert(tree.root, 6000)
tree.insert(tree.root, 5000)
# tree.pretty_print
# tree.delete tree.root, 3
tree.pretty_print
# p tree.find(tree.root, 3)
# p tree.level_order(tree.root)
# p tree.inorder(tree.root)
# p tree.preorder(tree.root)
# p tree.postorder(tree.root)
# p tree.height(tree.root)
# p tree.depth(tree.root)
p tree.balanced?
tree.rebalance!
tree.pretty_print
p tree.balanced?
