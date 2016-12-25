require_relative 'person'
require 'pry'
class Bank
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def open_account(person)
    person.banks_and_cash[@name] = 0
  end

  def deposit(person, amount)
    person.banks_and_cash[@name] += amount
    person.cash -= amount
  end

  def withdrawal(person, amount)
    if person.cash >= amount
      person.banks_and_cash[@name] -= amount
      person.cash += amount
    else
      "Insufficient funds"
    end
  end

  def transfer(person, bank, amount)
    if person.banks_and_cash.keys.include?(bank.name)
      if person.banks_and_cash[@name] >= amount
        person.banks_and_cash[@name] -= amount
        person.banks_and_cash[bank.name] += amount
      else
        "Insufficient funds"
      end
    else
      "#{person.name} does not have an account with #{bank.name}"
    end
  end
end
