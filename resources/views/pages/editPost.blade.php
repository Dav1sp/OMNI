@extends('layouts.site')

@section('content')
    @if (\Session::has('success'))
        <div class="msg-positive">

            <li >{!! \Session::get('success') !!}</li>
        </div>
    @endif
    <header class=fundo>
        <form action='/post/edit/send/{{$post -> id_post}}' class=create method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class=create_card>
                <div class = create_card-descricao>
                    <h1 class = create_card-descricao-titulo>Edit your Post</h1>
                    <p class = create_card-descricao-paragrafo>Use this section to edit the content of your post</p>
                </div>
                <div class= create_card-button>
                    <div class=create_card-button-texto>
                        <div class=create_card-button-texto-primeiro>
                            <div class=create_card-button-texto-primeiro-category>
                                <label for=titulo>Category</label>
                                <select  class ="Select_categorias"  id="id_category" name="id_category">

                                    @foreach( $categories as $value)

                                    @if( ($value->id_category) ==  ($post->id_category) )
                                            <option value="{{ $value->id_category }}" selected>{{ $value->name }}</option>
                                        @else
                                            <option value="{{ $value->id_category }}">{{ $value->name }}</option>
                                        @endif

                                    @endforeach
                                </select>
                            </div>
                            <div class=create_card-button-texto-primeiro-image>
                                <label for="media">Image</label>
                                <input id = "media" name="media" type="file" >
                            </div>
                        </div>
                        <label for= Titulo>Titulo</label>
                        <textarea id ="title" name= "title" type=text placeholder="What´s the Title of your News?" required>{{$post-> title}}</textarea>
                        <label for= Texto>Texto</label>
                        <textarea id ="new" name= "new" type=text placeholder="Write the content in this area." required >{{$post-> new}}</textarea>
                    </div>
                </div>
                <div class=create_card-send>
                    <button type="submit" class=create_card-send-button >Submit</button>
                </div>
            </div>
        </form>
    </header>
@endsection




