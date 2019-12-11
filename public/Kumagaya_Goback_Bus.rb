
hour_now = 20
minutes_now = rand(60) #00:00~23:59という前提にしたため、書き換えています

kumagaya_daiya = ["11:50",
                  "13:45",
                  "15:35",
                  "17:20","17:25",
                  "18:20",
                  "19:25",
                  "20:10","20:30",
                  "21:15"]

# kumagaya_list_minute = []
# kumagaya_daiya.each do |kumagaya|
#   kumagaya_hour = (kumagaya[0] + kumagaya[1]).to_i
#   kumagaya_minute = (kumagaya[3] + kumagaya[4]).to_i
#   kumagaya_list_minute.push(kumagaya_hour*60 + kumagaya_minute)
# end #バス時刻を00:00からの時間（分）に直す


kumagaya_list_minute = [710, 825, 935, 1040, 1045, 1100, 1165, 1210, 1230, 1275]


kumagaya_list_minute.sort!

now = hour_now*60 + minutes_now #現在時刻を00:00からの時間（分）に直す
can_take_kumagaya_minute = []

kumagaya_list_minute.each do |kumagaya|#当てはまるバスの時刻を00:00からの時間（分）のまま配列に入れる
  if can_take_kumagaya_minute.length >= 3
    break #バスが３つ当てはまれば終了
  elsif kumagaya >= now
    can_take_kumagaya_minute.push(kumagaya)
  end
end #当てはまるバスが２つ以下の場合はeach文が終了

def add_zero(num) #1桁の場合は前に0を追加する
  if num < 10
    return "0" + num.to_s
  else
    return num.to_s
  end
end

can_take_kumagaya = []
can_take_kumagaya_minute.each do |kumagaya|#00:00からの時間（分）を元の時刻に戻す
  kumagaya_minute = kumagaya % 60
  kumagaya_hour = (kumagaya - kumagaya_minute) / 60
  can_take_kumagaya.push(add_zero(kumagaya_hour) + ":" + add_zero(kumagaya_minute))
end

what_time_now = add_zero(hour_now) + ':' + add_zero(minutes_now)

if can_take_kumagaya.empty?;
  p '現在時刻は,' + what_time_now.to_s
  p '今日のダイヤはもうありません。以下が平日の大学発熊谷駅行きダイヤです'
  kumagaya_daiya.each do |kumagaya|
    p kumagaya
  end
else;
  p '現在時刻は,' + what_time_now.to_s
  if can_take_kumagaya.include?("21:15");
    p "勉強・部活・サークル活動、お疲れ様です。最終便(21:15)が近づいています。ご注意ください。"
  end
  p can_take_kumagaya
end
