<div class="comment-post-id" data-id="{{$comment->id_comment}}">
    <div class=coment-post-autor>
        <img src="{{$comment->user()->get()->first()->photo}}" class=coment-post-autor-foto>
        <p class=coment-post-autor-nome>{{$comment->user()->get()->first()->name}}</p>
    </div>
    <div class="comment-content">
        <p class=comment-content-paragrafo>{{$comment->comment}}</p>
    </div>



    @if(session()->has('usuario'))

        @if (session('usuario')->id_users == $comment->id_users)

            <form  action="/comment/delete/{{ $comment-> id_comment}}" method="POST" >
                @csrf
                @method('DELETE')
                <input type="submit" value="delete">
            </form>
        @endif

    @endif

</div>

