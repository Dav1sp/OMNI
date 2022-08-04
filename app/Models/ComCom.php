<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ComCom extends Model{
    protected $table = 'comcom';
    protected $primaryKey = ['id_commenter','id_commented'];
    public $incrementing = false;
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
