<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vote_Post extends Model{
    protected $table = 'vote_post';
    protected $primaryKey = 'id_vote';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

    

}
