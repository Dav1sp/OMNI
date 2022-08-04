<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Activity extends Model{
    protected $table = 'activity';
    protected $primaryKey = 'id_activity';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
