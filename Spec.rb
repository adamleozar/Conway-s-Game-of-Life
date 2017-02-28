require 'rspec'
require 'pry'
require_relative 'game_of_life.rb'

describe 'PlayGame of Life' do

  let!(:world) {World.new}
  let!(:cell) {Cell.new(1,1)}

  context 'World' do

    subject { World.new }

    it 'should create a new grid object' do
      expect(subject.is_a?(World)).to be true
    end

    it 'should have instance variables that respond to getter' do
      expect(subject).to respond_to(:rows)
      expect(subject).to respond_to(:columns)
      expect(subject).to respond_to(:grid)
      expect(subject).to respond_to(:find_live_neighbours)
    end

    it 'should create a 2d grid array upon initilization' do
      expect(subject.grid.is_a?(Array)).to be true
      subject.grid.each do |column|
        expect(column.is_a?(Array)).to be true
      end
    end

    it 'should detect a neighbour to the north' do
      expect(subject.grid[0][1].alive).to eq(false)
      subject.grid[0][1].alive = true
      expect(subject.grid[0][1].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the south' do
      expect(subject.grid[2][1].alive).to eq(false)
      subject.grid[2][1].alive = true
      expect(subject.grid[2][1].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the east' do
      expect(subject.grid[1][2].alive).to eq(false)
      subject.grid[1][2].alive = true
      expect(subject.grid[1][2].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the west' do
      expect(subject.grid[1][0].alive).to eq(false)
      subject.grid[1][0].alive = true
      expect(subject.grid[1][0].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the north east' do
      expect(subject.grid[0][2].alive).to eq(false)
      subject.grid[0][2].alive = true
      expect(subject.grid[0][2].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the north west' do
      expect(subject.grid[0][0].alive).to eq(false)
      subject.grid[0][0].alive = true
      expect(subject.grid[0][0].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the south east' do
      expect(subject.grid[2][2].alive).to eq(false)
      subject.grid[2][2].alive = true
      expect(subject.grid[2][2].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the south west' do
      expect(subject.grid[2][0].alive).to eq(false)
      subject.grid[2][0].alive = true
      expect(subject.grid[2][0].alive).to eq(true)
      expect(subject.find_live_neighbours(cell).count).to eq(1)
    end
  end

  context 'Cell' do

    subject {Cell.new}

    it 'should create a new cell object' do
      expect(subject.is_a?(Cell)).to be true
    end

    it 'should have instance variables that respond to getter methods' do
      expect(subject).to respond_to(:x)
      expect(subject).to respond_to(:y)
      expect(subject).to respond_to(:alive)
    end

    it 'should initialise properly' do
      expect(subject.alive).to eq(false)
      expect(subject.x).to eq(0)
      expect(subject.y).to eq(0)
    end
  end

  context 'PlayGame' do
    subject{PlayGame.new}

    it 'should create a new PlayGame object' do
      expect(subject.is_a?(PlayGame)).to be true
    end

    it 'should have instance variables that respond to getter methods' do
      expect(subject).to respond_to(:world)
      expect(subject).to respond_to(:start_points)
    end

    it 'should initialise properly' do
      expect(subject.world.is_a?(World)).to be true
      expect(subject.start_points.is_a?(Array)).to be true
    end

    it 'should implement the start points properly' do
      new_game = PlayGame.new(world, [[1,2], [0,2]])
      expect(world.grid[1][2].alive).to eq(true)
      expect(world.grid[0][2].alive).to eq(true)
    end
  end

  context 'Rules' do

    let!(:game) {PlayGame.new}

    context'Rule 1' do

      it 'should kill a live cell with 0 live neighbous' do
        game = PlayGame.new(world, [[1,1]])
        game.next_generation
        expect(world.grid[1][1].alive).to eq(false)
      end

      it 'should kill a live cell with 1 live neighbous' do
        game = PlayGame.new(world, [[1,0], [0,0]])
        game.next_generation
        expect(world.grid[1][0].alive).to eq(false)
        expect(world.grid[0][0].alive).to eq(false)
      end

      it 'should not kill a live cell with 2 live neighbous' do
        game = PlayGame.new(world, [[0,0], [1,0], [2,0]])
        game.next_generation
        expect(world.grid[1][0].alive).to eq(true)
        expect(world.grid[2][0].alive).to eq(false)
        expect(world.grid[0][0].alive).to eq(false)
      end
    end

    context 'Rule 2' do

      it 'should not kill a live cell with 2 live neighbous' do
        game = PlayGame.new(world, [[0,2], [1,2], [2,2]])
        game.next_generation
        expect(world.grid[1][2].alive).to eq(true)
        expect(world.grid[2][2].alive).to eq(false)
        expect(world.grid[0][2].alive).to eq(false)
      end

      it 'should not kill a live cell with 3 live neighbous' do
        game = PlayGame.new(world, [[1,1], [0,0], [0,1], [0,2]])
        game.next_generation
        expect(world.grid[1][1].alive).to eq(true)
        expect(world.grid[0][0].alive).to eq(true)
        expect(world.grid[0][1].alive).to eq(true)
        expect(world.grid[0][2].alive).to eq(true)
      end

    end
    context 'Rule 3' do

      it 'should kill a live cell with 4 live neighbous' do
        game = PlayGame.new(world, [[1,1], [0,0], [0,1], [0,2], [1,0]])
        game.next_generation
        expect(world.grid[1][1].alive).to eq(false)
        expect(world.grid[0][0].alive).to eq(true)
        expect(world.grid[0][1].alive).to eq(false)
        expect(world.grid[0][2].alive).to eq(true)
      end
    end

    context 'Rule 4' do
      it 'should revive a dead cell with 3 live neighbous' do
        game = PlayGame.new(world, [[0,1], [1,2], [2,1]])
        game.next_generation
        expect(world.grid[0][1].alive).to eq(false)
        expect(world.grid[1][2].alive).to eq(true)
        expect(world.grid[2][1].alive).to eq(false)
        expect(world.grid[1][1].alive).to eq(true)
      end
    end
  end

  context 'Test well known patterns' do

    context 'Still lifes' do
      it 'should render a block' do
        game = PlayGame.new(world, [[2,2], [2,3], [3,2], [3,3]])
        game.next_generation
        expect(world.grid[2][2].alive).to eq(true)
        expect(world.grid[2][3].alive).to eq(true)
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[3][3].alive).to eq(true)
        game.next_generation
        expect(world.grid[2][2].alive).to eq(true)
        expect(world.grid[2][3].alive).to eq(true)
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[3][3].alive).to eq(true)
      end

      it 'should render a beehive' do
        game = PlayGame.new(world, [[3,2], [2,3], [2,4], [3,5], [4,3], [4,4]])
        game.next_generation
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[2][3].alive).to eq(true)
        expect(world.grid[2][4].alive).to eq(true)
        expect(world.grid[3][5].alive).to eq(true)
        expect(world.grid[4][3].alive).to eq(true)
        expect(world.grid[4][4].alive).to eq(true)
        game.next_generation
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[2][3].alive).to eq(true)
        expect(world.grid[2][4].alive).to eq(true)
        expect(world.grid[3][5].alive).to eq(true)
        expect(world.grid[4][3].alive).to eq(true)
        expect(world.grid[4][4].alive).to eq(true)
      end
    end

    context 'Oscillators' do
      it 'should render a blinker(period 2)' do
        game = PlayGame.new(world, [[2,3], [3,3], [4,3]])
        game.next_generation
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[3][3].alive).to eq(true)
        expect(world.grid[3][4].alive).to eq(true)
        game.next_generation
        expect(world.grid[2][3].alive).to eq(true)
        expect(world.grid[3][3].alive).to eq(true)
        expect(world.grid[4][3].alive).to eq(true)
      end

      it 'should render a toad' do
        game = PlayGame.new(world, [[3,3], [3,4], [3,5], [4,2], [4,3], [4,4]])
        game.next_generation
        expect(world.grid[2][4].alive).to eq(true)
        expect(world.grid[3][5].alive).to eq(true)
        expect(world.grid[4][5].alive).to eq(true)
        expect(world.grid[3][2].alive).to eq(true)
        expect(world.grid[4][2].alive).to eq(true)
        expect(world.grid[5][3].alive).to eq(true)
        game.next_generation
        expect(world.grid[3][3].alive).to eq(true)
        expect(world.grid[3][4].alive).to eq(true)
        expect(world.grid[3][5].alive).to eq(true)
        expect(world.grid[4][2].alive).to eq(true)
        expect(world.grid[4][3].alive).to eq(true)
        expect(world.grid[4][4].alive).to eq(true)
      end
    end
  end
end
