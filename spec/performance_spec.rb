require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'VoteSchulze Performance' do
  describe 'really simple vote with A=B' do
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
        start = Time.now
        vs = SchulzeBasic.do votestring, 5
        finish = Time.now
        diff = finish - start
        expect(diff).to be < 0.01
      end
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
      start = Time.now
      vs = SchulzeBasic.do votestring, 5
      finish = Time.now
      diff = finish - start
      expect(diff).to be < 0.01
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

      start = Time.now
      vs = SchulzeBasic.do votestring, 4
      finish = Time.now
      diff = finish - start
      expect(diff).to be < 0.01
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

      start = Time.now
      vs = SchulzeBasic.do votestring, 7
      finish = Time.now
      diff = finish - start
      expect(diff).to be < 0.05

    end

    it '10 solutions' do
      votestring = <<EOF
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8;9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
1,2,3,4,5,6,7,8,9,10,11,12,13
EOF

      start = Time.now
      vs = SchulzeBasic.do votestring, 10
      finish = Time.now
      diff = finish - start
      expect(diff).to be < 0.05
    end
  end
end

