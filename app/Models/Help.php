<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Help extends Model{
    protected $table = 'help';
    protected $primaryKey = 'id_help';
    public $timestamps = false;

    protected $fillable = [
        'Text'
    ]; 

}