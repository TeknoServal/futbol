require 'CSV'
require_relative './team'

class TeamMethods
  attr_reader :teams, :file_loc

  def initialize(file_loc, stat_tracker)
    @file_loc = file_loc
    @teams = create_teams(@file_loc)
    @stat_tracker = stat_tracker
  end

  def create_teams(file)
    CSV.parse(File.read(file), headers: true).map do |row|
      Team.new(row)
    end
  end

  def count_of_teams
    @teams.count
  end

  def find_by_id(team_id)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    team.team_name
  end

  def team_info(team_id)
    team = @teams.find do |team|
      team.team_id == team_id
    end
    {
      'team_id' => team.team_id,
      'franchise_id' => team.franchise_id,
      'team_name' => team.team_name,
      'abbreviation' => team.abbreviation,
      'link' => team.link
    }
  end

  def games_played(team_id, games)
    games.select do |game|
      (team_id == game.home_team_id || team_id == game.away_team_id)
    end
  end

  def win_rate(team_id, games)
    played_games = games_played(team_id, games)
    won_games = played_games.select do |game|
      won?(team_id, game)
    end
    (won_games.length.to_f / played_games.length).round(2)
  end

  def season_averages(team_id)
    @stat_tracker.games_by_season.each_with_object({}) do |season, output|
      output[season[0]] = win_rate(team_id, season[1])
    end
  end

  def won?(team_id, game)
    if game.home_goals.to_i > game.away_goals.to_i
      team_id == game.home_team_id
    elsif game.home_goals.to_i < game.away_goals.to_i
      team_id == game.away_team_id
    else
      false
    end
  end

  def best_season(team_id)
    season_averages(team_id).max_by { |_season, average| average } [0]
  end

  def worst_season(team_id)
    season_averages(team_id).min_by { |_season, average| average } [0]
  end

  def average_win_percentage(team_id)
    win_rate(team_id, @stat_tracker.game_methods.games)
  end

  def most_goals_scored(team_id)
    played_games = games_played(team_id, @stat_tracker.game_methods.games)
    played_games.map do |game|
      if team_id == game.home_team_id
        game.home_goals.to_i
      else
        game.away_goals.to_i
      end
    end.max
  end

  def fewest_goals_scored(team_id)
    played_games = games_played(team_id, @stat_tracker.game_methods.games)
    played_games.map do |game|
      if team_id == game.home_team_id
        game.home_goals.to_i
      else
        game.away_goals.to_i
      end
    end.min
  end

  def team_win_rates(team_id)
    opponents = @teams.reject { |team| team.team_id == team_id }

    games_with_self = games_played(team_id, @stat_tracker.game_methods.games)
    games_with_other_teams = opponents.each_with_object({}) do |opponent, output|
      output[opponent.team_id] = games_played(opponent.team_id, games_with_self)
    end
    games_with_other_teams.each_with_object({}) do |other_team, output|
      output[other_team[0]] = win_rate(team_id, other_team[1])
    end
  end

  def favorite_opponent(team_id)
    find_by_id(team_win_rates(team_id).max_by { |team| team[1] } [0])
  end

  def rival(team_id)
    find_by_id(team_win_rates(team_id).min_by { |team| team[1] } [0])
  end
end
