<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Core\UserAvatar;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;

class SortOldAvatars extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sort:old-avatars';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Sort old avatars';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $users = User::all();
        $thumb_sizes = [300, 150, 64, 32];

        foreach ($users as $user) {
            if ($user->avatar_name != null) {
                $this->info('Import avatar ' . $user->id);
                if (!file_exists(storage_path('public') . '/avatars/' . $user->alias)) {
                    Storage::disk('public')->makeDirectory('avatars/' . $user->alias);
                }

                if (!file_exists(storage_path('public') . '/avatars/' . $user->alias . '/thumbnails')) {
                    Storage::disk('public')->makeDirectory('avatars/' . $user->alias . '/thumbnails');
                }

                $path = storage_path('app/old_avatars/' . $user->avatar_name);
                if (!file_exists($path)) continue;

                $img = Image::make($path);
                $name = $img->basename;
                $img->save(public_path() . '/storage/avatars/' . $user->alias . '/' . $name);

                foreach ($thumb_sizes as $size) {
                    $img->resize($size, null, function ($constraint) {
                        $constraint->aspectRatio();
                    });
                    $img->save(public_path() . '/storage/avatars/' . $user->alias . '/thumbnails/' . 'w_'. $size . '_' . $name);
                }
            }
        }
    }
}
