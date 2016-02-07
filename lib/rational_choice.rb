# Tiny fuzzy-logic gate for making choices based on a continuum of permitted values
# as opposed to a hard condition.
module RationalChoice
  VERSION = '2.0.0'
  
  # Gets raised when a multidimensional choice has to be made with a wrong number
  # of values versus the number of dimensions
  CardinalityError = Class.new(ArgumentError)
  
  # Gets raised when a dimension has to be created with the same parameters
  DomainError = Class.new(ArgumentError)
  
  # Represents a fuzzy choice on a single dimension (one real number)
  class Dimension
    # Initializes a new Dimension to evaluate values
    #
    # @param false_at_or_below[#to_f, #<=>] the lower bound, at or below which the value will be considered false
    # @param true_at_or_above[#to_f, #<=>] the upper bound, at or above which the value will be considered true
    def initialize(false_at_or_below: , true_at_or_above:)
      raise DomainError, "Bounds were the same at #{false_at_or_below}" if false_at_or_below == true_at_or_above
      
      @lower, @upper = [false_at_or_below, true_at_or_above].sort
      @flip_sign = [@lower, @upper].sort != [false_at_or_below, true_at_or_above]
    end
    
    # Evaluate a value against the given false and true bound.
    #
    # If the value is less than or equal to the false bound, the method will return `false`.
    # If the value is larger than or equal to the true bound, the method will return 'true'.
    #
    # If the value is between the two bounds, the method will first determine the probability
    # of the value being true, based on a linear interpolation.
    # For example:
    #
    #     d = Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
    #     d.choose(0) # => false
    #     d.choose(1) # => true
    #     d.choose(0.5) #=> will be `true` in 50% of the cases (probability of 0.5)
    #     d.choose(0.1) #=> will be `true` in 10% of the cases (probability of 0.1)
    #
    # Primary use is for things like load balancing. Imagine you have a server handling 14 connections,
    # and you know that it can take about 20 maximum. When you decide whether to send the connection
    # number 17 to it, you want to take a little margin and only send that connection sometimes, to
    # balance the choices - so you want to use a softer bound (a bit of a fuzzy logic).
    #
    #     # 10 connactions is doable, 20 connections means contention
    #     will_accept_connection = Dimension.new(false_at_or_below: 20, true_at_or_above: 10)
    #     will_accept_connection.choose(server.current_connection_count + 1) # will give you a fuzzy choice
    #
    # @param value[#to_f, Comparable] a value to be evaluated (must be coercible to a Float and Comparable)
    # @return [Boolean] the chosen value based on probability and randomness
    def choose(value)
      choice = if fuzzy?(value)
        # Interpolate the probability of the value being true
        delta = @upper.to_f - @lower.to_f
        v = (value - @lower).to_f
        t = (v / delta)
    
        r = Random.new # To override in tests if needed
        r.rand < t
      else
        # just seen where it is (below or above)
        value >= @upper
      end
      choice ^ @flip_sign
    end
    
    # Tells whether the evaluation will use the probabilities or not
    # (whether the given value is within the range where probability evaluation will take place).
    #
    # @param value[Comparable] a value to be evaluated (must be comparable)
    # @return [Boolean] whether choosing on this value will use probabilities or not
    def fuzzy?(value)
      value > @lower && value < @upper
    end
  end
  
  # Performs an evaluation based on multiple dimensions. The dimensions
  # will be first coerced into one (number of truthy evaluations vs. number of falsey evaluations)
  # and then a true/false value will be deduced from that.
  class ManyDimensions
    def initialize(*dimensions)
      @dimensions = dimensions
      raise CardinalityError, "%s has no dimensions to evaluate" % inspect if @dimensions.empty?
    end
    
    # Performs a weighted choice, by first collecting choice results from all the dimensions,
    # and then by interpolating those results by the ratio of truthy values vs falsey values.
    #
    #     x = Dimension.new(0,1)
    #     y = Dimension.new(0,1)
    #     z = Dimension.new(0,1)
    #     
    #     within_positive_3d_space = ManyDimensions.new(x, y, z)
    #     within_positive_3d_space.choose(-1, -1, -0.5) #=> false
    #     within_positive_3d_space.choose(1.1, 123, 1) #=> true
    #     within_positive_3d_space.choose(1, 0.5, 0.7) #=> true or false depending on 3 probabilities
    #
    # @param values[Array<Comparable,#to_f>] an array of values of the same size as the `dimensions` given to `initialize`
    # @return [Boolean] true or false
    def choose(*values)
      if @dimensions.length != values.length
        raise CardinalityError, "%s has %d dimensions but %d values were given" % [inspect, @dimensions.length, values.length]
      end
      
      evaluations = values.zip(@dimensions).map { |(v, d)| d.choose(v) }
      num_truthy_choices = evaluations.select{|e| e}.length
      
      Dimension.new(false_at_or_below: 0, true_at_or_above: evaluations.length).choose(num_truthy_choices)
    end
  end
end
