# frozen_string_literal: true

require './test/test_helper'
require './lib/team_methods'
require './lib/stat_tracker'
require './lib/game'

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
      team_id: '1',
      franchise_id: '23',
      team_name: 'Atlanta United',
      abbreviation: 'ATL',
      link: '/api/v1/teams/1'
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

  def test_games_played
    teams = './data/teams.csv'

    locations = {
      games: './test/game_test_file.csv',
      teams: @teams_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal @stat_tracker.game_methods.games[0..5], team_methods.games_played('6', @stat_tracker.game_methods.games)
  end

  def test_win_rate
    teams = './data/teams.csv'

    locations = {
      games: './test/game_test_file.csv',
      teams: @teams_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)

    team_methods = TeamMethods.new(teams, @stat_tracker)

    assert_equal 0.50, team_methods.win_rate('6', @stat_tracker.game_methods.games)
  end

  def test_season_averages
    teams = './data/teams.csv'

    locations = {
      games: './test/game_test_file.csv',
      teams: @teams_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)

    team_methods = TeamMethods.new(teams, @stat_tracker)

    expected = {
      '20122013' => 1.00,
      '20172018' => 0.25
    }

    assert_equal expected, team_methods.season_averages('6')
  end

  def test_won?
    teams = './data/teams.csv'
    game1_data = {
      'game_id' => 'test_id',
      'season' => '1',
      'type' => 'postseason',
      'date_time' => 'some day',
      'away_team_id' => '8',
      'home_team_id' => '6',
      'away_goals' => '5',
      'home_goals' => '8',
      'venue' => 'somewhere',
      'venue_link' => 'also somewhere'
    }

    game2_data = {
      'game_id' => 'test_id',
      'season' => '1',
      'type' => 'postseason',
      'date_time' => 'some day',
      'away_team_id' => '8',
      'home_team_id' => '6',
      'away_goals' => '9',
      'home_goals' => '8',
      'venue' => 'somewhere',
      'venue_link' => 'also somewhere'
    }

    game3_data = {
      'game_id' => 'test_id',
      'season' => '1',
      'type' => 'postseason',
      'date_time' => 'some day',
      'away_team_id' => '6',
      'home_team_id' => '9',
      'away_goals' => '5',
      'home_goals' => '8',
      'venue' => 'somewhere',
      'venue_link' => 'also somewhere'
    }

    game4_data = {
      'game_id' => 'test_id',
      'season' => '1',
      'type' => 'postseason',
      'date_time' => 'some day',
      'away_team_id' => '6',
      'home_team_id' => '9',
      'away_goals' => '9',
      'home_goals' => '8',
      'venue' => 'somewhere',
      'venue_link' => 'also somewhere'
    }

    game5_data = {
      'game_id' => 'test_id',
      'season' => '1',
      'type' => 'postseason',
      'date_time' => 'some day',
      'away_team_id' => '8',
      'home_team_id' => '9',
      'away_goals' => '5',
      'home_goals' => '8',
      'venue' => 'somewhere',
      'venue_link' => 'also somewhere'
    }

    locations = {
      games: './test/game_test_file.csv',
      teams: @teams_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)

    team_methods = TeamMethods.new(teams, @stat_tracker)

    game1 = Game.new(game1_data)
    game2 = Game.new(game2_data)
    game3 = Game.new(game3_data)
    game4 = Game.new(game4_data)
    game5 = Game.new(game5_data)

    assert_equal true, team_methods.won?('6', game1)
    assert_equal false, team_methods.won?('6', game2)
    assert_equal false, team_methods.won?('6', game3)
    assert_equal true, team_methods.won?('6', game4)
    assert_equal false, team_methods.won?('6', game5)
  end

  def test_team_win_rates
    teams = './test/teams_test_file.csv'

    locations = {
      games: './test/game_test_file.csv',
      teams: teams,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.new(locations)

    team_methods = TeamMethods.new(teams, @stat_tracker)
    expected = { '14' => 0.25, '3' => 1.0 }

    assert_equal expected, team_methods.team_win_rates('6')
  end
end
