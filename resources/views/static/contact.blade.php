@extends('layouts.site')

@section('content')
<header class=fundo>
    @if(session('msg'))
        <p class="msg-positive">{{ session('msg') }}</p>
    @endif
    @if($errors->any())
        <div class="msg-negative">
            @foreach ($errors->all() as $error)
                <p class="msg-negative-error">{{$error}}</p>
            @endforeach
        </div>
    @endif
    <form action='/Contact/Send' name=contact class=contact method="POST">
    @csrf
        <div class=contact-card>
                <div class = contact-card-descricao>
                    <h1 class = contact-card-descricao-titulo>Contact Us</h1>
                    <p class = contact-card-descricao-paragrafo>Se tiver alguma questão a colocar ou hajá algo em que possamos ajudar sinta-se livre para mandar um request</p>
                    <p class = contact-card-descricao-paragrafo>A nossa equipa entrará em contacto assim que possivel</p>
                </div>
                <div class= contact-card-buttons>
                    <div class= contact-card-buttons-primeiro>
                        <div class=contact-card-buttons-name>
                            <label for= Name>Name</label>
                            <input id = Name name = Name type=text placeholder="Primeiro e ultimo nome">
                        </div>
                        <div class=contact-card-buttons-email>
                            <label for= Email>Email</label>
                            <input id = Email name = Email type=email placeholder="Ex: Omni@gmail.com">
                        </div>
                    </div>
                    <div class= contact-card-buttons-segundo>
                        <div class=contact-card-buttons-assunto>
                            <label for= Assunto> Assunto</label>
                            <input id = Assunto name = Assunto type=text placeholder="Uma breve descrição">
                        </div>
                        <div class=contact-card-buttons-texto>
                            <label for= Pergunta>Texto</label>
                            <textarea id = Pergunta name = Pergunta type=text placeholder="Em que podemos ajudar"></textarea>
                        </div>
                    </div>
                </div>
                <div class=contact-card-send>
                    <button href="/Contact/Send" class=contact-card-send-button>Enviar</button>
                </div>
        </div>
</header>
@endsection