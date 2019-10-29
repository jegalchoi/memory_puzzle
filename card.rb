class Card
  attr_accessor :face_up, :face_up_value
  attr_reader :face_down_value

  def initialize(value)
    @face_up = false
    @face_down_value = " "
    @face_up_value = value
  end

  def hide
    @face_up = false
    @face_down_value
  end

  def reveal
    @face_up = true
    @face_up_value
  end

end