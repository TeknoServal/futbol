require './test/test_helper'
require './lib/game'
require 'CSV'

class GameTest < Minitest::Test

  def test_it_exists
    game_data = CSV.parse(File.read('./data/games.csv'), headers: true)

    game = Game.new(game_data[0])

    assert_instance_of Game, game
  end

  def test_it_has_attributes
    game_data = CSV.parse(File.read('./data/games.csv'), headers: true)

    game = Game.new(game_data[0])

    assert_equal '2012030221', game.game_id
    assert_equal '20122013', game.season
    assert_equal 'Postseason', game.type
    assert_equal '5/16/13', game.date_time
    assert_equal '3', game.away_team_id
    assert_equal '6', game.home_team_id
    assert_equal '2', game.away_goals
    assert_equal '3', game.home_goals
    assert_equal 'Toyota Stadium', game.venue
    assert_equal '/api/v1/venues/null', game.venue_link
  end
end