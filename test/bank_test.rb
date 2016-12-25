require 'minitest/autorun'
require 'minitest/pride'
require './lib/person.rb'
require './lib/bank.rb'


class BankTest < Minitest::Test
  attr_reader :bank,
              :person
  def setup
    @bank = Bank.new("Wells Fargo")
    @person = Person.new("Minerva", 1000)
  end

  def test_it_exists
    assert bank
    assert_equal Bank, bank.class
  end

  def test_it_has_a_name
    assert_equal "Wells Fargo", bank.name
  end

  def test_can_open_account_for_a_person
    assert bank.open_account(person)
    assert_equal 1, person.banks_and_cash.count
    assert person.banks_and_cash.keys.include?("Wells Fargo")
    assert_equal 0, person.banks_and_cash["Wells Fargo"]
  end

  def test_can_make_deposit_into_accounts_for_person
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
  end

  def test_can_make_withdrawal_for_person
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
    bank.withdrawal(person, 250)
    assert_equal 500, person.banks_and_cash[bank.name]
    assert_equal 500, person.cash
  end

  def test_will_not_allow_person_to_overdraft
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
    assert_equal "Insufficient funds", bank.withdrawal(person, 800)
  end

  def test_can_transfer_money_to_another_bank
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
    bank_2 = Bank.new("Bitcoin")
    bank_2.open_account(person)
    assert bank.transfer(person, bank_2, 250)
    assert_equal 500, person.banks_and_cash[bank.name]
    assert_equal 250, person.banks_and_cash[bank_2.name]
  end

  def test_cannot_transfer_more_money_than_balance
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
    bank_2 = Bank.new("Bitcoin")
    bank_2.open_account(person)
    assert bank.transfer(person, bank_2, 250)
    assert_equal 500, person.banks_and_cash[bank.name]
    assert_equal 250, person.banks_and_cash[bank_2.name]
    assert_equal "Insufficient funds", bank_2.transfer(person, bank, 300)
  end

  def test_cannot_transfer_money_to_or_from_bank_without_account
    assert_equal 1000, person.cash
    bank.open_account(person)
    assert bank.deposit(person, 750)
    assert_equal 250, person.cash
    assert_equal 750, person.banks_and_cash[bank.name]
    bank_2 = Bank.new("Bitcoin")
    # bank_2.open_account(person)
    message = "#{person.name} does not have an account with #{bank_2.name}"
    assert_equal message, bank.transfer(person, bank_2, 250)
  end

end
