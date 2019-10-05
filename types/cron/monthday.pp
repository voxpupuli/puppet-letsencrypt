# @summary mimic monthday setting in cron as defined in man 5 crontab
type Letsencrypt::Cron::Monthday = Variant[
  Integer[0,31],
  String[1],
  Array[
    Variant[
      Integer[0,31],
      String[1],
    ]
  ]
]
