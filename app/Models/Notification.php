<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model{
    protected $table = 'notification';
    protected $primaryKey = 'id_notification';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
