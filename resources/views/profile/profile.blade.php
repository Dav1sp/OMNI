@extends('layouts.site')
@section('content')

    @if (\Session::has('success'))
        <div class="alert alert-success">
            <ul>
                <li>{!! \Session::get('success') !!}</li>
            </ul>
        </div>
    @endif
<header class="fundo">
  <div class="perfil">
    <div>
        @if( $user->photo === '../img/icons/user.png')

            <img src= {{$user->photo}}>
        @else
            <img src= "img/profiles/{{$user->photo}}" style="border-radius: 50%" >
        @endif


    </div>
    <div>
      <h1>{{$user ->name}}</h1>
    </div>

    @if(session()->has('usuario'))
    @if (session('usuario')->id_users != $user->id_users)
    <input type="hidden" id="follower_id" value = "{{session('usuario')->id_users}}">
    <input type="hidden" id="following_id" value = "{{$user->id_users}}">
    <input type="button" class="follow" value="follow">
    @endif
    @endif

    <div  class="info">
      <ul>
          <li><b> Followers: </b> <h10 id="follower">{{ $profile -> follower_int }} </h10> </li>
          <li><b> Following: </b> {{ $profile -> following_int }}</li>
          <li><b> Up Votes: </b> {{ $profile -> total_up }}</li>
          <li><b> Down Votes: </b> {{ $profile -> total_down }}</li>
      </ul>
    </div>

    <div  class="info">
      <ul>
          <li><b> Birthday: </b> {{$user->birthday}} </li>
          <li><b> Country: </b> {{$country->name}}</li>
          <li><b> Gender: </b> {{$user->gender}}</li>
      </ul>
    </div>

    <div>
      <h3><b> Biography: </h3>
      <div class="info">
          <p>{{ $profile -> descricao }}</p>
      </div>

    </div>

    <div class="row pt-5">
        @foreach($post as $p)

        <a href="{{$p -> url}}">
          <div class="info">
            <p>
              <img src="img/posts/{{$p -> media}}">
              {{$p -> title}}
             {{$p -> new}} </p>
          </div>
        </a>


        @endforeach
    </div>


    @if(session()->has('usuario'))
    @if (session('usuario')->id_users == $user->id_users)
    <div>
      <a href="/profile/{{$user-> id_users}}/edit/"> Editar Perfil </a>
    </div>
          <!--
    <form  action="/profile/delete/{{$user->id_users}}" method="POST" >
        @csrf
        @method('DELETE')
        <input type="submit" value="delete">
    </form>
    !-->
    @endif

    @endif
  </div>
</header>

@endsection
