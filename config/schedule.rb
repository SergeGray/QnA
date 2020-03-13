every 1.day do
  runner 'DailyDigestService.call'
end

every 30.minutes do
  rake 'ts:index'
end
