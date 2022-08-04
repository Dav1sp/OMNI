<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Vote_Comment extends Model{
    protected $table = 'vote_comment';
    protected $primaryKey = 'id_vote';
    public $timestamps = false;
    /*protected $dateFormat = 'U';*/

}
