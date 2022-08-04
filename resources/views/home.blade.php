@extends('layouts.site')

@section('content')
    <header class=fundo>
    <div class=post-card-seearch-result>
        @if($search)
            <h2> Results of the search for: {{$search}}</h2>
        @endif
    </div>
        @if(session()->has('usuario'))
            <a href="/Create" class=post-create>+</a>
        @endif
        <div class=post-card>
            @if(count($posts) == 0 && $search)
            <div class=post-card-seearch-result-null>
                <h3> There is no  for Results of the search for: {{$search}} </h3>
            </div>
            @elseif(count($posts) == 0)
            <div class=post-card-seearch-result-zero>
                 <h3> There isnt any News Today :(</h3>
            </div>
            @else
                @each('partials.home', $posts, 'post')
            @endif

        </div>
    </header>
@endsection
