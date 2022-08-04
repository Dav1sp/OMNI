<?php

namespace App\Http\Controllers\Auth;

use App\Models\Country;
use App\Models\User;
use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\LoginRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class authController extends Controller{
  /**
   * Handle the incoming request.
   *
   * @param  \Illuminate\Http\Request  $request
   * @return \Illuminate\Http\Response
   */

  public function register(){
    if($this->checkSession()){
      return redirect('/');
    }
    $countries = Country::all();

    return view('auth.register', compact('countries'));
  }
  public function registerSend(StoreUserRequest $request){
    if($this->checkSession()){
      return redirect('/');
    }
    $request->validated();

    $user = new User();

    $user->name = $request->Name;
    $user->email = $request->Email;
    $user->country = $request->Country;
    $user->gender = $request->Gender;
    $user->birthday = $request->Birthday;
    $user->password = Hash::make($request->Password);
    $user->save();

    return redirect('/')->with('success', 'Register Success!');
  }
  public function login(){
    if($this->checkSession()){
      return redirect('/');
    }
    $erro = session('erro');
    $data = [];
    if(!empty($erro)){
      $data = [
        'erro'=>$erro
      ];
    }

    return view('auth.login',$data);
  }
  public function loginSend(LoginRequest $request){
    if($this->checkSession()){
      return redirect('/');
    }
    $request->validated();

    $email = trim($request->Email);
    $password = trim($request->Password);

    $user = User::where('email',$email)->first();

    if(!$user){

      session()->flash('erro','User não encontrado.');
      return redirect('/Login');
    }
    if(!Hash::check($password, $user->password)){
      session()->flash('erro','Password Incorreta.');
      return redirect('/Login');
    }
    session()->put('usuario',$user);
    return redirect('/');
    //return redirect('/');
  }

  public function logout(){
    if($this->checkSession()){
      session()->forget('usuario');
    }
    return redirect('/')->with('success', 'Log out!!');
  }

  public function fogetPassword(){
    if($this->checkSession()){
      return redirect('/');
    }
    return view('auth.forgetPassword');
  }
  public function fogetPasswordSend(ForgetPasswordRequest $request){
    if($this->checkSession()){
      return redirect('/');
    }
    $request->validated();
    $email = trim($request->Email);
    $password = trim($request->Password);
    $user = User::where('email',$email)->first();
    if(!$user){
      session()->flash('erro','User não encontrado.');
      return redirect('/Login/ForgetPassword');
    }
    User::where('email',$email)->first()->update(['password' => Hash::make($password)]);
    return redirect('/Login');
  }

  private function checkSession(){
    return session()->has('usuario');
  }


}
