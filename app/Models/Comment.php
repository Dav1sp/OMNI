<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model{
    protected $table = 'comment';
    protected $primaryKey = 'id_comment';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/
    public function user() {
        return $this->hasOne('App\Models\User',localKey: 'id_users', foreignKey: 'id_users');
    }

}
