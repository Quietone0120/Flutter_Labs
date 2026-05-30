<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PagesController;

// 1️⃣ Энгийн route
Route::get('/hello', function () {
    return "Hello Laravel";
});

// 2️⃣ View route
Route::get('/welcome', function () {
    return view('pages.welcome');
});

// 3️⃣ Route параметр
Route::get('/users/{name}', function ($name) {
    return view('users', ['name' => $name]);
});

// 4️⃣ Controller-тэй route
Route::get('/about', [PagesController::class, 'about']);
Route::get('/services', [PagesController::class, 'services']);

// 5️⃣ Middleware (query параметр шалгах)
Route::get('/admin', function () {
    return view('admin.dashboard');
})->middleware('role:admin')->name('dashboard');

// 6️⃣ Middleware (URL параметр шалгах)
Route::get('/admin/{role}', function ($role) {
    return view('admin.dashboard');
})->middleware('role:admin');

// Access denied view
Route::get('/accessdenied', function () {
    return view('admin.accessdenied');
})->name('accessdenied');

// 7️⃣ Terminable middleware
Route::get('/testlog', function () {
    return "Check logs!";
})->middleware('logafter');
