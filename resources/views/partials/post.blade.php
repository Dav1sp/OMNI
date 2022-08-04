<header class=fundo>
    @if(session()->has('usuario'))
    <div class=post-user>
        <div class= post-user-user>
            <div class=post-user-img>
                <a href="/profile/{{$author->id_users}}">

                    @if( $author->photo === '../img/icons/user.png')

                        <img class="authorPost" src="{{$author->photo}}">
                    @else
                        <img src= "img/profiles/{{$author->photo}}" style="border-radius: 50%" >
                    @endif

                </a>
            </div>
            <div class=post-user-name>
                <h2 class="post">{{$author->name}}</h2>
                <h5 class="post"> {{$post -> date}} </h5>
            </div>
        </div>
        <div class=post-user-vote>
            <input type="hidden" id="post-id-js" value = "{{$post->id_post}}">
            <div class=post-user-vote-like>
                <img class="like" src="https://img.icons8.com/ios/50/000000/circled-chevron-up.png"/>
                <h5 class="post" id="total_up"> {{$post -> total_up}}</h5>
            </div>
            <div class=post-user-vote-dislike>
                <img class="dislike" src="https://img.icons8.com/ios/50/000000/circled-chevron-down.png"/>
                <h5 class="post" id="total_down"> {{$post -> total_down}}</h5>
            </div>
        </div>
    </div>
    @endif
    @if(session()->has('usuario'))

        @if (session('usuario')->id_users == $author->id_users)
        <div class = edit-delete>
            <a href="/post/edit/{{$post -> id_post}}" class=edit-post>Editar</a>

            <form action="/delete/{{ $post-> id_post}}" method="POST" >
                @csrf
                @method('DELETE')
                <input type="submit" class=edit-post value="delete">
            </form>
        </div>
        @endif

        @endif
<div class=post-noticia>
    @if($post->media !=null)
            <img class=post-noticia-foto src="img/posts/{{$post -> media}}" alt="Media Img">
    @endif
    <div class=post-noticia-texto>
        <h1 class=post-noticia-titulo>{{ $post->title }}</h1>
        <p class=post-noticia-paragrafo>
        {{ $post->new}}
        </p>
    </div>
</div>
        @if(session()->has('usuario'))
@forelse( $comments as $comment)
<div class="comment-post">
    @include('partials.comment', [$comment, 'comment'])
</div>
@empty
<div class=Comment-text-noComments>
    <p class=Comment-text-noComments-paragrafo> There is no comments in this Post</p>
</div>
@endforelse
<div class=comment-add>
    <form class="comment" method="POST" action="/AddComment">
        @csrf
        <input id = "id_post" name="id_post" type="hidden" value="{{ $post-> id_post}}">
        <textarea id="comment" rows="2" cols="40" name="comment"
        placeholder="write a comment..."></textarea>
        <input type="submit" class = comment-add-submit value="Comment"/>
    </form>
</div>
        @endif

</header>
