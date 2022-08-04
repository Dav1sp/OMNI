@extends('layouts.site')

@section('content')
<header class=fundo>
    <div class=admin>
        <div class = admin-navegacao>
            <form class=admin-navegacao-option-form >
                @csrf
                <div class= admin-navegacao-option>
                    <label for= Users> Users</label>
                    <input id= Users type="checkbox" name=user class=admin-navegacao-option-button>
                </div>
            </form>
            <div class= admin-navegacao-option>
                <label for= Posts> Posts</label>
                <input id= Posts type="checkbox" class=admin-navegacao-option-button>
            </div>
            <div class= admin-navegacao-option>
                <label for= Comments> Comments</label>
                <input id= Comments type="checkbox" class=admin-navegacao-option-button>
            </div>
            <div class= admin-navegacao-option>
                <label for= Contact> Contact</label>
                <input id= Contact type="checkbox" class=admin-navegacao-option-button>
            </div>
            <div class= admin-navegacao-option>
                <label for= Help> Help</label>
                <input id= Help type="checkbox" class=admin-navegacao-option-button>
            </div>
        </div>
        <div class = admin-conteudo id = admin-conteudo>
        </div>
    </div>
</header>
@endsection