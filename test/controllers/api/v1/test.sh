curl -i -X GET -d "date=2018-05-16" \
  --header "Authorization: Token token=3fT2YjL/Mh6n3QqTTvG1Ua/5A2dnke/ogvrjnDvNgeb/pPd7ldoyFMcY3CNP2esgPQ+9jyNMidpxqxQ4kddn7A==, \
  username=wx_Virola" \
  http://localhost:3000/api/v1/index/mine


curl -i -X POST -d "session[code]=071B9Zzd0EaL0u1Rjlzd0bBMzd0B9Zze&session[nickname]=Virola" http://localhost:3000/api/v1/session/login