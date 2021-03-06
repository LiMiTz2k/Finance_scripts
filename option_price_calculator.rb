# version 1.00
# This is a option price calculator script that works through command line.
# Users will be able to calculate the price of a European option under the black-scholes model.
# Users will also be able to calculate the price of a European option when the underlying asset pays a dividend.
# users will also be able to calculate delta, vega, rho and theta for the underlying European options.


require 'rubystats'


puts "Welcome to Kofi's option price calculator"


class Asset
  include Math

attr_accessor :initial_price, :interest_rate, :volatility

# interest_rate, volatility - percentages i.e 1% = 1, initial_price is a real number
def initialize(initial_price, interest_rate, volatility)
  @initial_price = initial_price
  @interest_rate = interest_rate / 100
  @volatility = volatility / 100
end

# returns the no-arbitrage spot price for the underlying asset s(t) with initial price s(0) // this is a model independent result, so the underlying asset could follow a levy-process or Geometric brownian motion
def spot(time)
  @initial_price * Math.exp(@interest_rate * time )
end

# Here we assume the asset price s(t) follows a Geometric Brownian motion. This is reflected in the following function
def option_price(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility)* Math.sqrt(time)
  d2 = d1 -  @volatility * Math.sqrt(time)
  puts "Do you want the price for a put or call option?"
  response = gets.chomp.downcase
  if response == "call"
    Math.exp( - @interest_rate * time ) * ( spot(time) * norm.cdf(d1) - strike * norm.cdf(d2))
  elsif response == "put"
    Math.exp( - @interest_rate * time ) * ( - spot(time) * norm.cdf(-d1) + strike * norm.cdf(-d2))
  else
    puts "Sorry I didn't get that. Please try again."
    option_price(strike, time)
  end
end

# delta is the rate of change of option price with respect to spot
def delta(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility)* Math.sqrt(time)
  puts "Do you want the delta for a put or call option?"
  response = gets.chomp.downcase
  if response == "call"
    norm.cdf(d1)
  elsif response == "put"
    norm.cdf(d1) - 1
  else
    puts "Sorry I didn't get that. Please try again."
    delta(strike, time)
  end
end

# vega is the rate of change of option price with respect to volatility
def vega(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility)* Math.sqrt(time)
  puts "Do you want the vega for a put or call option?"
  response = gets.chomp.downcase
  if response == "call"
    norm.pdf(d1) * spot(time) * Math.sqrt(time)
  elsif response == "put"
    norm.pdf(d1) * spot(time) * Math.sqrt(time)
  else
    puts "Sorry I didn't get that. Please try again."
    vega(strike, time)
  end
end

# rho is the rate of change of option price with respect to interest rate
def rho(strike, time)
  norm = Rubystats::NormalDistribution.new(0,1)
  d1 = Math.log(spot(time) / strike) + 0.5 * (@volatility)* Math.sqrt(time)
  d2 = d1 - @volatility * Math.sqrt(time)
  puts "Do you want the rho for a put or call option?"
  response = gets.chomp.downcase
  if response == "call"
    #
  elsif response == "put"
    #
  else
    puts "Sorry I didn't get that. Please try again. "
    rho(strike, time)
  end
end

end

p = Asset.new(20, 0.50, 20.00)

puts p.delta(40, 1)
puts p.vega(40, 1)
