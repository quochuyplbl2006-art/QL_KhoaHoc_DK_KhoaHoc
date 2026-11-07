<?php

namespace App\Http\Controllers\Teacher;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SupportController extends Controller
{
    public function index()
    {
        $supports = [
            ['id' => 1, 'user' => 'Nguyễn Văn A', 'noi_dung' => 'Cần hỗ trợ bài tập câu 2', 'trang_thai' => 'Đã xử lý'],
            ['id' => 2, 'user' => 'Trần Thị B', 'noi_dung' => 'Hỏi về tài liệu học', 'trang_thai' => 'Chưa xử lý'],
        ];

        return view('teacher.supports.index', compact('supports'));
    }
}