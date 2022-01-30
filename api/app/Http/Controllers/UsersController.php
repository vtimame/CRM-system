<?php

namespace App\Http\Controllers;

use App\Models\Core\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;

class UsersController extends Controller
{
    public function index(Request $request)
    {
        return User::all();
    }

    public function store(Request $request)
    {
        return User::create([
            'surname' => 'Новый',
            'name' => 'Пользователь'
        ]);
    }

    public function show(string $user_id, Request $request)
    {
        return User::findOrFail($user_id);
    }

    public function update(string $user_id, Request $request)
    {
        User::findOrFail($user_id)->update($request->all());
        return User::findOrFail($user_id);
    }

    public function loadAvatar(string $user_id, Request $request)
    {
        $thumb_sizes = [300, 150, 64, 32];
        if ($request->file('file')->isValid()) {
            $user = User::findOrFail($user_id);
            $file = $request->file('file');

            if (!file_exists(storage_path('public') . '/avatars/' . $user->alias)) {
                Storage::disk('public')->makeDirectory('avatars/' . $user->alias);
            }

            if (!file_exists(storage_path('public') . '/avatars/' . $user->alias . '/thumbnails')) {
                Storage::disk('public')->makeDirectory('avatars/' . $user->alias . '/thumbnails');
            }

            $img = Image::make($file->path());
            $name = $img->basename;
            $img->save(public_path() . '/storage/avatars/' . $user->alias . '/' . $name);

            foreach ($thumb_sizes as $size) {
                $img->resize($size, null, function ($constraint) {
                    $constraint->aspectRatio();
                });
                $img->save(public_path() . '/storage/avatars/' . $user->alias . '/thumbnails/' . 'w_'. $size . '_' . $name);
            }

            $user->avatar_name = $name;
            $user->save();
        }
    }

}
