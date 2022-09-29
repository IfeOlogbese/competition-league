require 'game_points'

describe GamePoints do
  let(:result) do
    <<~GAME_RESULT
      Lions 3, Snakes 3
      Tarantulas 1, FC Awesome 0
      Lions 1, FC Awesome 1
      Tarantulas 3, Snakes 1
      Lions 4, Grouches 0
    GAME_RESULT
  end

  subject { GamePoints.new(result) }

  describe '#calculate_points' do
    it 'should return new string' do
      expect do
        subject.calculate_points
      end.to output(
        <<~GAME_RESULT
          \n
          ========= OUTPUT ==========
          1. Tarantulas, 6 pts
          2. Lions, 5 pts
          3. FC Awesome, 1 pt
          4. Snakes, 1 pt
          5. Grouches, 0 pts
        GAME_RESULT
      ).to_stdout
    end

    it 'should receive #generate_game_score' do
      expect(subject).to receive(:generate_game_score).with('Lions ', '3', ' Snakes ', '3')
      expect(subject).to receive(:generate_game_score).with('Tarantulas ', '1', ' FC Awesome ', '0')
      expect(subject).to receive(:generate_game_score).with('Lions ', '1', ' FC Awesome ', '1')
      expect(subject).to receive(:generate_game_score).with('Tarantulas ', '3', ' Snakes ', '1')
      expect(subject).to receive(:generate_game_score).with('Lions ', '4', ' Grouches ', '0')
      subject.calculate_points
    end

    it 'should receive #add_result_hash' do
      expect(subject).to receive(:add_result_hash).with('Lions', 1, 'Snakes', 1)
      expect(subject).to receive(:add_result_hash).with('Tarantulas', 3, 'FC Awesome', 0)
      expect(subject).to receive(:add_result_hash).with('Lions', 1, 'FC Awesome', 1)
      expect(subject).to receive(:add_result_hash).with('Tarantulas', 3, 'Snakes', 0)
      expect(subject).to receive(:add_result_hash).with('Lions', 3, 'Grouches', 0)
      subject.calculate_points
    end

    it 'should receive #sort_result_hash' do
      expect(subject).to receive(:sort_result_hash)
      subject.calculate_points
    end

    it 'should receive #points_text' do
      expect(subject).to receive(:points_text).exactly(5).times
      subject.calculate_points
    end

    it 'should receive #multiline_result' do
      expect(subject).to receive(:multiline_result)
      subject.calculate_points
    end
  end

  describe '::POINT_REGEX' do
    context 'given a game result' do
      it 'should capture 2 game players and their scores' do
        game_result = 'Lions 3, Snakes 3'
        team1, score1, team2, score2 = game_result.scan(GamePoints::POINT_REGEX).flatten
        expect(GamePoints::POINT_REGEX).to eq(/([a-zA-Z ]+|[0-9]+)/i)
        expect(team1.strip).to eq 'Lions'
        expect(score1).to eq '3'
        expect(team2.strip).to eq 'Snakes'
        expect(score2).to eq '3'
      end
    end
  end

  describe '#points_text' do
    it 'should return singular pt or plural pts' do
      expect(subject.points_text(1)).to eq '1 pt'
      expect(subject.points_text(0)).to eq '0 pts'
      expect(subject.points_text(2)).to eq '2 pts'
    end
  end

  describe '#sort_result_hash' do
    it 'should correctly sort the result hash' do
      subject.calculate_points
      expect(subject.result_hash).to include({ 'FC Awesome' => 1, 'Grouches' => 0, 'Lions' => 5, 'Snakes' => 1,
                                               'Tarantulas' => 6 })
      expect(subject.sort_result_hash).to eq [['Tarantulas', 6], ['Lions', 5], ['FC Awesome', 1], ['Snakes', 1],
                                              ['Grouches', 0]]
    end
  end
end
