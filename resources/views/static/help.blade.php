@extends('layouts.site')

@section('content')
<header class=fundo>
    <div class="msg-positive" id="msg-positive">
    </div>
    <div class="msg-negative" id="msg-negative">
    </div>
    <form class=help name=help>
    @csrf
        <div class=help-card>
            <div class = help-card-descricao>
                <h1 class = help-card-descricao-titulo>Help Us</h1>
                <p class = help-card-descricao-paragrafo>Ajudenos a melhorar o nosso site com novas funcionalidades e ideias</p>
                <p class = help-card-descricao-paragrafo>A nossa equipa ficara grata pelas suas ideias</p>
            </div>
            <div class= help-card-button>
                <div class=help-card-button-texto>
                    <label for= Texto>Texto</label>
                    <textarea id = Text name=Text type=text placeholder="Diga-nos a sua ideia"></textarea>
                </div>
            </div>
            <div class=help-card-send>
                <button class=help-card-send-button type=submit>Enviar</button>
            </div>
        </div>
</header>
@endsection