require_relative 'contents'
require_relative 'score'
require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "public"
set :views, "views"
#set :con, Contents.new()

$con =Contents.new()
$status = "Playing"
$score_obj=Score.new()

get '/' do 
  redirect to('/game/?dir=0')
end

get '/game/' do
  
  case params[:dir]
  when "1"
    if $status == "Playing"
      $con.moveUp($score_obj)
      if($con.detectGameOver())
        $status ="Game Over!"
      end    
      if($con.detectWin())
        $status ="You Win!"
      end
    end
    @ary = $con.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
    
  when "2"
    if $status == "Playing"
      $con.moveRight($score_obj)
      if($con.detectGameOver())
        $status ="Game Over!"
      end    
      if($con.detectWin())
        $status ="You Win!"
      end
    end
    @ary = $con.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
    
  when "3"
    if $status == "Playing"
      $con.moveLeft($score_obj)
      if($con.detectGameOver())
        $status ="Game Over!"
      end    
      if($con.detectWin())
        $status ="You Win!"
      end
    end
    @ary = $con.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
   
  when "4"
    if $status == "Playing"
      $con.moveDown($score_obj)
      if($con.detectGameOver())
        $status ="Game Over!"
      end    
      if($con.detectWin())
        $status ="You Win!."
      end
    end
    @ary = $con.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
      
  else
    #new game is requested 
    $con =Contents.new()
    $status = "Playing"
    $score_obj=Score.new()
    @ary = $con.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
  end
  
  #erb is a template that uses the variable mentioned below
  erb :'index' #, :locals => {'ary' => ary , 'msg' =>msg})
end
