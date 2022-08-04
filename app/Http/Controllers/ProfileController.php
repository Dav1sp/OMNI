<?php
namespace App\Http\Controllers;

use App\Models\User_Profile;
use App\Models\Country;
use App\Models\Post;
use App\Models\User;
use App\Models\Follow;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfileController extends Controller{
  public function show($id)
  {
      $user = User::find($id);
      $profile = User_Profile::where('id_users', $user->id_users)->first();
      $id_country = $user -> country;
      $country = Country::find($id_country);
      $user_id = $profile -> id_users;
      $post = Post::where('id_users', $user_id) -> orderBy('date', 'DESC')->get();
      return view('profile.profile',['user' => $user, 'profile' => $profile, 'post' => $post, 'country' => $country]);

  }

    public function edit($id)
    {

        $user = User::find($id);
        $profile =User_Profile::where('id_users', $user->id_users)->first();

        $id_country = $user -> country;

        $countries = Country::all();
        return view('profile.edit',['user' => $user, 'profile' => $profile, 'countries' => $countries]);

    }

    public function update(Request $request){

       $user = User::find($request -> id);
       $profile = User_Profile::where('id_users', $user->id_users)->first();
        // Upload Image
        if($request->hasFile('image') && $request->file('image')->isValid()){
            $requestImage = $request-> image;
            $extension = $requestImage-> extension();
            $imageName = md5($requestImage->getClientOriginalName() . strtotime("now")) . "." . $extension ;
            $requestImage->move(public_path('img/profiles'), $imageName);
            $user->photo = $imageName;
        }
        //
        $arrayUser = array('name' => $request -> name, 'email' => $request -> email,
            'birthdate' => $request->Birthday, 'country'=> $request->Country,'photo' => $imageName);
       $arrayProfile = array('descricao' => $request->descricao);

       $user->update($arrayUser);
       $profile->update($arrayProfile);
       $user->photo = $imageName;
       $user->save();
       return redirect ("/profile/$profile->id_users")->with('success', 'Profile edited successfully!');
    }

    public function follow(Request $request){
      $follower_id = $request['follower_id'];
      $following_id = $request['following_id'];

      $profile_follower = User_Profile::where('id_users',$follower_id)->first();
      $profile_followed = User_Profile::where('id_users',$following_id)->first();

      $id_follower = $profile_follower->id_users_profile;
      $id_followed = $profile_followed->id_users_profile;

      $follow_verify = Follow::where('id_users_follower', $id_follower) -> where('id_users_followed',$id_followed)->first();
      $int = $profile_followed->follower_int;


      if($follow_verify==null){
        $follow = new Follow();
        $follow -> id_users_follower = $id_follower;
        $follow -> id_users_followed = $id_followed;
        $follow -> save();
        $int=$int+1;

      }
      else{
          Follow::where('id_users_follower', $id_follower) -> where('id_users_followed',$id_followed)->delete();
          $int=$int-1;
      }

      $followSend['success']=true;
      $followSend['int']=$int;
      echo json_encode($followSend);

      return;
    }

    public function deleteAccount($id){
        /*
        if($this->checkSession()){
            session()->forget('usuario');
        }*/
      User::where('id_users',$id)->first()->delete();
      return redirect('/')->with('success', 'Profile deleted successfully!');
    }

}
