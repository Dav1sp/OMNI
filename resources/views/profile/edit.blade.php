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
        <form action='/profile/{{$user-> id_users}}/edit/send' name=profile method="POST" enctype="multipart/form-data">
            @csrf
            @method('POST')
            <div class="perfil">
                <div>
                    <h1>Edit Profile</h1>
                </div>
                <div class=create_card-button-texto-primeiro-image>
                    <label for="image">Image</label>
                    <input id = "image" name="image" type="file" >
                </div>

                <div class="create_card-button-texto">
                    <label for=Name>Name</label>
                    <textarea id=name name=name type=text> {{$user -> name}} </textarea>
                </div>

                <div class="create_card-button-texto">
                    <label for=Email>Email</label>
                    <textarea id=email name=email type=email> {{$user -> email}} </textarea>
                </div>
                <div class=register-card-buttons-birthday>
                    <label for=Birthday>Birthday</label>
                    <input type=date id=Birthday name=Birthday value= {{$user -> birthday}}>
                </div>

                <div class=register-card-buttons-country>
                    <label for= Country> Country</label>
                    <select id = Country name=Country>

                        @foreach( $countries as $value)
                            @if( ($value->id_country) ==  ($user->country) )
                                <option value="{{ $value->id_country }}" selected>{{ $value->name }}</option>
                            @else
                                 <option value="{{ $value->id_country }}">{{ $value->name }}</option>
                            @endif
                        @endforeach
                    </select>
                </div>
                <div class="create_card-button-texto">
                    <label for=Email>Biography</label>
                    <textarea id=descricao name=descricao type=text> {{$profile -> descricao}} </textarea>
                </div>


                <button type="submit" class=create_card-send-button>Save</button>
            </div>
        </form>
    </header>


    </header>
@endsection
