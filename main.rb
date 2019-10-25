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
end