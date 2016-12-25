class Person
  attr_reader :name,
              :cash,
              :banks_and_cash
  def initialize(name, cash)
    @name = name
    @cash = cash
    @banks_and_cash = Hash.new
  end

  def banks
    @banks_and_cash.keys
  end
end
