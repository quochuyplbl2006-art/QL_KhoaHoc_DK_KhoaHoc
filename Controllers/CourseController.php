<?php

namespace App\Http\Controllers\Client;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class CourseController extends Controller
{
    public function index()
    {
        $courses = [
            ['id' => 1, 'ten' => 'Lập trình Laravel Cơ Bản', 'mo_ta' => 'Khóa học dành cho người mới bắt đầu'],
            ['id' => 2, 'ten' => 'Thiết kế CSDL SQL Server', 'mo_ta' => 'Kiến thức về Database và Trigger'],
        ];

        return view('client.dashboard.index', compact('courses'));
    }
}
