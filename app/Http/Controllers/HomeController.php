<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;

class HomeController extends Controller
{
    /*
    public function __construct(){
        $this->middleware('auth');
    }
*/
    public function show(){

        $search = request('search');
        if( $search){
            //$posts = Post::where(['title','like','%'.$search.'%'])->get();
            //$author=User::where('email',$email)->first();
            $posts = Post::query()
                ->where('title', 'LIKE', "%{$search}%")
               // ->orWhere('id_users', 'LIKE', "%{$authors_id[0]}%")
                ->get();
            //
            //$posts = Post::where(['id_users','like', $authors_id])->get;
        } else{
            $posts = Post::all()->sortByDesc('date');
        }

        return view('home', ['posts' => $posts, 'search' => $search]);
    }
}
