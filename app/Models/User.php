<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Contracts\Auth\CanResetPassword;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use Notifiable;

    protected $table = 'users';
    protected $primaryKey = 'id_users';
    public $timestamps = false;
    protected $guarded = [];
    protected $fillable = [
        'email',
        'name',
        'password',
        'photo',
        'admin',
        'country',
        'gender',
        'birthday',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function country(){
        return $this->hasOne('App\Models\Country');
    }

    public function isAdmin() {
        return $this->admin;
    }

    public function author(){
        return $this->belongsTo('App\Models\User');
    }

    public function posts(){
      return $this->hasMany('App\Models\Post')->orderBy('date', 'DESC');
    }
}
