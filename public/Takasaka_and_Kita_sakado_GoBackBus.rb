
hour_now = 21
minutes_now = 20 #00:00~23:59という前提にしたため、書き換えています


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
                  "21:08","21:37"]

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
                     "20:31"]

# takasaka_list_minute = []
# takasaka_daiya.each do |takasaka|
#   takasaka_hour = (takasaka[0] + takasaka[1]).to_i
#   takasaka_minute = (takasaka[3] + takasaka[4]).to_i
#   takasaka_list_minute.push(takasaka_hour*60 + takasaka_minute)
# end #バス時刻を00:00からの時間（分）に直す


takasaka_list_minute = [586, 607, 616, 630, 646, 661, 676, 682, 691, 706, 721,
                        736, 751, 765, 767, 772, 780, 783, 787, 790, 796, 802,
                        811, 826, 841, 856, 871, 886, 892, 903, 910, 915, 920,
                        925, 930, 934, 940, 945, 952, 961, 974, 986, 999, 1004,
                        1010, 1015, 1025, 1030, 1035, 1040, 1045, 1050, 1055, 1060,
                        1073, 1087, 1095, 1100, 1106, 1117, 1123, 1130, 1135, 1140,
                        1145, 1150, 1155, 1160, 1165, 1174, 1184, 1195, 1208, 1225,
                        1238, 1245, 1255, 1268, 1297]

kita_sakado_list_minute = [626, 698, 740, 770, 786, 846, 876, 936, 950, 998,
                           1014, 1034, 1046, 1072, 1105, 1134, 1153, 1183, 1231]


takasaka_list_minute.sort!
kita_sakado_list_minute.sort!


now = hour_now*60 + minutes_now #現在時刻を00:00からの時間（分）に直す


can_take_takasaka_minute = []
takasaka_list_minute.each do |takasaka|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
  if can_take_takasaka_minute.length >= 3
    break #バスが３つ当てはまれば終了
  elsif takasaka >= now
    can_take_takasaka_minute.push(takasaka)
  end
end #当てはまるバスが２つ以下の場合はeach文が終了

can_take_kita_sakado_minute = []
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

if can_take_takasaka.empty?;
  p '今日の大学発高坂駅行きダイヤはもうありません。'
  # takasaka_daiya.each do |takasaka|
  #   p takasaka
  # end
else;
  p "大学発高坂駅行きバスのダイヤです"
  if can_take_takasaka.include?("21:37") && can_take_takasaka.length == 1;
    p "WARNING:最終便(21:37)が近づいています。お急ぎください。"
  elsif can_take_takasaka.include?("21:37") && can_take_takasaka.include?("21:08") && can_take_takasaka.length == 2;
    p "勉強・部活・サークル活動、お疲れ様です。最終便(21:37)が約30分後に近づいています。ご注意ください。"
  elsif can_take_takasaka.include?("21:37") && can_take_takasaka.include?("21:08") && can_take_takasaka.include?("20:55") && can_take_takasaka.length ==1;
    p "勉強・部活・サークル活動、お疲れ様です。最終便(21:37)が約50分後に近づいています。ご注意ください。"
  end
  p can_take_takasaka
end

if can_take_kita_sakado.empty?;
  p '今日の大学発北坂戸駅行きダイヤはもうありません。高坂駅を経由してください。'
  # kita_sakado_daiya.each do |kita_sakado|
  #   p kita_sakado
  # end
else;
  p "大学発北坂戸駅行きバスのダイヤです"
  if can_take_kita_sakado.include?("20:31") && can_take_kita_sakado.length == 1;
    p "WARNING:最終便(20:31)が近づいています。お急ぎください。"
  elsif can_take_kita_sakado.include?("20:31") && can_take_kita_sakado.include?("19:43") && can_take_kita_sakado.length == 2;
    p "勉強・部活・サークル活動、お疲れ様です。最終便(21:37)が約50分後に近づいています。ご注意ください。"
  end
  p can_take_kita_sakado
end
