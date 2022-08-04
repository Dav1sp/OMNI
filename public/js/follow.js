$('.follow').on('click',function(event){
  event.preventDefault();
  var follower_id = document.getElementById('follower_id').value;
  console.log("follower_id " + follower_id)
  var following_id = document.getElementById('following_id').value;
  console.log("following_id " + following_id)
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token, follower_id: follower_id, following_id: following_id}

  $.ajax({
    type:'post',
    url: "/follow",
    dataType: 'json',
    data: dataEnv,
    success: function(response){
      if(response.success==true){
        document.getElementById("follower").innerHTML=response.int;
      }
    }
  })
});
