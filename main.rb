# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
# :nodoc:
module Enumerable
  def my_each
    container = to_a
    block_given? ? container.size.times { |x| yield(container[x]) } : container
  end

  def my_each_with_index
    container = to_a
    block_given? ? container.size.times { |i| yield(i) } : container
  end

  def my_select
    container = to_a
    aux_container = []
    container.my_each { |el| aux_container << el if yield(el) }
    aux_container
  end

  def my_all?(arg = nil)
    container = to_a
    len = container.size
    condition = !container.empty? && arg.nil? ? false : true
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      if !arg.nil? && !arg.is_a?(Regexp)
        condition = container[counter].is_a?(arg)
      end
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
      counter += 1
      break if counter >= len || !condition
    end
    condition
  end

  def my_any?(arg = nil)
    container = to_a
    len = container.size
    condition = !container.empty? && arg.nil? ? true : false
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      if !arg.nil? && !arg.is_a?(Regexp)
        condition = container[counter].is_a?(arg)
      end
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
      counter += 1
      break if counter >= len || condition
    end
    condition
  end

  def my_none?(arg = nil)
    container = to_a
    len = container.size
    condition = !container.empty? && arg.nil? ? true : false
    counter = 0
    loop do
      condition = yield(container[counter]) if arg.nil? && block_given?
      condition = !container[counter].nil? if arg.nil? && !block_given?
      condition = container[counter].is_a?(arg) unless arg.is_a?(Regexp)
      if !arg.nil? && arg.is_a?(Regexp)
        condition = (arg.match(container[counter]) ? true : false)
      end
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
      container.my_each { |item| aux_container << proc.call(item) }
    elsif block_given? || proc.nil?
      container.my_each { |item| aux_container << yield(item) }
    elsif !proc.nil?
      container.my_each { |item| aux_container << proc.call(item) }
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

def multiply_els(arr)
  arr.my_inject :*
end

multiply_els([2, 4, 5])
# rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
