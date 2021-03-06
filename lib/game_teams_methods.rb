require 'CSV'
require_relative './game_teams'

class GameTeamsMethods
  attr_reader :game_teams, :all_game_teams
  def initialize(game_teams, stat_tracker)
    @game_teams = game_teams
    @all_game_teams = create_array(@game_teams)
    @stat_tracker = stat_tracker
  end

  def create_array(file)
    CSV.foreach(file, headers: true).map do |row|
      GameTeams.new(row)
    end
  end

  def best_offense_team
    team_id = average_goals_by_team.max_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(team_id)
  end

  def worst_offense_team
    team_id = average_goals_by_team.min_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(team_id)
  end

  def most_tackles(season)
    all_season_tackles = assign_tackles_by_season(season).max_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(all_season_tackles)
  end

  def fewest_tackles(season)
    all_season_tackles = assign_tackles_by_season(season).min_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(all_season_tackles)
  end

  def get_season_rows(season)
    game_ids = @stat_tracker.games_by_season[season].map(&:game_id)
    @all_game_teams.find_all do |row|
      game_ids.include?(row.game_id)
    end
  end

  def most_accurate_team(season)
    best_ratio = get_shot_ratio(season).max_by do |_team_id, ratio|
      ratio
    end.first
    @stat_tracker.find_by_team_id(best_ratio)
  end

  def least_accurate_team(season)
    worst_ratio = get_shot_ratio(season).min_by do |_team_id, ratio|
      ratio
    end.first
    @stat_tracker.find_by_team_id(worst_ratio)
  end

  def get_shot_ratio(season)
    shot_ratio = {}
    team_id_games(season).each do |key, games|
      shot_ratio[key] = ((goals_sum(games) / shots_sum(games)) * 100).round(2)
    end
    shot_ratio
  end

  def team_id_games(season)
    get_season_rows(season).group_by do |game|
      game.team_id
    end
  end

  def goals_sum(games)
    games.sum { |game| game.goals.to_f }
  end

  def shots_sum(games)
    games.sum { |game| game.shots.to_f }
  end

  def winningest_coach(season)
    coach_win_percentage = {}
    games_by_coach(season).each do |key, games|
      coach_win_percentage[key] = (find_wins_by_coaches(games) * 100).round(2)
    end
    coach_win_percentage.max_by do |_coach, percentage|
      percentage
    end.first
  end

  def worst_coach(season)
    coach_win_percentage = {}
    games_by_coach(season).each do |key, games|
      coach_win_percentage[key] = (find_wins_by_coaches(games) * 100).round(2)
    end
    coach_win_percentage.min_by do |_coach, percentage|
      percentage
    end.first
  end

  def games_by_coach(season)
    get_season_rows(season).group_by do |game|
      game.head_coach
    end
  end

  def find_wins_by_coaches(games)
    (games.find_all { |game| game.result == 'WIN' }.length / games.size.to_f)
  end

  def assign_tackles_by_season(season)
    get_season_rows(season).each_with_object({}) do |game, output|
      if output[game.team_id]
        output[game.team_id] += game.tackles.to_i
      else
        output[game.team_id] = game.tackles.to_i
      end
    end
  end

  def assign_goals_by_teams
    @all_game_teams.each_with_object({}) do |gameteam, output|
      if output.has_key?(gameteam.team_id)
        output[gameteam.team_id] << gameteam.goals.to_i
      else
        output[gameteam.team_id] = [gameteam.goals.to_i]
      end
    end
  end

  def assign_goals_by_home_or_away_teams(home_away)
    team = find_all_games(home_away).map do |row|
      row.team_id
    end
    goals = find_all_games(home_away).map do |row|
      row.goals
    end
    team_id_goal_array(team, goals)
  end

  def team_id_goal_array(team, goals)
    away_team_goals = {}
    team.each.with_index do |id, idx|
      if away_team_goals.has_key?(id)
        away_team_goals[id] << goals[idx]
      else
        away_team_goals[id] = [goals[idx]]
      end
    end
    away_team_goals
  end

  def average_goals_by_team
    team_goals = assign_goals_by_teams
    team_goals.values.each do |goals|
      average_goals = 0
      total = 0
      goals.each do |goal|
        total += goal.to_f
      end
      average_goals = (total / goals.size).round(2)
      team_goals[team_goals.key(goals)] = average_goals
    end
    team_goals
  end

  def highest_scoring_team(home_away)
    team_id = nil
    away_team_averages = average_goals_by_home_or_away_team(home_away)
    team_id = away_team_averages.max_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(team_id)
  end

  def lowest_scoring_team(home_away)
    team_id = nil
    away_team_averages = average_goals_by_home_or_away_team(home_away)
    team_id = away_team_averages.min_by do |_key, value|
      value
    end.first
    @stat_tracker.find_by_team_id(team_id)
  end

  def average_goals_by_home_or_away_team(home_away)
    away_team_goals = assign_goals_by_home_or_away_teams(home_away)
    away_team_goals.values.each do |goals|
      average_goals = 0
      total = 0
      goals.each do |goal|
        total += goal.to_f
      end
      average_goals = (total / goals.size).round(2)
      away_team_goals[away_team_goals.key(goals)] = average_goals
    end
    away_team_goals
  end

  def find_all_games(home_away)
    @all_game_teams.find_all do |gameteam|
      gameteam.hoa == home_away
    end
  end
end
