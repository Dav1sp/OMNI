<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class User_Profile extends Model{
    protected $table = 'users_profile';
    protected $primaryKey = 'id_users_profile';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

    protected $fillable = ['descricao'];

}
