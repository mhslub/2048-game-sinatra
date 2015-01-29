require_relative 'tile'
require_relative 'score'

class Contents 
  attr_accessor :contents
  attr_reader :color_map
  
  def change_conts(c)
    (0...@contents.size).each  do |i|
      @contents[i].text = c[i].text
    end
  
  end
    
  def initialize()
    @contents=Array.new
    #initialize the color map
    @color_map = {"#{2}" => "#00CC99",
      "#{2**2}" => "#A0CD99",
      "#{2**3}" => "#FBCA99",
      "#{2**4}" => "#D1BC99",
      "#{2**5}" => "#C0CD99",
      "#{2**6}" => "#E05C99",
      "#{2**7}" => "#0FEC99",
      "#{2**8}" => "#30EF99",
      "#{2**9}" => "#04FC99",
      "#{2**10}" => "#AABC99",
      "#{2**11}" => "#BBEC99",
      "#{2**12}" => "#CCAC99",
      "#{2**13}" => "#DDDC99",
      "#{2**14}" => "#EEFC99",
      "#{2**15}" => "#FFCC49",
      "#{2**16}" => "#ABDC59",
      "#{2**17}" => "#BCFC99",
      "#{2**18}" => "#CDFE99",
  
    }
    
    generateContents
   
  end
  
  def generateContents()
 
    #initialize with empty tiles
    (0...16).each do |i|
      @grid_item = Griditem.new("")
      @grid_item.current_pos =  i
      @contents.push(@grid_item)
    end
    
    #choose two random places
    #add the first number
    @grid_item = Griditem.new("2" ,@color_map["2"])
    @pos= rand(16)
    @grid_item.current_pos=@pos
    @contents[@pos]= @grid_item
    
    #add the second number
    while @contents[@pos].text == "2"
      @pos=rand(16)
    end
    @grid_item = Griditem.new("2",@color_map["2"])
    @grid_item.current_pos=@pos
    @contents[@pos]= @grid_item
    
  end
  
  #detect gameover
  def detectGameOver()
    #is it possible to move in a direction
    return !(moreMoves() || moreMergers(1) || moreMergers(2) || moreMergers(3) || moreMergers(4))
  end
      
  def detectWin()
    res=false
    i=0
    while(!res && i < contents.size)
      if(contents[i].text == "2048")
        res=true
        break
      end
      
      i= i+1
    end
    return res
  end        
  
  #scan the contents to detect if there are empty cells
  def moreMoves()
    more_moves=false
    i=0
    
    while !more_moves && i < @contents.size
      #if there is at least one tile left
      if(@contents[i].text == "")
        more_moves=true
        break    
      end
      i= i+1
    end
    return more_moves
  end
  
  
  #add 2 at a random position for each move
  def addOneNum()
    if(moreMoves)
      pos=rand(16)
      while(contents[pos].text != "")
        pos=rand(16)
      end
      grid_item = Griditem.new("2",@color_map["2"])
      grid_item.current_pos=pos
      contents[pos]= grid_item
    
      return true
    else
      return false   
    end
  end
  
  #perform move one step action in a direction
  def move_oneStep(dir)
    res=false
    (0...16).each do |i|
      current_item = contents[i]
      if(current_item.text != "")
        #get its neighbor
        val=contents[i].getVal(contents, dir)
        #move one step if the neighbor is empty
        if(val != nil && val.text == "")
          #put empty here
          empty = Griditem.new("")
          empty.current_pos=current_item.current_pos
          contents[current_item.current_pos]= empty
          #move the item
          current_item.current_pos = val.current_pos
          contents[val.current_pos]=current_item
          
          res=true
        end
      end
    end
    
    return res
  end
  
  #detect if there are possible merges
  def moreMergers(dir)
    pos =0
    res=false
    temp = Array.new
    (0...contents.size).each do |i|
      temp.push(contents[i])
    end
    #for all columns
    (0...4).each do |i|
      #scan each column based on the direction
      (1...4).each do |j|
        case dir
        when 1
          pos = j*4 + i
        when 3
          pos =j+i * 4
        when 2
          pos=(3-j)+i * 4
        when 4
          pos=(12 - j * 4) + i
        else
          pos=0
        end
        #get current element
        current_item = temp[pos]
        if(current_item.text != "")
          neighbor =temp[pos].getVal(temp, dir)
          #merge two tiles if they have the same number
          if(neighbor !=nil && neighbor.text == current_item.text)
            res=true
            break
          end
        end
        
      end
    end
    return res
    
  end
  
  #the following is to perform the merging when moving in a direction
  def mergeOneTime(dir)
    pos = 0
    sum = 0 #the sum of all successful merges for the score
    
    #copy the contents into temp
    temp = Array.new
    (0...contents.size).each do |i|
      temp.push(contents[i])
    end
    
    #since the direction affects choosing which tiles to merge
    #scan each direction using different indexes
    
    #for all columns
    (0...4).each do |i|
      #scan each column based on the direction
      (1...4).each do |j|
        case dir
        when 1 #moving up
          pos = j*4 + i
        when 3 #moving left
          pos =j+i * 4
        when 2 #moving right
          pos=(3-j)+i * 4
        when 4 #moving down
          pos=(12 - j * 4) + i
        else
          pos=0
        end
        #get current element
        current_item = temp[pos]
        if(current_item.text != "")
          neighbor =temp[pos].getVal(temp, dir)
          #merge two tiles if they have the same number
          if(neighbor !=nil && neighbor.text == current_item.text)
            #put the empty here
            empty = Griditem.new("")
            empty.current_pos=current_item.current_pos
            contents[current_item.current_pos]= empty
            
            #modify the neighbor
            num=neighbor.text.to_i
            new_val =Griditem.new((num * 2).to_s,@color_map[(num * 2).to_s])
            new_val.current_pos = neighbor.current_pos
            contents[neighbor.current_pos] = new_val
            
            sum = sum+ (num * 2)
            
            #if one successful merge then break scanning
            break
            
          end
        end
        
      end
    end
    return sum
    
  end
    
  #perform move up
  def moveUp(obj)
    tr = move_oneStep(1)
    #while we can move
    while(tr == true)
      tr = move_oneStep(1)
    end
    
    #merge one time
    s = mergeOneTime(1)
    obj.sc+=s
    #move up again
    tr2 = move_oneStep(1)
    #while we can move
    while(tr2 == true)
      tr2= move_oneStep(1)
    end
    
    addOneNum
    return tr || tr2
    
  end
    
  #perform move down
  def moveDown(obj)
    tr = move_oneStep(4)
    #while we can move
    while(tr == true)
      tr = move_oneStep(4)
    end
    
    #merge one time
    s = mergeOneTime(4)
    obj.sc+=s
    #move up again
    tr2 = move_oneStep(4)
    #while we can move
    while(tr2 == true)
      tr2= move_oneStep(4)
    end
    
    addOneNum
    return tr || tr2
    
  end
    
  #perform move right
  def moveRight(obj)
    tr = move_oneStep(2)
    #while we can move
    while(tr == true)
      tr = move_oneStep(2)
    end
    
    #merge one time
    s = mergeOneTime(2)
    obj.sc+=s
    #move up again
    tr2 = move_oneStep(2)
    #while we can move
    while(tr2 == true)
      tr2= move_oneStep(2)
    end
    
    addOneNum
    return tr || tr2
    
  end
    
  #perform move left
  def moveLeft(obj)
    tr = move_oneStep(3)
    #while we can move
    while(tr == true)
      tr = move_oneStep(3)
    end
    
    #merge one time
    s = mergeOneTime(3)
    obj.sc+=s
    #move up again
    tr2 = move_oneStep(3)
    #while we can move
    while(tr2 == true)
      tr2= move_oneStep(3)
    end
    
    addOneNum
    return tr || tr2
    
  end
end
