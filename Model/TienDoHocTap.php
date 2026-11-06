<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TienDoHocTap extends Model
{
    use HasFactory;

    protected $table = 'tien_do_hoc_tap';
    protected $fillable = ['user_id', 'course_id', 'progress_percentage'];
}
