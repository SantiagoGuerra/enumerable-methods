# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/ModuleLength
# :nodoc:
module Enumerable
  def my_each
    container = to_a
    block_given? ? container.size.times { |x| yield(container[x]) } : to_enum(:my_each)
  end

  def my_each_with_index
    container = to_a
    if block_given?
      container.size.times { |index| yield(container[index], index) }
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    container = to_a
    aux_container = []
    if block_given?
      container.my_each { |el| aux_container << el if yield(el) }
      aux_container
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_all?(arg = nil)
    container = to_a
    len = container.size
    condition = true
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      condition = container[counter] == arg if arg.is_a?(Integer)
      condition = container[counter] == arg if arg.is_a?(String)
      if !arg.nil? && !arg.is_a?(Regexp) && !arg.is_a?(Integer)
        condition = container[counter].is_a?(arg)
      end
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
      if arg.nil? && !block_given?
        condition = container[counter] ? true : false
      end
      counter += 1
      break if counter >= len || !condition
    end
    condition = len.zero? ? true : condition
  end

  def my_any?(arg = nil)
    container = to_a
    len = container.size
    condition = true
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      condition = container[counter] == arg if arg.is_a?(Integer)
      condition = container[counter] == arg if arg.is_a?(String)
      if !arg.nil? && !arg.is_a?(Regexp) && !arg.is_a?(Integer) && !arg.is_a?(String)
        condition = container[counter].is_a?(arg)
      end
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
      if arg.nil? && !block_given?
        condition = container[counter] ? true : false
      end
      counter += 1
      break if counter >= len || condition
    end
    condition = len.zero? ? true : condition
  end

  def my_none?(arg = nil)
    container = to_a
    len = container.size
    condition = true
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      condition = container[counter] == arg if arg.is_a?(Integer)
      condition = container[counter] == arg if arg.is_a?(String)
      if !arg.nil? && !arg.is_a?(Regexp) && !arg.is_a?(Integer) && !arg.is_a?(String)
        condition = container[counter].is_a?(arg)
      end
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
      if arg.nil? && !block_given?
        condition = container[counter] ? true : false
      end
      counter += 1
      break if counter >= len || condition
    end
    condition = len.zero? ? true : !condition
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
    if block_given? && !proc.nil?
      container.my_each { |item| aux_container << proc.call(item) }
      aux_container
    end
    if proc.nil? && block_given?
      container.my_each { |item| aux_container << yield(item) }
      aux_container
    elsif proc.nil? && !block_given?
      to_enum(:my_map)
    end
  end

  def my_inject(*args)
    container = to_a
    aux_container = container.clone
    initial = aux_container.shift
    aux_container.unshift args[0] if args[0].class != Symbol && !args.empty?
    aux_container.my_each do |item|
      initial = yield(initial, item) if block_given?
      initial = initial.send(args[1], item) if args[1].class == Symbol
      initial = initial.send(args[0], item) if args[0].class == Symbol
    end
    initial
  end
end

def multiply_els(arr)
  arr.my_inject :*
end

multiply_els([2, 4, 5])

# rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/ModuleLength
