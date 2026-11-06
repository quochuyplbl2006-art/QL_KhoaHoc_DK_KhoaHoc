<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ChungChi extends Model
{
    use HasFactory;

    protected $table = 'chung_chi';
    protected $fillable = ['user_id', 'course_id', 'issue_date', 'certificate_code'];
}
