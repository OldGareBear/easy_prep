class TestsController < ApplicationController
  def new
    @test = Test.new
  end

  def create
    byebug
  end
end
