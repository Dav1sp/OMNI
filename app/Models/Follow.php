<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Follow extends Model{
    protected $table = 'follow';
    protected $primaryKey = ['id_users_follower','id_users_followed'];
    public $incrementing = false;
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
