<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DonDangKy extends Model
{
    use HasFactory;
    protected $table = 'don_dang_ky';
    protected $fillable = ['user_id', 'khoa_hoc_id', 'trang_thai', 'ngay_dang_ky'];
}