# @summary mimic minute setting in cron as defined in man 5 crontab
type Letsencrypt::Cron::Minute = Variant[
  Integer[0,59],
  String[1],
  Array[
    Variant[
      Integer[0,59],
      String[1],
    ]
  ]
]
