<?php

use Illuminate\Support\Facades\Route;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


//Static Page
Route:: namespace('Static')->group( function () {
    Route::get('/AboutUs', 'StaticController@about');
    Route::get('/FAQ', 'StaticController@faq');
    Route::get('/Contact', 'StaticController@contact');
    Route::post('/Contact/Send', 'StaticController@contactSend');
    Route::get('/Help', 'StaticController@help');
    Route::post('/Help/Send', 'StaticController@helpSend');
});

//Admin Page
Route:: namespace('Admin')->group( function () {
    Route::get('/Admin', 'AdminController@admin');
    Route::get('/Admin/User', 'AdminController@adminUser');
    Route::get('/Admin/Post', 'AdminController@adminPost');
    Route::get('/Admin/Comment', 'AdminController@adminComment');
    Route::get('/Admin/Contact', 'AdminController@adminContact');
    Route::get('/Admin/Help', 'AdminController@adminHelp');
    Route::delete('/Admin/Help/Delete/{id}', 'AdminController@adminHelpDelete');
    Route::delete('/Admin/User/Delete/{id}', 'AdminController@adminUserDelete');
    Route::delete('/Admin/Post/Delete/{id}', 'AdminController@adminPostDelete');
    Route::delete('/Admin/Comment/Delete/{id}', 'AdminController@adminCommentDelete');
    Route::delete('/Admin/Contact/Delete/{id}', 'AdminController@adminContactDelete');
});

//Authentication Page
Route:: namespace('Auth')->group( function () {
    Route::get('/Login','AuthController@login');
    Route::post('/Login/Send','AuthController@loginSend');
    Route::get('/Register','AuthController@register');
    Route::post('/Register/Send', 'AuthController@registerSend');
    Route::get('/Logout','AuthController@logout');
    Route::get('/Login/ForgetPassword','AuthController@fogetPassword');
    Route::put('/Login/ForgetPassword/Send','AuthController@fogetPasswordSend');
});




//home
Route::get('/', 'HomeController@show');
//home
Route::get('/Create', 'PostController@showPostCreationForm');
Route::post('/Create/Send', 'PostController@create');

//Post - news
Route::get('/posts/{id}', 'PostController@show');
Route::post('/AddComment', 'PostController@addComment');
Route::delete('/comment/delete/{id}', 'PostController@deleteComment');
Route::delete('/post/delete/{id}', 'PostController@deletePost');
Route::post('/Like', 'PostController@likePost');
Route::post('/Dislike', 'PostController@dislikePost');
Route::get('/post/edit/{id}', 'PostController@edit');
Route::put('/post/edit/send/{id}', 'PostController@update');


// Login -> Profile
Route::get('/profile/{id}', 'ProfileController@show');

// Edit profile
Route::get('/profile/{id}/edit', 'ProfileController@edit');
Route::post('/profile/{id}/edit/send', 'ProfileController@update');
Route::post('/follow', 'ProfileController@follow');
Route::delete('/profile/delete/{id}', 'ProfileController@deleteAccount');
