sample_result = <<~GAME_RESULT
  Lions 3, Snakes 3
  Tarantulas 1, FC Awesome 0
  Lions 1, FC Awesome 1
  Tarantulas 3, Snakes 1
  Lions 4, Grouches 0
GAME_RESULT

class GamePoints
  POINT_REGEX = /([a-zA-Z ]+|[0-9]+)/i.freeze

  attr_reader :result_hash

  def initialize(game_result)
    @game_result = game_result
    @result_hash = Hash.new { |hsh, key| hsh[key] = 0 }
  end

  def calculate_points
    @game_result.each_line do |line|
      team1, score1, team2, score2 = line.scan(POINT_REGEX).flatten
      generate_game_score(team1, score1, team2, score2)
    end

    print("\n\n")
    puts '========= OUTPUT =========='
    puts multiline_result
  end

  def points_text(value)
    value == 1 ? "#{value} pt" : "#{value} pts"
  end

  def generate_game_score(team1, score1, team2, score2)
    if score1.to_i > score2.to_i
      # Team 1 has a higher score
      add_result_hash(team1.strip, 3, team2.strip, 0)
    elsif score2.to_i > score1.to_i
      # Team 2 has a higher score
      add_result_hash(team1.strip, 0, team2.strip, 3)
    elsif score1.to_i == score2.to_i
      # It's a draw
      add_result_hash(team1.strip, 1, team2.strip, 1)
    else
      # Nothing here, leave them as zero
      add_result_hash(team1.strip, 0, team2.strip, 0)
    end
  end

  def add_result_hash(team1, team1_score, team2, team2_score)
    @result_hash[team1] += team1_score
    @result_hash[team2] += team2_score
  end

  def sort_result_hash
    @result_hash.sort do |a, b|
      num = 0
      num += 10   if a[1] < b[1]  # Sort points desc (higher points up)
      num += -1   if a[0] < b[0]  # Sort team name asc
      num += -10  if b[1] < a[1]  # Sort points asc (lower points down)
      num += 1    if b[0] < a[0]  # Sort team name desc
      num
    end
  end

  def multiline_result
    @multiline_result ||= begin
      result = ''

      sorted_result = sort_result_hash
      sorted_result.to_h.each_with_index do |point, index|
        name, total_point = point
        result += "#{index + 1}. #{name}, #{points_text(total_point)}\n"
      end

      result
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  require 'readline'
  while input = Readline.readline('> ', true)
    GamePoints.new(input).calculate_points
  end
end

# GamePoints.new(result).calculate_points
