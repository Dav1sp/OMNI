<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Post;
use App\Models\Comment;
use App\Models\Contact;
use App\Models\Help;


class adminController extends Controller
{
    /**
     * Handle the incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    public function admin(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
          }
        return view( view: 'admin.admin');
    }
    public function adminUser(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminUser['success']=true;
        $adminUser['data']= User::all();
        echo json_encode($adminUser);
        return;
    }
    public function adminPost(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminPost['success']=true;
        $adminPost['data']= Post::all();
        echo json_encode($adminPost);
        return;
    }
    public function adminComment(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminComment['success']=true;
        $adminComment['data']= Comment::all();
        echo json_encode($adminComment);
        return;
    }
    public function adminContact(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminContact['success']=true;
        $adminContact['data']= Contact::all();
        echo json_encode($adminContact);
        return;
    }
    public function adminHelp(){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminHelp['success']=true;
        $adminHelp['data']= Help::all();
        echo json_encode($adminHelp);
        return;
    }
    public function adminHelpDelete(Request $request){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminHelp['success']=true;
        Help::where('id_help',$request->id)->first()->delete();
        echo json_encode($adminHelp);
        return;
    }
    public function adminUserDelete(Request $request){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminUser['success']=true;
        User::where('id_users',$request->id)->first()->delete();
        echo json_encode($adminUser);
        return;
    }
    public function adminPostDelete(Request $request){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminPost['success']=true;
        Post::where('id_post',$request->id)->first()->delete();
        echo json_encode($adminPost);
        return;
    }
    public function adminCommentDelete(Request $request){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminComment['success']=true;
        Comment::where('id_comment',$request->id)->first()->delete();
        echo json_encode($adminComment);
        return;
    }
    public function adminContactDelete(Request $request){
        if(!session()->has('usuario') || session('usuario')->admin==false){
            return redirect('/');
        }
        $adminContact['success']=true;
        Contact::where('id_contact',$request->id)->first()->delete();
        echo json_encode($adminContact);
        return;
    }
}
