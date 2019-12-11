
hour_now = 18
minutes_now = 30 #00:00~23:59という前提にしたため、書き換えています
#
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
                  "19:00","19:25"
                  ]

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
  elsif takasaka >= now
    can_take_takasaka_minute.push(takasaka)
  end
end #当てはまるバスが２つ以下の場合はeach文が終了

kita_sakado_list_minute.each do |kita_sakado|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
  if can_take_kita_sakado_minute.length >= 3
    break #バスが３つ当てはまれば終了
  elsif kita_sakado >= now
    can_take_kita_sakado_minute.push(kita_sakado)
  end
end #当てはまるバスが２つ以下の場合はeach文が終了

def add_zero(num) #1桁の場合は前に0を追加する
  if num < 10
    return "0" + num.to_s
  else
    return num.to_s
  end
end

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

what_time_now = add_zero(hour_now) + ':' + add_zero(minutes_now)
p '現在時刻は,' + what_time_now.to_s

if can_take_takasaka.empty? then
  p '今日のダイヤはもうありません。以下が平日の高坂駅発ダイヤです'
  takasaka_daiya.each do |takasaka|
    p takasaka
  end
else;
  p '高坂駅発大学行きバスのダイヤです'
  p can_take_takasaka
end


if can_take_kita_sakado.empty? then
  p '今日のダイヤはもうありません。高坂駅を経由してください。'
  # kita_sakado_daiya.each do |kita_sakado|
  #   p kita_sakado
  # end
else;
  p '北坂戸駅発大学行きバスのダイヤです'
  p can_take_kita_sakado
end
