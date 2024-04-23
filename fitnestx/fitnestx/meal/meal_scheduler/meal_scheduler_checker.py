from apscheduler.schedulers.background import BackgroundScheduler
from fitnestx.meal.views import UpdateFoodScheduleNotificationView
from apscheduler.executors.pool import ThreadPoolExecutor, ProcessPoolExecutor
from pytz import utc

global scheduler

def start():
  executors = {
    'default': ThreadPoolExecutor(20),
    'processpool': ProcessPoolExecutor(5)
  }
  job_defaults = {
    'coalesce': False,
    'max_instances': 3
  }
  scheduler = BackgroundScheduler(executors=executors, job_defaults=job_defaults, timezone=utc)
  scheduler = BackgroundScheduler()
  scheduler.remove_all_jobs
  food = UpdateFoodScheduleNotificationView()
  scheduler.add_job(food.update_notification, "interval", minutes=1, id="food_001", replace_existing=True)
  scheduler.start()