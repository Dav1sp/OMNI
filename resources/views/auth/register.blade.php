@extends('layouts.site')

@section('content')
<header class=fundo>
@if(session('msg'))
      <p class="msg-positive">{{ session('msg') }}</p>
  @endif

    @if (\Session::has('success'))
        <div class="msg-positive">

                <li class="msg-negative-error">{!! \Session::get('success') !!}</li>
        </div>
    @endif
  @if($errors->any())
      <div class="msg-negative">
          @foreach ($errors->all() as $error)
              <p class="msg-negative-error">{{$error}}</p>
          @endforeach
      </div>
  @endif
  <form action='/Register/Send' name=register class= register method="POST">
  @csrf
    <div class=register-card>
      <div class = register-card-descricao>
        <h1 class = register-card-descricao-titulo>Register</h1>
        <p class = register-card-descricao-paragrafo>Junte-se a nos e escrava todas as noticias que quiser!</p>
      </div>
      <div class= register-card-buttons>

        <div class= register-card-buttons-primeiro>
          <div class="register-card-buttons-name">
              <label for= Name>Name</label>
              <input id = Name name = Name type=text placeholder="Primeiro e ultimo nome">
          </div>
          <div class=register-card-buttons-email>
              <label for= Email>Email</label>
              <input id = Email name = Email type=email placeholder="Ex: Omni@gmail.com">
          </div>
        </div>

        <div class=register-card-buttons-primeiro>
            <div class=register-card-buttons-country>
              <label for= Country> Country</label>
              <select id = Country name=Country>
                @foreach( $countries as $value)
                  <option value="{{ $value->id_country }}">{{ $value->name }}</option>
                @endforeach
              </select>
            </div>
            <div class=register-card-buttons-genre>
                <label for=Gender> Gender</label>
                <select id= Gender name=Gender>
                    <option value="Female">Female</option>
                    <option value="Male">Male</option>
                    <option value="Others">Others</option>
                </select>
            </div>
        </div>

        <div class=register-card-buttons-primeiro>
            <div class=register-card-buttons-password>
              <label for=Password>Password</label>
              <input id=Password type=password name=Password placeholder="Safe Password">
            </div>
            <div class=register-card-buttons-birthday>
              <label for=Birthday>Birthday</label>
              <input type=date id=Birthday name=Birthday>
            </div>
        </div>

        <div class=register-card-buttons-primeiro>
            <div class=register-card-buttons-password>
              <label for=Password_confirmation>Password Confirm</label>
              <input id=Password_confirmation type=password name=Password_confirmation placeholder="Password Confirm">
            </div>
            <div class=register-card-send>
              <button href="/Register/Send" class=login-card-send-button>Enviar</button>
            </div>
        </div>

      </div>
    </div>
</header>
@endsection
