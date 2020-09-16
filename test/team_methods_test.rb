# frozen_string_literal: true

require './test/test_helper'
require './lib/team_methods'
require './lib/stat_tracker'

class TeamMethodsTest < Minitest::Test
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
    teams = './data/teams.csv'
    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_instance_of TeamMethods, team_methods

    assert_equal './data/teams.csv', team_methods.file_loc
  end

  def test_it_can_count_teams
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 32, team_methods.count_of_teams
  end

  def test_it_can_find_team_name_with_team_id
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 'Reign FC', team_methods.find_by_id('54')
    assert_equal 'Sporting Kansas City', team_methods.find_by_id('5')
    assert_equal 'Houston Dynamo', team_methods.find_by_id('3')
  end

  def test_team_info
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    expected = {
      'team_id' => '1',
      'franchise_id' => '23',
      'team_name' => 'Atlanta United',
      'abbreviation' => 'ATL',
      'link' => '/api/v1/teams/1'
    }

    assert_equal expected, team_methods.team_info('1')
  end

  def test_best_season
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal '20132014', team_methods.best_season('6')
  end

  def test_worst_season
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal '20142015', team_methods.worst_season('6')
  end

  def test_average_win_percentage
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 0.49, team_methods.average_win_percentage('6')
  end

  def test_most_goals_scored
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 7, team_methods.most_goals_scored('18')
  end

  def test_fewest_goals_scored
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 0, team_methods.fewest_goals_scored('18')
  end

  def test_favorite_opponent
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 'DC United', team_methods.favorite_opponent('18')
  end

  def test_rival
    teams = './data/teams.csv'

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert ['Houston Dash', 'LA Galaxy'].include?(team_methods.rival('18'))
  end
end
