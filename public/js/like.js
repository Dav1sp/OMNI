$('.like').on('click',function(event) {
  event.preventDefault();
  var postId = document.getElementById('post-id-js').value;
  var isLike = true;
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,isLike: isLike, postId: postId}
  //const dados = JSON.stringify({isLike: isLike, postId: postId, _token: token});

  $.ajax({
    type: "post",
    url: "/Like",
    dataType: 'json',
    data: dataEnv,
    success: function(response){
      if(response.success===true){
        var up = response.up;
        var down = response.down;
        document.getElementById('total_up').innerHTML=up;
        document.getElementById('total_down').innerHTML=down;
      }
    }
  });
});

$('.dislike').on('click',function(event) {
  event.preventDefault();
  var postId = document.getElementById('post-id-js').value;
  var isLike = false;
  var _token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  var dataEnv ={_token: _token,isLike: isLike, postId: postId}
  //const dados = JSON.stringify({isLike: isLike, postId: postId, _token: token});

  $.ajax({
    type: "post",
    url: "/Dislike",
    dataType: 'json',
    data: dataEnv,
    success: function(response){
      if(response.success===true){
        var up = response.up;
        var down = response.down;
        document.getElementById('total_up').innerHTML=up;
        document.getElementById('total_down').innerHTML=down;
      }
    }
  });
});
