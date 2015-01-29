class  Griditem 
  
  attr_accessor :text
  attr_accessor :current_pos
  attr_accessor :color
  
  def initialize(text , col="#efefef")
    @text=text
    @color=col
  end
  
  def getUpVal(c)
    if @current_pos >= 4
      return c[@current_pos - 4]
    else
      return nil
    end
  end
  
  def getDownVal(c)
    if @current_pos < 12
      return c[@current_pos + 4]
    else return nil
    end 
  end
  
  def getLeftVal(c)
    if @current_pos != 0 && @current_pos != 4 && @current_pos != 8 && @current_pos != 12
      return c[@current_pos - 1]
    else 
      return nil
    end
  end
  
  def getRightVal(c)
    if @current_pos != 3 && @current_pos != 7 && @current_pos != 11 && @current_pos != 15
      return c[@current_pos + 1]
    else 
      return nil
    end
  end
  
  def getVal(c , dir)
    case dir
    when 1
      return getUpVal(c)
    when 2
      return getRightVal(c)
    when 3
      return getLeftVal(c)
    when 4
      return getDownVal(c)
    else
      return nil
    end
  end
  
end
