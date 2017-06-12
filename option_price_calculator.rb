# version 1.00
# This is a option price calculator script that works through command line.
# Users will be able to calculate the price of a European option under the black-scholes model.
# Users will also be able to calculate the price of a European option when the underlying asset pays a dividend.
# users will also be able to calculate delta, vega, rho and theta for the underlying European options.


require 'rubystats'


puts "Welcome to Kofi's option price calculator"


class Asset
  include Math

attr_accessor :initial_price, :dividend_yield, :interest_rate, :volatility

# interest_rate, volatility and dividend_yield - percentages i.e 1% = 1, initial_price is a real number
def initialize(initial_price, dividend_yield, interest_rate, volatility)
  @initial_price = initial_price
  @dividend_yield = dividend_yield
  @interest_rate = interest_rate
  @volatility = volatility
end

# returns the no-arbitrage spot price for the underlying asset s(t) with initial price s(0) // this is a model independent result, so the underlying asset could follow a levy-process or Geometric brownian motion
def spot(time)
  @initial_price*Math.exp((@interest_rate - @dividend_yield)*time / 100 )
end


# Here we assume the asset price s(t) follows a Geometric Brownian motion. This is reflected in the following function
def call_price(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility / 100 )* Math.sqrt(time)
  d2 = d1 - ( @volatility / 100 ) * Math.sqrt(time)
  Math.exp(- (@interest_rate * time / 100))*(spot(time) * norm.cdf(d1) - strike * norm.cdf(d2))
end


def put_price(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility / 100) * Math.sqrt(time)
  d2 = d1 - (@volatility / 100) * Math.sqrt(time)
  Math.exp( -(interest_rate * time) / 100  ) * ( - spot(time) * norm.cdf(-d1) + strike * norm.cdf(-d2))
end


end


p = Asset.new(40, 0, 1.5, 27)

puts p.put_price(35, 0.5)
