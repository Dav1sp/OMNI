@extends('layouts.site')

@section('content')
<header class=fundo>
    @if($errors->any())
        <div class="msg-negative">
            @foreach ($errors->all() as $error)
                <p class="msg-negative-error">{{$error}}</p>
            @endforeach
        </div>
    @endif
    @if(isset($erro))
        <div class="msg-negative">
                <p class="msg-negative-error">{{$erro}}</p>
        </div>
    @endif
  <form action='/Login/ForgetPassword/Send' name=ForgetPassword class= register method="POST">
  @csrf
  @method('PUT')
    <div class=register-card>
      <div class = register-card-descricao>
        <h1 class = register-card-descricao-titulo>Forget Password</h1>
        <p class = register-card-descricao-paragrafo>Recupere a sua password</p>
      </div>
      <div class= register-card-buttons>
        <div class= register-card-buttons-primeiro>
            <div div class=register-card-buttons-email>
              <label for= Email>Email</label>
              <input id = Email name = Email type=email placeholder="Ex: Omni@gmail.com">
            </div>
            <div class=register-card-buttons-password>
              <label for=Password>Password</label>
              <input id=Password type=password name=Password placeholder="Safe Password">
            </div>
        </div>

        <div class=register-card-buttons-primeiro>
            <div class=register-card-send>
              <button href="/Login/ForgetPassword/Send" class=login-card-send-button>Enviar</button>
            </div>
            <div class=register-card-buttons-password>
              <label for=Password_confirmation>Password Confirm</label>
              <input id=Password_confirmation type=password name=Password_confirmation placeholder="Password Confirm">
            </div>
        </div>
      </div>
    </div>
</header>
@endsection
