<a href="/posts/{{$post->id_post}}" class=post-card-ref >
    <div class = post-card-block>
        <div class = post-card-block-info>
            <img src="img/icons/user.png" class="post-profile-img">
            <div class = post-card-block-info-texto>
                <h3> {{$post->title}}</h3>
                <h4>{{$post->date}}</h4>
            </div>
        </div>
        <div class=post-card-block-foto>
            @if($post->media!=null)
                <img src="img/posts/{{$post->media}}" class="post-foto">
            @else
                <img src="img/icons/fundoPost.jpg" class="post-foto">
            @endif
        </div>
    </div>
</a>
