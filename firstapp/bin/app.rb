require_relative 'contents'
require_relative 'score'
require 'sinatra'
require "data_mapper"
require "rubygems"
require  'dm-migrations'
#require 'process_shared'
#require_relative 'app1'
#require_relative 'app2'

#take the port as a parameter when calling
#set :port , 8299
set :static, true
set :public_folder, "public"
set :views, "views"
#set :con, Contents.new()

DataMapper.setup(:default, 'sqlite3://'+ Dir.pwd+'/bin/contents.db')

class Cons_t
  include DataMapper::Resource
  
  property :id, Serial #key
  property :mycon, Object
end
DataMapper.auto_upgrade!
DataMapper.finalize

Cons_t.first_or_create(:id=>1).update(:mycon => Contents.new())

$status = "Playing"
$score_obj=Score.new()

get '/' do 
  redirect to('/game/?dir=0')
end

get '/game/' do
 
   obj= Cons_t.get(1).mycon
  
  case params[:dir]
  when "1"
    if $status == "Playing"
      obj.moveUp($score_obj)
      if(obj.detectGameOver())
        $status ="Game Over!"
      end    
      if(obj.detectWin())
        $status ="You Win!"
      end
    end
    @ary = obj.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
    
  when "2"
    if $status == "Playing"
      obj.moveRight($score_obj)
      if(obj.detectGameOver())
        $status ="Game Over!"
      end    
      if(obj.detectWin())
        $status ="You Win!"
      end
    end
    @ary = obj.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
    
  when "3"
    if $status == "Playing"
      obj.moveLeft($score_obj)
      if(obj.detectGameOver())
        $status ="Game Over!"
      end    
      if(obj.detectWin())
        $status ="You Win!"
      end
    end
    @ary = obj.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
   
  when "4"
    if $status == "Playing"
      obj.moveDown($score_obj)
      if(obj.detectGameOver())
        $status ="Game Over!"
      end    
      if(obj.detectWin())
        $status ="You Win!."
      end
    end
    @ary = obj.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
      
  else
    #new game is requested 
    obj =Contents.new()
    $status = "Playing"
    $score_obj=Score.new()
    @ary = obj.contents
    @msg=$status
    @alr="Press 'Enter' for a new game."
    @sc=$score_obj.sc
  end
  
  Cons_t.get(1).update(:mycon => obj)
  
  #erb is a template that uses the variable mentioned below
  erb :'index' #, :locals => {'ary' => ary , 'msg' =>msg})
end
