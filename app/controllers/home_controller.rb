class HomeController < ApplicationController


  def index
  end

  def result
    #日時、曜日関係
    time = Time.now
    time_1 = time.hour #Ex.0,1,2,3,4,5,/~/,19,20,21,22,23
    time_2 = time.min #Ex,0,1,2,3,4,/~/55,56,57,58,59
    time_3 = time.wday#[1.Mon2.Tue3.Wed4.Thurs5.Fri6.Sat7.Sun]
    @time_4 = [time_1.to_s,time_2.to_s]
    #paramsから取得する現在地情報、つまり、駅名
    user_location = params[:present_location] #高坂駅・北坂戸駅 or 熊谷駅
    @print_user_location = user_location
    if user_location == "高坂駅・北坂戸駅" && time_3 != 6 && time_3 != 7;
      @result = GO_from_Takasaka_or_Kitasakado(time_1,time_2)
    elsif user_location == "熊谷駅" && time_3 != 6 && time_3 != 7;
      @result = Go_from_kumagaya(time_1,time_2)
    else;
      @result = "平日以外は本アプリケーションの適応範囲外となります。"
    end

  end

  def go_home
  end

  def go_home_result
    time = Time.now
    time_1 = time.hour
    time_2 = time.min
    time_3 = time.wday#[1.Mon2.Tue3.Wed4.Thurs5.Fri6.Sat7.Sun]
    @time_4 = [time_1.to_s,time_2.to_s]

    user_destination = params[:destination]

    if user_destination == "高坂駅・北坂戸駅" && time_3 != 6 && time_3 != 7 then
      @result = `ruby /Users/horiguchihiroki/TDU_Bus_Time/public/Takasaka_and_Kita_sakado_GoBackBus.rb #{time_1} #{time_2}`
    elsif user_destination == "熊谷駅" && time_3 != 6 && time_3 != 7;
      @result = `ruby /Users/horiguchihiroki/TDU_Bus_Time/public/Kumagaya_Goback_Bus.rb #{time_1} #{time_2}`
    else;
      @result = "平日以外は本アプリケーションの適応範囲外となります。"
    end
  end

  private
  def GO_from_Takasaka_or_Kitasakado(hour,minutes)

    hour_now = hour
    minutes_now = minutes #00:00~23:59という前提にしたため、書き換えています

    takasaka_daiya = ["08:20","08:25","08:28","08:30","08:35","08:41","08:42","08:45","08:49","08:50","08:55","08:58",
                      "09:01","09:05","09:07","09:10","09:11","09:15","09:26","09:33","09:41","09:50","09:56",
                      "10:04","10:10","10:20","10:26","10:29","10:36","10:40","10:42","10:43","10:45","10:52","10:53","10:56",
                      "11:02","11:05","11:06","11:16","11:27","11:40","11:53",
                      "12:05","12:21","12:35","12:51","12:55","12:59",
                      "13:05","13:10","13:15","13:20","13:25","13:29","13:35","13:51",
                      "14:05","14:21","14:35","14:51","14:59",
                      "15:05","15:13","15:21","15:29","15:35","15:51",
                      "16:05","16:21","16:35","16:51",
                      "17:00","17:05","17:21","17:35","17:51",
                      "18:10","18:40",
                      "19:00","19:25"]

    kita_sakado_daiya = ["08:23","08:48",
                         "09:04","09:38",
                         "10:08","10:38","10:58",
                         "11:50",
                         "12:32",
                         "13:02","13:18",
                         "14:18","14:48",
                         "15:48",
                         "16:02","16:50",
                         "17:06",
                         "18:04"]
    #高坂駅のダイヤが変更されたら、以下のプログラムを、上記のtakasaka_daiyaを変更して実行してください。そして、実行結果を以下のtakasaka_list_minuteに反映してください。
    # takasaka_list_minute = []
    # takasaka_daiya.each do |takasaka|
    #   takasaka_hour = (takasaka[0] + takasaka[1]).to_i
    #   takasaka_minute = (takasaka[3] + takasaka[4]).to_i
    #   takasaka_list_minute.push(takasaka_hour*60 + takasaka_minute)
    # end #バス時刻を00:00からの時間（分）に直す

    takasaka_list_minute = [500, 505, 508, 510, 515, 521, 522, 525, 529, 530, 535,
                            538, 541, 545, 547, 550, 551, 555, 566, 573, 581, 590,
                            596, 604, 610, 620, 626, 629, 636, 640, 642, 643, 645,
                            652, 653, 656, 662, 665, 666, 676, 687, 700, 713, 725,
                            741, 755, 771, 775, 779, 785, 790, 795, 800, 805, 809,
                            815, 831, 845, 861, 875, 891, 899, 905, 913, 921, 929,
                            935, 951, 965, 981, 995, 1011, 1020, 1025, 1041, 1055,
                            1071, 1090, 1120, 1140, 1165]

    kita_sakado_list_minute = [503, 528, 544, 578, 608, 638, 658, 710, 752, 782,
                               798, 858, 888, 948, 962, 1010, 1026, 1084
                               ]

    takasaka_list_minute.sort!
    kita_sakado_list_minute.sort!

    now = hour_now*60 + minutes_now #現在時刻を00:00からの時間（分）に直す

    can_take_takasaka_minute = []
    can_take_kita_sakado_minute = []


    takasaka_list_minute.each do |takasaka|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
      if can_take_takasaka_minute.length >= 3
        break #バスが３つ当てはまれば終了
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end #当てはまるバスが２つ以下の場合はeach文が終了

    kita_sakado_list_minute.each do |kita_sakado|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
      if can_take_kita_sakado_minute.length >= 3
        break #バスが３つ当てはまれば終了
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end #当てはまるバスが２つ以下の場合はeach文が終了


    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|#00:00からの時間（分）を元の時刻に戻す
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|#00:00からの時間（分）を元の時刻に戻す
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end


    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['今日のバスはもうありません。以下が、平日の高坂・北坂戸発大学行きダイヤです。',takasaka_daiya,kita_sakado_daiya]
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['高坂駅発大学行きバスダイヤです。北坂戸駅発はもうありません。',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return[can_take_takasaka,can_take_kita_sakado]
    end
  end


  def add_zero(num) #1桁の場合は前に0を追加する
    if num < 10
      return "0" + num.to_s
    else
      return num.to_s
    end
  end

  def Go_from_kumagaya(hour,minutes)

    hour_now = hour
    minutes_now = minutes

    kumagaya_daiya = ["08:05","08:15","08:20","10:00","10:05","10:10","12:30","12:40","14:30","16:20"]

    # kumagaya_list_minute = []
    # kumagaya_daiya.each do |kumagaya|
    #   kumagaya_hour = (kumagaya[0] + kumagaya[1]).to_i
    #   kumagaya_minute = (kumagaya[3] + kumagaya[4]).to_i
    #   kumagaya_list_minute.push(kumagaya_hour*60 + kumagaya_minute)
    # end #バス時刻を00:00からの時間（分）に直す

    kumagaya_list_minute = [485, 495, 500, 600, 605, 610, 750, 760, 870, 980]


    kumagaya_list_minute.sort!

    now = hour_now*60 + minutes_now #現在時刻を00:00からの時間（分）に直す
    can_take_kumagaya_minute = []
    kumagaya_list_minute.each do |kumagaya|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
      if can_take_kumagaya_minute.length >= 3
        break #バスが３つ当てはまれば終了
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end #当てはまるバスが２つ以下の場合はeach文が終了

    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|#00:00からの時間（分）を元の時刻に戻す
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end



    if can_take_kumagaya.empty?;
      return['今日のダイヤはもうありません。以下が平日の熊谷駅発ダイヤです。各自、遅れないよう確認してください。',kumagaya_daiya]
    else;
      return(can_take_kumagaya)
    end
  end
end
