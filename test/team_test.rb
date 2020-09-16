require './test/test_helper'
require './lib/team'
require 'CSV'

class TeamTest < Minitest::Test 
  
  def test_it_exists
    team_data = CSV.parse(File.read('./data/teams.csv'), headers: true)

    team = Team.new(team_data[0])

    assert_instance_of Team, team
  end

  def test_it_has_attributes
    team_data = CSV.parse(File.read('./data/teams.csv'), headers: true)

    team = Team.new(team_data[0])

    assert_equal "1", team.team_id
    assert_equal "23", team.franchise_id
    assert_equal "Atlanta United", team.team_name
    assert_equal "ATL", team.abbreviation
    assert_equal "Mercedes-Benz Stadium", team.stadium
    assert_equal "/api/v1/teams/1", team.link
  end
end