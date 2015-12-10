require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'SchulzeVote' do
  describe 'really simple vote with A=B' do
    it 'can solve a simple votation' do
      # the vote is A > B
      votestring = 'A,B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'can solve a simple votation with the number of votes preceeding' do
      # the vote is A = B
      votestring = '1=A,B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'with two votes the result is the same' do
      # the vote is A = B
      votestring = '2=A,B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'with hundred votes the result is the same' do
      # the vote is A = B
      votestring = '100=A,B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end
  end

  describe 'really simple vote with A>B' do
    it 'can solve a simple votation' do
      # the vote is A > B
      votestring = 'A;B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [1, 0]
    end

    it 'can solve a simple votation with the number of votes preceeding' do
      # the vote is A > B
      votestring = '1=A;B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [1, 0]
    end

    it 'with two votes the result is the same' do
      # the vote is A > B
      votestring = '2=A;B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [1, 0]
    end

    it 'with hundred votes the result is the same' do
      # the vote is A > B
      votestring = '100=A;B'
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [1, 0]
    end
  end

  describe 'two votes, one opposite of the other' do
    it 'can solve a simple votation' do
      # the vote is A > B
      votestring = <<EOF
A;B
B;A
EOF
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'can solve a simple votation with the number of votes preceeding' do
      votestring = <<EOF
1=A;B
1=B;A
EOF
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'with two votes the result is the same' do
      votestring = <<EOF
2=A;B
2=B;A
EOF
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end

    it 'with hundred votes the result is the same' do
      votestring = <<EOF
100=A;B
100=B;A
EOF
      vs = SchulzeBasic.do votestring, 2
      expect(vs.ranks).to eq [0, 0]
    end
  end

  describe 'more options' do
    it '3 equally voted' do
      votestring = <<EOF
A,B,C
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [0, 0, 0]
    end

    it 'wins C' do
      votestring = <<EOF
C;A,B
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [0, 0, 2]
    end

    it 'wins A' do
      votestring = <<EOF
A;C,B
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [2, 0, 0]
    end

    it 'wins B' do
      votestring = <<EOF
B;C,A
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [0, 2, 0]
    end

    it 'wins C against A wins against B' do
      votestring = <<EOF
C;A;B
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [1, 0, 2]
    end

    it 'six votes destroy each other' do
      votestring = <<EOF
C;A;B
C;B;A
A;B;C
A;C;B
B;C;A
B;A;C
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [0, 0, 0]

      [0, 1, 2].permutation.each do |array|
        expect(vs.classifications).to include array
      end
    end

    it 'B wins' do
      votestring = <<EOF
C;A;B
C;B;A
A;B;C
A;C;B
B;C;A
2=B;A;C
EOF
      vs = SchulzeBasic.do votestring, 3
      expect(vs.ranks).to eq [1, 2, 0]
    end
  end

  describe 'complex situation' do
    #see http://en.wikipedia.org/wiki/User:MarkusSchulze/Schulze_method_examples
    it 'example 1 from wikipedia' do
      votestring = <<EOF
5=A;C;B;E;D
5=A;D;E;C;B
8=B;E;D;A;C
3=C;A;B;E;D
7=C;A;E;B;D
2=C;B;A;D;E
7=D;C;E;B;A
8=E;B;A;D;C
EOF
      vs = SchulzeBasic.do votestring, 5
      expect(vs.ranks).to eq [3, 1, 2, 0, 4] # E > A > C > B > D
    end

    it 'example 2 from wikipedia' do
      votestring = <<EOF
5=A;C;B;D
2=A;C;D;B
3=A;D;C;B
4=B;A;C;D
3=C;B;D;A
3=C;D;B;A
1=D;A;C;B
5=D;B;A;C
4=D;C;B;A
EOF
      vs = SchulzeBasic.do votestring, 4
      expect(vs.ranks).to eq [2, 0, 1, 3] # D > A > C > B
    end

    it 'example 3 from wikipedia' do
      votestring = <<EOF
3=A;B;D;E;C
5=A;D;E;B;C
1=A;D;E;C;B
2=B;A;D;E;C
2=B;D;E;C;A
4=C;A;B;D;E
6=C;B;A;D;E
2=D;B;E;C;A
5=D;E;C;A;B
EOF
      vs = SchulzeBasic.do votestring, 5
      expect(vs.ranks).to eq [3, 4, 0, 2, 1] # B > A > D > E > C
    end


    it 'example 4 from wikipedia' do
      votestring = <<EOF
3=A;B;C;D
2=D;A;B;C
2=D;B;C;A
2=C;B;D;A
EOF
      # beat matrix
      # ___|_A_|_B_|_C_|_D_|
      #  A |   | 5 | 5 | 3 |
      #  B | 4 |   | 7 | 5 |
      #  C | 4 | 2 |   | 5 |
      #  D | 6 | 4 | 4 |   |

      vs = SchulzeBasic.do votestring, 4
      expect(vs.ranks).to eq [0, 1, 0, 1] # B > C, D > A
      expect(vs.winners_array).to eq [0, 0, 0, 0] # B > C, D > A

      [[1, 2, 3, 0],
       [1, 3, 0, 2],
       [1, 3, 2, 0],
       [3, 0, 1, 2],
       [3, 1, 0, 2],
       [3, 1, 2, 0]].each do |array|
        expect(vs.classifications).to include array
      end
      expect(vs.classifications.size).to eq 6

      # we have more possible solutions here:
      # B > C > D > A
      # B > D > A > C
      # D > A > B > C
      # B > D > C > A
      # D > B > A > C
      # D > B > C > A
      # so the solution is B and D are preferred over A and C
    end

    it 'example 1 from airesis' do
      votestring = <<EOF
1=C;A;D;B
1=D;C;A;B
1=C;D;A;B
1=B;D;A;C
2=A;D;C;B
EOF
      # beat matrix
      # ___|_A_|_B_|_C_|_D_|
      #  A |   | 5 | 0 | 0 |
      #  B | 0 |   | 0 | 0 |
      #  C | 0 | 5 |   | 0 |
      #  D | 0 | 5 | 4 |   |
      vs = SchulzeBasic.do votestring, 4
      expect(vs.ranks).to eq [1, 0, 1, 2]
      expect(vs.winners_array).to eq [1, 0, 0, 1]
      # D = 2, A = 1, C = 1, B = 0
      # p[A,X] >= p[X,A] for every X? YES
      # p[B,X] >= p[X,B] for every X? NO
      # p[C,X] >= p[X,B] for every X? NO
      # p[D,X] >= p[X,D] for every X? YES
    end
  end

  it 'example 2 from airesis' do
    votestring = <<EOF
F;D;G;E;A;B;C
G;E;D;A;B,C;F
F;G;D;B,E;A;C
F;D;G;E;A,B,C
B,E,F;A,C,D,G
A,B,E,G;D;C,F
A,B,C,G;D,E;F
G;E;D;F;A;C;B
C,F;B,G;A,E;D
E;A,B,C,D,F,G
B,E,G;A,F;C;D
EOF

    vs = SchulzeBasic.do votestring, 7
    expect(vs.ranks).to eq [1, 2, 0, 2, 5, 4, 6]
    expect(vs.winners_array).to eq [0, 0, 0, 0, 0, 0, 1]
  end

  describe 'from file' do
    it 'scan example4' do
      sb = SchulzeBasic.do File.open('spec/support/examples/vote4.list')
      expect(sb.ranks).to eq([0, 1, 3, 2])
    end
  end
end

