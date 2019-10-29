# frozen_string_literal: true

module Enumerable

  def my_each
    container = to_a
    if block_given?
      container.size.times do |x|
        yield(container[x])
      end
    else
      container
    end
  end

  def my_each_with_index
    container = to_a
    if block_given?
      container.size.times do |i|
        yield(i)
      end
    else
      container
    end
  end

  def my_select
    container = to_a
    aux_container = []
    container.my_each do |el|
      aux_container << el if yield(el)
    end
    aux_container
  end

  def my_all?(pattern = nil)
    container = to_a
    len = container.size
    condition = !container.empty? && pattern.nil? ? false : true
    counter = 0
    loop do
      condition = yield(container[counter]) if pattern.nil? && block_given?
      condition = container[counter].is_a?(pattern) if !pattern.nil? && !pattern.is_a?(Regexp)
      condition = (pattern.match(container[counter]) ? true : false) if !pattern.nil? && pattern.is_a?(Regexp)
      counter += 1
      break if counter >= len || !condition
    end
    condition 
  end

  def my_any?(pattern = nil)
    container = to_a
    len = container.size
    condition = !container.empty? && pattern.nil? ? true : false
    counter = 0
    loop do
      condition = yield(container[counter]) if pattern.nil? && block_given?
      condition = container[counter].is_a?(pattern) if !pattern.nil? && !pattern.is_a?(Regexp)
      condition = (pattern.match(container[counter]) ? true : false) if !pattern.nil? && pattern.is_a?(Regexp)
      counter += 1
      break if counter >= len || condition
    end
    condition 
  end

  def my_none? pattern = nil
    container = to_a
    len = container.size
    condition = !container.empty? && pattern.nil? ? true : false
    counter = 0
    loop do
      condition = yield(container[counter]) if pattern.nil? && block_given?
      condition = !!container[counter] if pattern.nil? && !block_given?
      condition = container[counter].is_a?(pattern) if !pattern.nil? && !pattern.is_a?(Regexp)
      condition = (pattern.match(container[counter]) ? true : false) if !pattern.nil? && pattern.is_a?(Regexp)
      counter += 1
      break if counter >= len || condition
    end
    !condition 
  end

  def my_count(*num)
    container = to_a
    if block_given?
      container.my_select { |item| yield(item) }.size
    elsif num.empty?
      container.size
    else
      container.my_select { |item| item == num[0] }.size
    end
  end

  def my_map(proc = nil)
    container = to_a
    aux_container = []
    if !proc.nil? && block_given?
      container.my_each { |item| aux_container << proc.call(item)}
    elsif block_given? || proc.nil?
      container.my_each { |item| aux_container << yield(item) }
    elsif !proc.nil? 
      container.my_each { |item| aux_container << proc.call(item)}
    end
    aux_container
  end

  def my_inject(*args)
    container = to_a
    initial = container.shift
    container.unshift args[0] if args[0].class != Symbol && !args.empty?
    container.my_each do |item|
      initial = yield(initial, item) if block_given?
      initial = initial.send(args[1], item) if args[1].class == Symbol
      initial = initial.send(args[0], item) if args[0].class == Symbol
    end
    initial
  end
end

def multiply_els arr
  arr.my_inject :*
end

multiply_els([2,4,5])
