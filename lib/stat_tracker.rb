# frozen_string_literal: true

require_relative './game_methods'
require_relative './team_methods'
require_relative './game_teams_methods'

# Stat tracker class
class StatTracker
  attr_reader :games_path, :teams_path, :game_teams_path
  attr_accessor :game_methods, :team_methods, :game_teams_methods

  def initialize(locations)
    @games_path = locations[:games]
    @teams_path = locations[:teams]
    @game_teams_path = locations[:game_teams]
    @game_methods = GameMethods.new(@games_path, self)
    @team_methods = TeamMethods.new(@teams_path, self)
    @game_teams_methods = GameTeamsMethods.new(@game_teams_path, self)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def count_of_teams
    @team_methods.count_of_teams
  end

  def highest_total_score
    @game_methods.highest_total_score
  end

  def lowest_total_score
    @game_methods.lowest_total_score
  end

  def percentage_home_wins
    @game_methods.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_methods.percentage_visitor_wins
  end

  def percentage_ties
    @game_methods.percentage_ties
  end

  def count_of_games_by_season
    @game_methods.count_of_games_by_season
  end

  def average_goals_per_game
    @game_methods.average_goals_per_game
  end

  def average_goals_by_season
    @game_methods.average_goals_by_season
  end

  def best_offense
    @game_teams_methods.best_offense_team
  end

  def worst_offense
    @game_teams_methods.worst_offense_team
  end

  def highest_scoring_visitor
    @game_teams_methods.highest_scoring_team('away')
  end

  def highest_scoring_home_team
    @game_teams_methods.highest_scoring_team('home')
  end

  def lowest_scoring_visitor
    @game_teams_methods.lowest_scoring_team('away')
  end

  def lowest_scoring_home_team
    @game_teams_methods.lowest_scoring_team('home')
  end

  def games_by_season
    @game_methods.games_by_season
  end

  def most_tackles(season)
    @game_teams_methods.most_tackles(season)
  end

  def fewest_tackles(season)
    @game_teams_methods.fewest_tackles(season)
  end

  def find_by_team_id(team_id)
    @team_methods.find_by_id(team_id)
  end

  def winningest_coach(season)
    @game_teams_methods.winningest_coach(season)
  end

  def worst_coach(season)
    @game_teams_methods.worst_coach(season)
  end

  def most_accurate_team(season)
    @game_teams_methods.most_accurate_team(season)
  end

  def least_accurate_team(season)
    @game_teams_methods.least_accurate_team(season)
  end

  def team_info(team_id)
    @team_methods.team_info(team_id)
  end

  def best_season(team_id)
    @team_methods.best_season(team_id)
  end

  def worst_season(team_id)
    @team_methods.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team_methods.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team_methods.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team_methods.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team_methods.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team_methods.rival(team_id)
  end
end
