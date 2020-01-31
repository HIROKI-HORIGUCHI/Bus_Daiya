# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
Ruby 2.4.1

* System dependencies
heroku.inc's server.(https://jp.heroku.com/)

* Configuration

* Database creation
no database

* Database initialization
no database


* How to run the test suite
My local server, puma.

* Services (job queues, cache servers, search engines, etc.)

・Consepts for users

At Tokyo Denki University's Hatoyama Campus, students take a look at school bus timetables on hard-to-find sites, check them 

on paper, or learn them.

(東京電機大学鳩山キャンパスでは、学生がスクールバスの時刻表を見辛いサイトで見るか、紙で確認する、または覚えるという方法をとっている。)

But is that all right??

(しかし、そんなことでいいのだろうか？？)

I think this is unacceptable in a college institution that should produce brilliant persons.

(明晰な頭脳を持つ人間を輩出するべき大学機関において、これは許されざることである、と私は思うのである。)

Furthermore, we go to "Tokyo Denki University", and we are called "Dendai-students" by the public.

(まして、我々は「東京電機大学」に通っており、世間からは「電大生」と呼称されている。)

"dendai student" must not tear his resources down by insidious actions such as relying on, or learning about, analog methods of using bus timetables.

(電大生が、バスの時刻表利用のためにアナログな手法に依存する、またはそのものを覚えるなどという愚にもつかない行動によって、頭のリソースを裂かれてはならない。)

With this in mind, I developed this application.

(そんな思いを胸に、このアプリケーションを開発した。)

The college students do not have to worry about the school bus schedule.I want you to hack campus life by forgetting that you 

are in the mountains.

(電大生にはスクールバスのダイヤに煩わしさを覚えることなく、山の中ということを忘れて「キャンパスライフ」を「ハック」してもらいたい。)

For Takasaka Station and Kitasakado Station, which have the most users, the app is opened and the school bus timetable is 

displayed with a single tap.

(最もユーザーが多い高坂駅、北坂戸駅については、アプリを開いてワンタップでスクールバスの時刻表が表示されるようにした。)

This application is most effective in outputting the timetable of Kosaka Station and Kitasakado Station at the same time.

(なお、このアプリケーションが最も効果を発揮するのは、高坂駅と北坂戸駅のダイヤを同時に出力することである。)

Please check this convenience once.

(この利便性については一度触って確かめていただきたい。)



・User
The people who belong to "Tokyo-Denki-Univarsity".

(東京電機大学所属の人間)



・How to Use this application(使用方法)

"Allez" means "Go to Univarsity" and "Retour" means "Go Back from university to the station which you wanna go".

(Allez は最寄駅から大学へ行くことを意味し、Retourは大学から帰りたい駅へ帰ることを意味している。)

For example, when you tap or click Allez or Retour, the screen transitions. A screen for making four choices appears. This 

will be described below.

(例えば、AllezまたはRetourをタップするか、クリックすると、画面が遷移し。4つの選択をする画面が表示される。以下で説明する。)

First selection is "Today is During semester or not". This selection is selected "授業期間中" by default.

(1つ目は、授業期間か休業期間かを選択する選択肢である。デフォルトで授業期間中が選択されている。)

The second is to select a weekday or a holiday. If it is a weekday, the weekday is selected, and if it is Saturday, Saturday 

is selected by default. Note that the bus itself is not running on Sundays and holidays.

(2つ目は、平日か休日かを選択するものである、平日であれば平日が選択され、土曜であれば土曜がデフォルトで選択されている。日曜、祝日はバスそのものが走っていないので注意。)

The third is to select the name of the station. There are two patterns: Kosaka Station, Kitasakado Station, and Kumagaya 

Station.

(3つ目は、駅の名前を選択するものである。高坂駅・北坂戸駅、熊谷駅の2パターンが存在する。)

Fourth, the current time is selected. By default, the current time is entered, but it is possible to select it.

(4つ目は、現在時刻を選択するものである。デフォルトでは現在時刻が入力されているが、選択することも可能である。)




* Deployment instructions
I use heroku server.

* ...
