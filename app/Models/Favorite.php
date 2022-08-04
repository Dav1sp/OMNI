<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Favorite extends Model{
    protected $table = 'favorite';
    protected $primaryKey = ['id_users_profile','id_post'];
    public  $incrementing = false;
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
