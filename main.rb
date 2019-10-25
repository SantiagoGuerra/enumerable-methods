module Enumerable
  def my_each
    container = self.to_a
    if block_given?
      (container.size).times do |x|
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

  def my_all?
    container = to_a
    len = container.size
    condition = true
    counter = 0
    loop do
      condition = yield(container[counter])
      counter += 1
      break if counter >= len || !condition
    end
    condition
  end

  def my_any?
    container = to_a
    len = container.size
    condition = true
    counter = 0
    loop do
      condition = yield(container[counter])
      counter += 1
      break if counter >= len || condition
    end
    condition
  end

end
