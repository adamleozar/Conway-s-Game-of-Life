require 'mittsu'
require_relative 'game_of_life.rb'
require 'pry'


class Render

  attr_accessor :world, :scene_ortho, :game

  SCREEN_WIDTH = 1300
  SCREEN_HEIGHT = 1030


  def initialize (world, scene_ortho)
    @world = world
    @scene_ortho = scene_ortho
    @game = PlayGame.new(world)
    @boxes = []
    randomly_populate
    get_start_points
  end

  def randomly_populate
    world.grid.each do |column|
      column.each do |cell|
        column.sample.alive =true
      end
    end
  end

  def add_boxes
    i = 0
    world.grid.each do |column|
      column.each do |cell|
        if (cell.alive == true)
          @boxes << Mittsu::Mesh.new(
            Mittsu::BoxGeometry.new(20.0, 20.0, 1.0),
            Mittsu::MeshBasicMaterial.new(color: 0x00ff00))
          @boxes[i].position.elements = [(cell.x+10)+(cell.x*20), (cell.y+990)-(cell.y*20), 1.0]
          scene_ortho.add(@boxes[i])
          i+=1
        end
      end
    end
  end

  def remove_boxes
    if @boxes.count >0
      @boxes.each do |box|
        @scene_ortho.remove(box)
      end
    end
  end

  def get_start_points
  add_boxes
  @game.next_generation
  render
  end

  def render

    camera_ortho = Mittsu::OrthographicCamera.new(-SCREEN_WIDTH / 2.0, SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0, -SCREEN_HEIGHT / 2.0, 1.0, 10.0)
    camera_ortho.position.z = 10.0

    renderer = Mittsu::OpenGLRenderer.new width: SCREEN_WIDTH, height: SCREEN_HEIGHT, title: "Adam's Conways Game Of Life "
    renderer.auto_clear = false

    renderer.window.on_resize do |width, height|
      camera_ortho.left = -width / 2.0
      camera_ortho.right = width / 2.0
      camera_ortho.top = height / 2.0
      camera_ortho.bottom = -height / 2.0
      camera_ortho.update_projection_matrix
    end

    renderer.window.run do
      renderer.clear
      renderer.render(@scene_ortho, camera_ortho)
      @scene_ortho = Mittsu::Scene.new
      @boxes = []
      add_boxes
      @game.next_generation
    end
  end
end

Render.new(World.new, Mittsu::Scene.new)
