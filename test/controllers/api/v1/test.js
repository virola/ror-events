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