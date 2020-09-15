require './test/test_helper'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test

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
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_attributes
    assert_equal @games_path, @stat_tracker.games_path
    assert_equal @teams_path, @stat_tracker.teams_path
    assert_equal @game_teams_path, @stat_tracker.game_teams_path
  end

  def test_from_csv
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_highest_total_score
    mock_game_methods = mock
    mock_game_methods.stubs(:highest_total_score).returns(8)
    @stat_tracker.game_methods = mock_game_methods

    assert_equal 8, @stat_tracker.highest_total_score
  end

  def test_best_offense_team
    assert_equal 'Reign FC', @stat_tracker.best_offense
  end

  def test_worst_offense_team
    assert_equal 'Utah Royals FC', @stat_tracker.worst_offense
  end

  def test_highest_scoring_visitor
    assert_equal 'FC Dallas', @stat_tracker.highest_scoring_visitor
  end

  def test_lowest_scoring_visitor
    assert_equal 'San Jose Earthquakes', @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal 'Utah Royals FC', @stat_tracker.lowest_scoring_home_team
  end

  def test_highest_scoring_home_team
    assert_equal 'Reign FC', @stat_tracker.highest_scoring_home_team
  end

  def test_most_tackles
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles("20132014")
  end

  def test_winningest_coach
    assert_equal "Claude Julien", @stat_tracker.winningest_coach("20132014")
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach("20142015")
  end

  def test_worst_coach
    assert_equal "Peter Laviolette", @stat_tracker.worst_coach("20132014")
    assert_equal "Ted Nolan", @stat_tracker.worst_coach("20142015")
  end

  def test_most_accurate_team
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team("20132014")
  end

  def test_least_accurate_team
    assert_equal "New York City FC", @stat_tracker.least_accurate_team("20132014")
  end

  def test_fewest_tackles
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles("20132014")
    assert_equal "Orlando City SC", @stat_tracker.fewest_tackles("20142015")
  end
end
