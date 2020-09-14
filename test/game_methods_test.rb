# frozen_string_literal: true

require './test/test_helper'
require './lib/game_methods'

class GameMethodsTest < Minitest::Test
  def setup
    @games_path = './data/games.csv'
    @teams_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'

    locations = {
      games: @games_path,
      teams: @teams_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)
  end

  def test_it_exists
    game_methods = GameMethods.new('./test/csv_test.csv', @stat_tracker)

    assert_instance_of GameMethods, game_methods

    assert_equal './test/csv_test.csv', game_methods.file_loc
  end

  def test_generates_games
    file_loc = './test/csv_test.csv'

    game_methods = GameMethods.new(file_loc, @stat_tracker)

    game_methods.games.each do |game|
      assert_instance_of Game, game
    end
  end

  def test_highest_total_score
    file_loc = './data/games.csv'

    game_methods = GameMethods.new(file_loc, @stat_tracker)

    assert_equal 11, game_methods.highest_total_score
  end

  def test_lowest_total_score
    file_loc = './data/games.csv'

    game_methods = GameMethods.new(file_loc)

    assert_equal 0, game_methods.lowest_total_score
  end

  def test_average_goals_by_season
    file_loc = './data/games.csv'
    game_methods = GameMethods.new(file_loc, @stat_tracker)

    expected = {
          "20122013"=>4.12,
          "20162017"=>4.23,
          "20142015"=>4.14,
          "20152016"=>4.16,
          "20132014"=>4.19,
          "20172018"=>4.44
        }
    assert_equal expected, game_methods.average_goals_by_season
  end

  def test_average_goals_per_game
    file_loc = './data/games.csv'

    game_methods = GameMethods.new(file_loc, @stat_tracker)

    assert_equal 4.22, game_methods.average_goals_per_game
  end

  def test_count_of_games_by_season
    file_loc = './data/games.csv'

    game_methods = GameMethods.new(file_loc, @stat_tracker)

    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }

    assert_equal expected, game_methods.count_of_games_by_season
  end

  def test_percentage_ties
    file_loc = './data/games.csv'
    game_methods = GameMethods.new(file_loc, @stat_tracker)

    assert_equal 0.20, game_methods.percentage_ties
  end

  def test_percentage_visitor_wins
    file_loc = './data/games.csv'
    game_methods = GameMethods.new(file_loc, @stat_tracker)

    assert_equal 0.36, game_methods.percentage_visitor_wins
  end

  def test_percentage_home_wins
    file_loc = './data/games.csv'
    game_methods = GameMethods.new(file_loc, @stat_tracker)

    assert_equal 0.44, game_methods.percentage_home_wins
  end
end
