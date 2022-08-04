@extends('layouts.site')

@section('content')

    <header class=fundo>
        <form action='/Create/Send' class=create method="POST" enctype="multipart/form-data">
            @csrf
            <div class=create_card>
                <div class = create_card-descricao>
                    <h1 class = create_card-descricao-titulo>Create a News Post</h1>
                    <p class = create_card-descricao-paragrafo>Use this section to write the content of your post</p>
                </div>
                <div class= create_card-button>
                    <div class=create_card-button-texto>
                        <div class=create_card-button-texto-primeiro>
                            <div class=create_card-button-texto-primeiro-category>
                                <label for= Titulo>Category</label>
                                <select  class ="Select_categorias"  id="id_category" name="id_category">
                                    @foreach( $categories as $value)
                                        <option value="{{ $value->id_category }}">{{ $value->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                            <div class=create_card-button-texto-primeiro-image>
                                <label for="image">Image</label>
                                <input id = "image" name="image" type="file" >
                            </div>
                        </div>
                        <label for= Titulo>Titulo</label>
                        <textarea id ="title" name= "title" type=text placeholder="What´s the Title of your News?" required></textarea>
                        <label for= Texto>Texto</label>
                        <textarea id ="content" name= "content" type=text placeholder="Write the content in this area." required ></textarea>
                    </div>
                </div>
                <div class=create_card-send>
                    <button type="submit" class=create_card-send-button >Submit</button>
                </div>
            </div>
        </form>
    </header>
@endsection



