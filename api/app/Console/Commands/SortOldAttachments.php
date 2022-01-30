<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Attachment;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;
use League\Flysystem\FileNotFoundException;

class SortOldAttachments extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'sort:old-attachments {offset?}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Sort old attachments';

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
        $this->info($this->description);
        $attachments = Attachment::all();

        foreach ($attachments as $attachment)
        {
            $card = Card::where('attachments', 'all', [$attachment->_id])->first();
            if (!$card) continue;

            $this->info('Import attachment ' . $attachment->id);
                $thumb_sizes = [900, 300];
                $file_extension = explode('.', $attachment->name)[1];
                $image_extensions = ['png', 'jpg', 'jpeg', 'gif'];

                $path = 'old_attachments/' . $attachment->name;
                if (file_exists(storage_path('app') . '/' . $path)) {
                    if (!file_exists(storage_path('public') . '/attachments/' . $card->_id)) {
                        Storage::disk('public')->makeDirectory('attachments/' . $card->_id);
                    }

                    if (!file_exists(storage_path('public') . '/attachments/' . $card->_id . '/thumbnails')) {
                        Storage::disk('public')->makeDirectory('attachments/' . $card->_id . '/thumbnails');
                    }

                    if (in_array($file_extension, $image_extensions)) {
//                        try {
                            $img = Image::make(storage_path('app') . '/' . $path);
                            $name = $img->basename;
                            $img->save(public_path() . '/storage/attachments/' . $card->_id . '/' . $name);

                            foreach ($thumb_sizes as $size) {
                                $img->resize($size, null, function ($constraint) {
                                    $constraint->aspectRatio();
                                });
                                $img->save(public_path() . '/storage/attachments/' . $card->_id . '/thumbnails/' . 'w_'. $size . '_' . $name);
                            }
//                        } catch (\Throwable $e) {
//                            $file = Storage::disk('local')->get($path);
//                            Storage::disk('public')->put('attachments/' . $attachment->card_id . '/' . $attachment->name, $file);
//                        }
                    } else {
                        $file = Storage::disk('local')->get($path);
                        Storage::disk('public')->put('attachments/' . $card->_id . '/' . $attachment->name, $file);
                    }
                }
        }
    }
}
