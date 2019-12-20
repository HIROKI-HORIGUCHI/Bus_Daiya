class HomeController < ApplicationController

  # レンダリング用のクラスメソッド
  def index
    time = Time.now
    @times = [time.hour,time.min,time.wday]
  end
  def go_home
    time = Time.now
    @times = [time.hour,time.min,time.wday]
  end

  def result
    #日時、曜日関係
    time = Time.now
    time_1 = params[:selected_hour].to_i #Ex.0,1,2,3,4,5,/~/,19,20,21,22,23
    time_2 = params[:selected_minutes].to_i #Ex,0,1,2,3,4,/~/55,56,57,58,59
    @time_4 = [time_1.to_s,time_2.to_s]

    #それぞれの処理に応じて、別々のメソッドを呼び出すことで対応する。
    @print_user_location = params[:present_location]
    if params[:selected_period] == "授業期間中" then
      if params[:present_location] == "高坂駅・北坂戸駅" && params[:selected_date] == "平日";
        @result = GO_from_Takasaka_or_Kitasakado(time_1,time_2)
      elsif params[:present_location] == "熊谷駅" && params[:selected_date] == "平日";
        @result = Go_from_kumagaya(time_1,time_2)
      elsif params[:present_location] == "高坂駅・北坂戸駅" && params[:selected_date] == "土曜日"
        @result = Go_from_Takasaka_or_Kitasakado_saturday(time_1,time_2)
      elsif params[:present_location] == "熊谷駅" && params[:selected_date] == "土曜日"
        @result = Go_from_Kumagaya_saturday(time_1,time_2)
      end
    elsif params[:selected_period] == "休業期間中";
      if params[:present_location] == "高坂駅・北坂戸駅" && params[:selected_date] == "平日" then
        @result = Go_from_Takasaka_or_Kitasakado_restperiod(time_1,time_2)
      elsif params[:present_location] == "高坂駅・北坂戸駅" && params[:selected_date] == "土曜日";
        @result = "休業期間中の土曜日です。休業期間中の休日、祝日はバスが運行していないので、高坂駅から発車する課金バスをご利用ください。"
      elsif params[:present_location] == "熊谷駅" && params[:selected_date] == "平日";
        @result = Go_from_Kumagaya_restpriod(time_1,time_2)
      elsif params[:present_location] == "熊谷駅" && params[:selected_date] == "土曜日";
        @result = "休業期間中の土曜日です。休業期間中の休日、祝日はバスが運行していません。ご注意ください。大学に行く場合は、熊谷駅から発車する課金バスをご利用ください"
      end
    end
  end



  def go_home_result
    # 日時、曜日関係
    time = Time.now
    time_1 = params[:selected_hour].to_i
    time_2 = params[:selected_minutes].to_i
    @time_4 = [time_1.to_s,time_2.to_s]

    # ユーザーの目的地(destination)を取得する。これは、Viewで使う予定だからやる
    @user_destination = params[:destination]

    # 期間の場合わけ１：授業期間の場合
    if params[:selected_period] == "授業期間中" then
      #目的地と、その日が平日なのか土曜日なのかで場合わけ
      if params[:destination] == "高坂駅・北坂戸駅" && params[:selected_date] == "平日" then
        @result = Takasaka_and_Kita_sakado_GoBackBus(time_1,time_2)
      elsif params[:destination] == "熊谷駅" && params[:selected_date] == "平日";
        @result = Kumagaya_GoBack_Bus(time_1,time_2)
      elsif params[:destination] == "高坂駅・北坂戸駅" && params[:selected_date] == "土曜日";
        @result = Takasaka_and_Kita_sakado_GoBackBus_saturday(time_1,time_2)
      elsif params[:destination] == "熊谷駅" && params[:selected_date] == "土曜日";
        @result = Kumagaya_GoBack_Bus_saturday(time_1,time_2)
      end
    elsif params[:selected_period] == "休業期間中";
      if params[:destination] == "高坂駅・北坂戸駅" && params[:selected_date] == "平日" then
        @result = Takasaka_and_Kita_sakado_GoBackBus_restperiod(time_1,time_2)
      elsif params[:destination] == "高坂駅・北坂戸駅" && params[:selected_date] == "土曜日";
        @result = "休業期間中の土曜日です。休業期間中の休日、祝日はバスが運行していません。"
      elsif params[:destination] == "熊谷駅" && params[:selected_date] == "平日";
        @result = Kumagaya_GoBack_Bus_restperiod(time_1,time_2)
      elsif params[:destination] == "熊谷駅" && params[:selected_date] == "土曜日";
        @result = "休業期間中の土曜日です。休業期間中の休日、祝日はバスが運行していません。"
      end
    end
  end

  private

  def Go_from_Takasaka_or_Kitasakado_restperiod(hour,minutes)
    hour_now = hour
    minutes_now = minutes

    takasaka_daiya = ["08:42","08:56",
                      "09:11","09:26","09:33","09:41","09:56",
                      "10:10","10:26","10:40","10:53",
                      "11:06","11:16","11:40","11:53",
                      "12:05","12:35","12:51",
                      "13:05","13:35","13:51",
                      "14:05","14:35","14:51",
                      "15:05","15:35","15:51",
                      "16:05","16:36","16:51",
                      "17:05","17:21","17:51",
                      "18:10","18:40"].freeze

    kita_sakado_daiya = ["08:48",
                         "09:23",
                         "10:37",
                         "11:12",
                         "12:18",
                         "13:18",
                         "14:18",
                         "15:18",
                         "16:13"].freeze

    takasaka_list_minute = [522, 536, 551, 566, 573, 581, 596, 610, 626, 640,
                            653, 666, 676, 700, 713, 725, 755, 771, 785, 815,
                            831, 845, 875, 891, 905, 935, 951, 965, 996, 1011,
                            1025, 1041, 1071, 1090, 1120].freeze

    kita_sakado_list_minute = [528, 563, 637, 672, 738, 798, 858, 918, 973].freeze



    now = hour_now*60 + minutes_now

    can_take_takasaka_minute = []
    can_take_kita_sakado_minute = []


    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end


    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end


    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['休業-平日-高坂・北坂戸-ダイヤなし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['休業-平日-高坂・北坂戸-北坂戸のみダイヤなし',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['休業-平日-高坂・北坂戸-両方ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end



  def Go_from_Kumagaya_restpriod(hour,minutes)
    hour_now = hour
    minutes_now = minutes

    kumagaya_daiya = ["08:20","10:00","12:30"].freeze


    kumagaya_list_minute = [500, 600, 750].freeze



    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []
    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end

    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end



    if can_take_kumagaya.empty?;
      return['休業期間-平日-熊谷ダイヤなし']
    else;
      return['休業期間-平日-熊谷ダイヤ',can_take_kumagaya]
    end
  end


  def Takasaka_and_Kita_sakado_GoBackBus_restperiod(hour,minutes)
    hour_now = hour
    minutes_now = minutes


    takasaka_daiya = ["9:46",
                      "10:16","10:22","10:31","10:46",
                      "11:01","11:16","11:31","11:46",
                      "12:16","12:31","12:46",
                      "13:16","13:31","13:46",
                      "14:16","14:31","14:46",
                      "15:16","15:34","15:45",
                      "16:08","16:26","16:39","16:55",
                      "17:08","17:26","17:39","17:53",
                      "18:07","18:26","18:37","18:55",
                      "19:07","19:26","16:39","19:55",
                      "20:08","20:25","20:38",
                      "21:08"].freeze

    kita_sakado_daiya = ["10:25",
                         "11:00",
                         "12:06",
                         "13:06",
                         "14:06",
                         "15:06",
                         "16:01",
                         "17:44"].freeze

    takasaka_list_minute = [586, 616, 622, 631, 646, 661, 676, 691, 706, 736,
                            751, 766, 796, 811, 826, 856, 871, 886, 916, 934,
                            945, 968, 986, 999, 1015, 1028, 1046, 1059, 1073,
                            1087, 1106, 1117, 1135, 1147, 1166, 999, 1195, 1208,
                            1225, 1238, 1268].freeze

    kita_sakado_list_minute = [625, 660, 726, 786, 846, 906, 961, 1064].freeze




    now = hour_now*60 + minutes_now


    can_take_takasaka_minute = []
    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    can_take_kita_sakado_minute = []
    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end

    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end

    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['休業-平日-高坂・北坂戸-ダイヤなし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['休業-平日-高坂・北坂戸-北坂戸のみダイヤなし',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['休業-平日-高坂・北坂戸-両方ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end

  def Kumagaya_GoBack_Bus_restperiod(hour,minutes)
    hour_now = hour
    minutes_now = minutes

    kumagaya_daiya = ["11:45",
                      "15:30",
                      "17:20",
                      "19:10"].freeze

    kumagaya_list_minute = [705, 930, 1040, 1150]


    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []

    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end

    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end

    if can_take_kumagaya.empty?;
      return['休業期間-平日-熊谷ダイヤなし']
    else;
      return['休業期間-土曜-熊谷ダイヤあり',can_take_kumagaya]
    end
  end


  def add_zero(num) #1桁の場合は前に0を追加する
    if num < 10
      return "0" + num.to_s
    else
      return num.to_s
    end
  end


  def GO_from_Takasaka_or_Kitasakado(hour,minutes)

    hour_now = hour
    minutes_now = minutes

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
                      "19:00","19:25"].freeze

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
                         "18:04"].freeze

    takasaka_list_minute = [500, 505, 508, 510, 515, 521, 522, 525, 529, 530, 535,
                            538, 541, 545, 547, 550, 551, 555, 566, 573, 581, 590,
                            596, 604, 610, 620, 626, 629, 636, 640, 642, 643, 645,
                            652, 653, 656, 662, 665, 666, 676, 687, 700, 713, 725,
                            741, 755, 771, 775, 779, 785, 790, 795, 800, 805, 809,
                            815, 831, 845, 861, 875, 891, 899, 905, 913, 921, 929,
                            935, 951, 965, 981, 995, 1011, 1020, 1025, 1041, 1055,
                            1071, 1090, 1120, 1140, 1165].freeze

    kita_sakado_list_minute = [503, 528, 544, 578, 608, 638, 658, 710, 752, 782,
                               798, 858, 888, 948, 962, 1010, 1026, 1084].freeze



    now = hour_now*60 + minutes_now

    can_take_takasaka_minute = []
    can_take_kita_sakado_minute = []


    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end


    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end


    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['授業期間中-平日-高坂・北坂戸-両方ダイヤなし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return ['授業期間中-平日-高坂・北坂戸-北坂戸のみダイヤなし',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['授業-平日-高坂・北坂戸ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end



  def Go_from_Takasaka_or_Kitasakado_saturday(hour,minutes)
    hour_now = hour
    minutes_now = minutes

    takasaka_daiya = ["08:35","08:55",
                      "09:05","09:15","09:35","09:45","09:54",
                      "10:05","10:21","10:41","10:53",
                      "11:06","11:21","11:35","11:53",
                      "12:05","12:35","12:51",
                      "13:05","13:35","13:51",
                      "14:05","14:35","14:51",
                      "15:05","15:35","15:51",
                      "16:36","16:51",
                      "17:21","17:53",
                      "18:05"].freeze

    kita_sakado_daiya = ["08:42",
                         "09:42",
                         "10:18",
                         "11:50",
                         "12:18",
                         "13:18",
                         "14:48",
                         "15:18"].freeze

    takasaka_list_minute = [515, 535, 545, 555, 575, 585, 594, 605, 621, 641,
                            653, 666, 681, 695, 713, 725, 755, 771, 785, 815,
                            831, 845, 875, 891, 905, 935, 951, 996, 1011, 1041,
                            1073, 1085].freeze

    kita_sakado_list_minute = [522, 582, 618, 710, 738, 798, 888, 918].freeze


    now = hour_now*60 + minutes_now

    can_take_takasaka_minute = []
    can_take_kita_sakado_minute = []


    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end


    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end
    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-ダイヤなし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-高坂のみダイヤあり',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-両方ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end


  def Go_from_kumagaya(hour,minutes)
    hour_now = hour
    minutes_now = minutes
    kumagaya_daiya = ["08:05","08:15","08:20","10:00","10:05","10:10","12:30","12:40","14:30","16:20"].freeze
    kumagaya_list_minute = [485, 495, 500, 600, 605, 610, 750, 760, 870, 980].freeze
    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []
    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end
    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end
    if can_take_kumagaya.empty?;
      return['授業期間-平日-熊谷ダイヤなし']
    else;
      return['授業期間-平日-熊谷ダイヤあり',can_take_kumagaya]
    end
  end




  def Go_from_Kumagaya_saturday(hour,minutes)
    hour_now = hour
    minutes_now = minutes
    kumagaya_daiya = ["08:20","10:00","12:30"].freeze
    kumagaya_list_minute = [500, 600, 750].freeze
    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []
    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end
    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end
    if can_take_kumagaya.empty?;
      return['授業期間-土曜-熊谷ダイヤなし']
    else;
      return['授業期間-土曜-熊谷ダイヤあり',can_take_kumagaya]
    end
  end


  def Takasaka_and_Kita_sakado_GoBackBus(hour,minutes)

    hour_now = hour
    minutes_now = minutes
    takasaka_daiya = ["09:46",
                      "10:07","10:16","10:30","10:46",
                      "11:01","11:16","11:22","11:31","11:46",
                      "12:01","12:16","12:31","12:45","12:47","12:52",
                      "13:00","13:03","13:07","13:10","13:16","13:22","13:31","13:46",
                      "14:01","14:16","14:31","14:46","14:52",
                      "15:03","15:10","15:15","15:20","15:25","15:30","15:34","15:40","15:45","15:52",
                      "16:01","16:14","16:26","16:39","16:44","16:50","16:55",
                      "17:05","17:10","17:15","17:20","17:25","17:30","17:35","17:40","17:53",
                      "18:07","18:15","18:20","18:26","18:37","18:43","18:50","18:55",
                      "19:00","19:05","19:10","19:15","19:20","19:25","19:34","19:44","19:55",
                      "20:08","20:25","20:38","20:45","20:55",
                      "21:08","21:37"].freeze

    kita_sakado_daiya = ["10:26",
                         "11:38",
                         "12:20","12:50",
                         "13:06",
                         "14:06","14:36",
                         "15:36","15:50",
                         "16:38","16:54",
                         "17:14","17:26","17:52",
                         "18:25","18:54",
                         "19:13","19:43",
                         "20:31"].freeze

    takasaka_list_minute = [586, 607, 616, 630, 646, 661, 676, 682, 691, 706, 721,
                            736, 751, 765, 767, 772, 780, 783, 787, 790, 796, 802,
                            811, 826, 841, 856, 871, 886, 892, 903, 910, 915, 920,
                            925, 930, 934, 940, 945, 952, 961, 974, 986, 999, 1004,
                            1010, 1015, 1025, 1030, 1035, 1040, 1045, 1050, 1055, 1060,
                            1073, 1087, 1095, 1100, 1106, 1117, 1123, 1130, 1135, 1140,
                            1145, 1150, 1155, 1160, 1165, 1174, 1184, 1195, 1208, 1225,
                            1238, 1245, 1255, 1268, 1297].freeze

    kita_sakado_list_minute = [626, 698, 740, 770, 786, 846, 876, 936, 950, 998,
                               1014, 1034, 1046, 1072, 1105, 1134, 1153, 1183, 1231].freeze


    now = hour_now*60 + minutes_now
    can_take_takasaka_minute = []
    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    can_take_kita_sakado_minute = []
    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end
    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end
    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業-平日-高坂・北坂戸ダイヤ両方なし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業期間中-平日-高坂・北坂戸-北坂戸のみダイヤなし',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['授業-平日-高坂・北坂戸ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end



  def Takasaka_and_Kita_sakado_GoBackBus_saturday(hour,minutes)
    hour_now = hour
    minutes_now = minutes
    takasaka_daiya = ["10:03","10:16","10:32","10:46",
                      "11:01","11:16","11:31","11:46",
                      "12:16","12:31","12:46",
                      "13:16","13:31","13:46",
                      "14:16","14:31","14:46",
                      "15:16","15:31","15:55",
                      "16:10","16:25","16:40",
                      "17:10","17:40","17:55",
                      "18:10","18:25","18:55",
                      "19:10","19:40",
                      "20:10","20:40",
                      "21:07"].freeze

    kita_sakado_daiya = ["10:06",
                         "11:38",
                         "12:06",
                         "13:06",
                         "14:36",
                         "15:06",
                         "16:56",
                         "17:26",
                         "18:40"].freeze

    takasaka_list_minute = [603, 616, 632, 646, 661, 676, 691, 706, 736, 751,
                            766, 796, 811, 826, 856, 871, 886, 916, 931, 955,
                            970, 985, 1000, 1030, 1060, 1075, 1090, 1105, 1135,
                            1150, 1180, 1210, 1240, 1267].freeze

    kita_sakado_list_minute = [606, 698, 726, 786, 876, 906, 1016, 1046, 1120].freeze

    now = hour_now*60 + minutes_now
    can_take_takasaka_minute = []
    takasaka_list_minute.each do |takasaka|
      if can_take_takasaka_minute.length >= 3
        break
      elsif takasaka > now
        can_take_takasaka_minute.push(takasaka)
      end
    end

    can_take_kita_sakado_minute = []
    kita_sakado_list_minute.each do |kita_sakado|
      if can_take_kita_sakado_minute.length >= 3
        break
      elsif kita_sakado > now
        can_take_kita_sakado_minute.push(kita_sakado)
      end
    end

    can_take_takasaka = []
    can_take_takasaka_minute.each do |takasaka|
      takasaka_minute = takasaka % 60
      takasaka_hour = (takasaka - takasaka_minute) / 60
      can_take_takasaka.push(add_zero(takasaka_hour) + ":" + add_zero(takasaka_minute))
    end

    can_take_kita_sakado = []
    can_take_kita_sakado_minute.each do |kita_sakado|
      kita_sakado_minute = kita_sakado % 60
      kita_sakado_hour = (kita_sakado - kita_sakado_minute) / 60
      can_take_kita_sakado.push(add_zero(kita_sakado_hour) + ":" + add_zero(kita_sakado_minute))
    end

    if can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-ダイヤなし']
    elsif !can_take_takasaka.empty? && can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-高坂のみダイヤあり',can_take_takasaka]
    elsif !can_take_takasaka.empty? && !can_take_kita_sakado.empty?;
      return['授業期間-土曜-高坂・北坂戸-両方ダイヤあり',can_take_takasaka,can_take_kita_sakado]
    end
  end


  def Kumagaya_GoBack_Bus(hour,minutes)
    hour_now = hour
    minutes_now = minutes
    kumagaya_daiya = ["11:50",
                      "13:45",
                      "15:35",
                      "17:20","17:25",
                      "18:20",
                      "19:25",
                      "20:10","20:30",
                      "21:15"].freeze
    kumagaya_list_minute = [710, 825, 935, 1040, 1045, 1100, 1165, 1210, 1230, 1275].freeze
    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []

    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end

    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end

    if can_take_kumagaya.empty?;
      return['授業期間-平日-熊谷ダイヤなし']
    else;
      return['授業期間-平日-熊谷ダイヤあり',can_take_kumagaya]
    end
  end

  def Kumagaya_GoBack_Bus_saturday(hour,minutes)
    hour_now = hour
    minutes_now = minutes
    kumagaya_daiya = ["11:45",
                      "15:30",
                      "17:20",
                      "18:20",
                      "19:10"].freeze
    kumagaya_list_minute = [705, 930, 1040, 1100, 1150].freeze
    now = hour_now*60 + minutes_now
    can_take_kumagaya_minute = []
    kumagaya_list_minute.each do |kumagaya|
      if can_take_kumagaya_minute.length >= 3
        break
      elsif kumagaya > now
        can_take_kumagaya_minute.push(kumagaya)
      end
    end
    can_take_kumagaya = []
    can_take_kumagaya_minute.each do |kumagaya|
      kumagaya_minute = kumagaya % 60
      kumagaya_hour = (kumagaya - kumagaya_minute) / 60
      can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
    end
    if can_take_kumagaya.empty?;
      return['授業期間-土曜-熊谷ダイヤなし']
    else;
      return['授業期間-土曜-熊谷ダイヤあり',can_take_kumagaya]
    end
  end
end
