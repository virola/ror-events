newtoken = "Token token=ji14ZeekYZCtJ0tShU88rgQuRsym/XEOnO+01SjWr94DXYzSlIoKzuBQUYmvnxrcHNGgNuqX+ey/1jKkgx0jrg==, username=222";

$.ajax({
  url: '/api/v1/members/2',
  method: 'PUT',
  dataType: 'json',
  data: 'member[nickname]=hello2&member[username]=222',
  beforeSend: function(request) {
    request.setRequestHeader("Authorization", newtoken);
  }
});

// member
axios.put('/api/v1/members/2','member[nickname]=hello2333&member[username]=222', {
  headers: {
    'Authorization': newtoken,
    // must have!
    'X-Requested-With': 'XMLHttpRequest'
  }
})

// update event
newtoken = "Token token=ji14ZeekYZCtJ0tShU88rgQuRsym/XEOnO+01SjWr94DXYzSlIoKzuBQUYmvnxrcHNGgNuqX+ey/1jKkgx0jrg==, username=222";
axios.put('/api/v1/events/4', 'event[name]=hello5-11&event[description]=22222', {
  headers: {
    'Authorization': newtoken,
    // must have!
    'X-Requested-With': 'XMLHttpRequest'
  }
})

// session
axios.post('/api/v1/sessions', "member[username]=222&member[password]=123123", {
  headers: {
    'X-Requested-With': 'XMLHttpRequest'
  }
})

axios.post('/api/v1/session/login', {
  "open_id":"default_200",
  "session_key":"R5Ui3GZhVOIG7W0lhPVZ/A==",
  "nickname":"Virola"
}, {
  headers: {
    'X-Requested-With': 'XMLHttpRequest'
  }
})
