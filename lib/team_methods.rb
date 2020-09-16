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
end
