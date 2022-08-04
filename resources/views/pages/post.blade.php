@extends('layouts.site')

@section('content')
    @if (\Session::has('success'))
        <div class="alert alert-success">

                <p>{!! \Session::get('success') !!}</p>

        </div>
    @endif
    @include('partials.post', ['post' => $post, 'author'=> $author, 'comments'=> $comments])
@endsection
