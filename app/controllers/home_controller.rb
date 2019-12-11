class HomeController < ApplicationController


  def index
  end

  def result
    #日時、曜日関係
    time = Time.now
    time_1 = time.hour
    time_2 = time.min
    time_3 = time.wday#[1.Mon2.Tue3.Wed4.Thurs5.Fri6.Sat7.Sun]

    #paramsから取得する現在地情報、つまり、駅名
    user_locatioin = params[:present_location]
    puts "-------------"
    puts time,time_1,time_2,time_3
    puts user_location
    puts "-------------"



  end

  def go_home
  end

  def go_home_result
    time = Time.now
    user_destination = params[:destination]
    time_1 = time.hour
    time_2 = time.min
    time_3 = time.wday#[1.Mon2.Tue3.Wed4.Thurs5.Fri6.Sat7.Sun]
  end



end
