require 'pry'

class World

  attr_accessor :rows, :columns, :grid, :live_neighbours

  def initialize (rows = 60 , columns = 60)
    @rows = rows
    @columns = columns
    @grid = Array.new(columns) do |column|
                  Array.new(rows) do |row|
                    Cell.new(row, column)
      end
    end
  end

  def find_live_neighbours(cell)
    @live_neighbours = []
    #north
    if cell.y>0
      possibility = self.grid[cell.y-1][cell.x]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #south
    if cell.y<(rows-1)
      possibility = self.grid[cell.y+1][cell.x]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #west
    if cell.x> 0
      possibility = self.grid[cell.y][cell.x-1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #east
    if (cell.x) < (columns-1)
      possibility = self.grid[cell.y][cell.x+1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #north east
    if (cell.y>0) && (cell.x<(columns-1))
      possibility = self.grid[cell.y-1][cell.x+1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #north west
    if (cell.y>0) && (cell.x> 0)
      possibility = self.grid[cell.y-1][cell.x-1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #south east
    if (cell.y<(rows-1)) && (cell.x<(columns-1))
      possibility = self.grid[cell.y+1][cell.x+1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    #south west
    if (cell.y<(rows-1)) && ((cell.x> 0))
      possibility = self.grid[cell.y+1][cell.x-1]
      if possibility.alive == true
        @live_neighbours << possibility
      end
    end

    return @live_neighbours

  end
end

class Cell

  attr_accessor :x, :y, :alive

  def initialize(x=0, y=0)
    @x = x
    @y = y
    @alive = alive
    @alive = false
  end
end

class PlayGame

  attr_accessor :world, :start_points

  def initialize(world = World.new, start_points = [])
    @world = world
    @start_points = start_points

    start_points.each do |point|
      world.grid[point[0]][point[1]].alive = true
    end
  end

  def next_generation

    next_gen_live_cells = []
    next_gen_dead_cells = []

    world.grid.each do |column|
      column.each do |cell|
        next_gen_dead_cells << cell if pass_rule_1?(cell)
        next_gen_live_cells << cell if pass_rule_2?(cell)
        next_gen_dead_cells << cell if pass_rule_3?(cell)
        next_gen_live_cells << cell if pass_rule_4?(cell)
      end
    end

    next_gen_dead_cells.each do |cell|
      world.grid[cell.y][cell.x].alive = false
      end

    next_gen_live_cells.each do |cell|
      world.grid[cell.y][cell.x].alive = true
      end
  end

  def pass_rule_1?(cell)
    (cell.alive == true) && (world.find_live_neighbours(cell).count < 2)
  end

  def pass_rule_2?(cell)
    (cell.alive == true) && ((world.find_live_neighbours(cell).count == 2) || (world.find_live_neighbours(cell).count == 3))
  end

  def pass_rule_3?(cell)
    (cell.alive == true) && (world.find_live_neighbours(cell).count > 3)
  end

  def pass_rule_4?(cell)
    (cell.alive == false) && (world.find_live_neighbours(cell).count == 3)
  end
end
