require 'minitest/autorun'
require 'minitest/pride'
require './lib/person.rb'

class PersonTest < Minitest::Test
  attr_reader :person
  def setup
    @person = Person.new("Minerva", 1000)
  end

  def test_person_exists
    assert_equal Person, person.class
  end

  def test_person_has_a_name
    assert_equal "Minerva", person.name
  end

  def test_person_has_an_amount_of_cash
    person_2 = Person.new("Harry", 500)
    assert person.cash
    assert_equal 1000, person.cash
    assert_equal 500, person_2.cash
  end

  def test_knows_who_they_bank_with
    assert person.banks
    person.banks_and_cash["JP Morgan Chase"] = 100
    person.banks_and_cash["Bitcoin"] = 50
    assert_equal 2, person.banks.count
    assert_equal ["JP Morgan Chase", "Bitcoin"], person.banks
  end
end
