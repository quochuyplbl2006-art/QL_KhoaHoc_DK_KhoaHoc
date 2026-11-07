<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HoTroHocVien extends Model
{
    use HasFactory;

    protected $table = 'ho_tro_hoc_vien';

    protected $fillable = [
        'user_id',
        'noi_dung',
        'trang_thai',
    ];
}
