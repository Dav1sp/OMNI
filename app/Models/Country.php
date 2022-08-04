<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Country extends Model{
    protected $table = 'country';
    protected $primaryKey = 'id_country';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

    public function user(){
        return $this->belongsTo('App\Models\User');
    }
}
