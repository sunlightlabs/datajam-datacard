class Object
  def to_f_if_possible
    Float(self) rescue self
  end
end
