module ValidationPredicates
  def length(n)
    -> (s) { s.length == n }
  end

  def min_length(n)
    ->(s) { s.length >= n }
  end

  def max_length(n)
    -> (s) { s.length <= n }
  end

  def min(n)
    -> (s) { s >= n }
  end

  def valid_year
    ->(y) { (y.to_s.length == 4) && (y.to_i > Time.now.year - 1) }
  end

  def one_of(thing)
    ->(t) { thing.include? t }
  end

  def other_attr_eq(attr, val)
    ->(model) { model.respond_to?(attr) && model.send(attr) == val }
  end
end
