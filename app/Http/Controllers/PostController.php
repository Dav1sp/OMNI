<?php
namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Comment;
use App\Models\Country;
use App\Models\Post;
use App\Models\User;
use App\Models\Vote_Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PostController extends Controller
{
    public function show($id)
    {
        $post = Post::find($id);
        $author = User::find($post->id_users);
        //$this->authorize('show', $post);
        $comments= Comment::where('id_post', $id)->orderBy('date')->get();
        return view('pages.post', ['post' => $post, 'author'=> $author, 'comments'=> $comments]);
    }

    public function showPostCreationForm()
    {
        $categories = Category::all();
        return view('pages.create', ['categories'=>$categories]);
    }

    public function create(Request $request)
    {
        $post = new Post();
        $user = session('usuario') ;
            //Auth::user();


        //$post->id_users = 1;
        $post->id_users = $user->id_users;
        $post->id_category = $request -> input( 'id_category');
        $post->url = "/posts/";
        $post->title = $request-> input('title');
        $post->new = $request-> input('content');
        $post->save();
        $post->url = "/posts/$post->id_post";
        // Image upload
        if($request->hasFile('image') && $request->file('image')->isValid()){
            $requestImage = $request->image;
            $extension = $requestImage-> extension();
            $imageName = md5($requestImage->getClientOriginalName() . strtotime("now")) . "." . $extension ;
            $requestImage->move(public_path('img/posts'), $imageName);
            $post-> media = $imageName;
        }

        if ($request->hasFile('media')) {
            $image = $request->file('media');
            $name = 'amanda' . '.' . $image->getClientOriginalExtension();
            $destinationPath = public_path('img/posts');
            $image->move($destinationPath, $name);
        }

        $post->save();

        return redirect($post->url);
    }

    public function addComment(Request $request)
    {
        $comment = new Comment();
        $user = session('usuario') ;
        $comment -> id_users = $user->id_users;
        $comment -> id_post = $request-> input('id_post');
        $comment -> comment = $request-> input('comment');
        $comment -> save();

        return redirect( "/posts/$comment->id_post");
    }
    public function deleteComment($id)
    {
        $comment = Comment::where('id_comment',$id)->first();
        $post = $comment-> id_post;
        $comment->delete();
        return redirect( "/posts/$post")->with('success', 'Comment deleted successfully!');
    }

    public function deletePost($id)
    {
        Post::where('id_post',$id)->first()->delete();
        return redirect( "/")->with('success', 'Post deleted successfully!');
    }

    public function likePost(Request $request){
      $post_id = $request['postId'];
      $is_like = $request['isLike']==true;

      $post = Post::find($post_id);
      $user = session('usuario') ;
      $send_up = $post->total_up;
      $send_down = $post->total_down;

      $vote = Vote_Post::where('id_users', $user->id_users)->where('id_post',$post_id)->first();
      if($vote){
        if($vote->value === $is_like){
          $send_up=$send_up-1;
          $vote->delete();
        }
        else{
          $send_up=$send_up+1;
          $send_down=$send_down-1;
          $vote->delete();

          $like = new Vote_Post();
          $like->value = $is_like;
          $like->id_users = $user->id_users;
          $like->id_post = $post_id;
          $like->save();
        }
      }
      else{
        $like = new Vote_Post();
        $like->value = $is_like;
        $like->id_users = $user->id_users;
        $like->id_post = $post_id;
        $like->save();
        $send_up=$send_up+1;
      }

      $likeSend['success']=true;
      $likeSend['up']=$send_up;
      $likeSend['down']=$send_down;
      echo json_encode($likeSend);

      return;
    }

    public function dislikePost(Request $request){
      $post_id = $request['postId'];
      $is_like = $request['isLike']==false;

      $post = Post::find($post_id);
      $user = session('usuario') ;
      $send_up = $post->total_up;
      $send_down = $post->total_down;

      $vote = Vote_Post::where('id_users', $user->id_users)->where('id_post',$post_id)->first();
      if($vote){
        if($vote->value === $is_like){
          $send_down=$send_down-1;
          $vote->delete();
        }
        else{
          $send_up=$send_up-1;
          $send_down=$send_down+1;
          $vote->delete();

          $like = new Vote_Post();
          $like->value = $is_like;
          $like->id_users = $user->id_users;
          $like->id_post = $post_id;
          $like->save();
        }
      }
      else{
        $like = new Vote_Post();
        $like->value = $is_like;
        $like->id_users = $user->id_users;
        $like->id_post = $post_id;
        $like->save();
        $send_down=$send_down+1;
      }

      $likeSend['success']=true;
      $likeSend['up']=$send_up;
      $likeSend['down']=$send_down;
      echo json_encode($likeSend);

      return;
    }


    public function edit($id){
        $categories = Category::all();
        $post = Post::find($id);
        return view('pages.editPost',['post' => $post], ['categories'=>$categories] );
    }

    public function update(Request $request){
        $post = Post::findOrFail($request ->id);
        if($request->hasFile('media') && $request->file('media')->isValid()){
            $requestImage = $request-> media;
            $extension = $requestImage-> extension();
            $imageName = md5($requestImage->getClientOriginalName() . strtotime("now")) . "." . $extension ;
            $requestImage->move(public_path('img/posts'), $imageName);
        }
        $post->update($request->all());
        $post-> media = $imageName;
        $post->save();
        return redirect($post->url)->with('success', 'Post edited successfully!');

    }
}
