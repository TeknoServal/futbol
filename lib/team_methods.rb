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
     team_id: team.team_id,
     franchise_id: team.franchise_id,
     team_name: team.team_name,
     abbreviation: team.abbreviation,
     link: team.link
    }
  end

  def win_rate(team_id, games)
    played_games = games.select do |game|
      (team_id == game.home_team_id || team_id == game.away_team_id)
    end
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
    season_averages(team_id).max_by { |season, average| average } [0]
  end

  def worst_season(team_id)
    season_averages(team_id).min_by { |season, average| average } [0]
  end
end
