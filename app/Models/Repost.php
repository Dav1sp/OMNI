<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Repost extends Model{
    protected $table = 'repost';
    protected $primaryKey = ['id_users_profile','id_post'];
    public $incrementing = false;
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
