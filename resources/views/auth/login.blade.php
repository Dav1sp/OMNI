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
        <form action='/Login/Send' name=login class=login method="POST">
            @csrf
            <div class=login-card>
                <div class=login-card-descricao>
                    <h1 class=login-card-descricao-titulo>Login</h1>
                    <p class=login-card-descricao-paragrafo>Enjoy the experience!</p>
                </div>
                <div class=login-card-credentials>
                    <div class="login-card-buttons-email">
                        <label for=Email>Email</label>
                        <input id=Email name=Email type=email placeholder="Ex: Omni@gmail.com">
                    </div>
                    <div class=login-card-buttons-password>
                        <label for=Password>Password</label>
                        <input id=Password name=Password type=password placeholder="Password">
                    </div>
                </div>
                <div class=login-card-send>
                    <button href="/Login/Send" class=register-card-send-button>Enviar</button>
                </div>
                <div class=register-card-descricao>
                </div>
                <div class=login-card-register>
                    <a href="../Register">Don't have account? Register</a>
                    <a class=last href="../Login/ForgetPassword">Forgot Password</a>
                </div>
            </div>
    </header>
@endsection
