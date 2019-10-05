# @summary mimic hour setting in cron as defined in man 5 crontab
type Letsencrypt::Cron::Hour = Variant[
  Integer[0,23],
  String[1],
  Array[
    Variant[
      Integer[0,23],
      String[1],
    ]
  ]
]
