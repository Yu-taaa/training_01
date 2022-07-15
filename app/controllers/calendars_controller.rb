class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    #puts @todays_date => 2022-07-16（本日の日付）
    # 例)今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

     
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        #インスタンス.カラム名で値を取得できる
        #plan.planは、左：インスタンスが代入された|plan|、右：planカラムの値を取得
        #@todays_date + 1 の場合、日付が1日分加算される
        #例）本日の日付が、2022-07-16の場合
        #   @todays_date + 1  => 2022-07-17
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      
      # Dayクラスのwdayメソッドの返り値は、0〜6になる
      wday_num = Date.today.wday 
      if wday_num + x >= 7
        wday_num = wday_num - 7
      end 
      
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, wday: wdays[wday_num + x], plans: today_plans}

      @week_days.push(days)
    end
    # monthメソッドは、「@todays_date = Date.today」によって、今日の月と日付を認識していて、
    # その月の最終日を超えたら、次の月に移行するように設定されてる
    # 例）今日が7月15日なら
    # puts (@todays_date + 5).month   => 7
    # puts (@todays_date + 15).month  => 7
    # puts (@todays_date + 20).month  => 8
    # となる
  end
end
