<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Attachment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Facades\Image;

class AttachmentsController extends Controller
{
    public function index(Request $request)
    {
        $attachments =  Attachment::with('user')->find($request->get('ids'));
        if (!$attachments) return [];
        return $attachments;
    }

    public function update(string $attachment_id, Request $request)
    {
        Attachment::find($attachment_id)->update($request->all());
        return Attachment::find($attachment_id);
    }

    public function store(string $card_id, Request $request)
    {
        if (!file_exists(storage_path('public') . '/attachments/' . $card_id)) {
            Storage::disk('public')->makeDirectory('attachments/' . $card_id);
        }

        if (!file_exists(storage_path('public') . '/attachments/' . $card_id . '/thumbnails')) {
            Storage::disk('public')->makeDirectory('attachments/' . $card_id . '/thumbnails');
        }

        if ($this->isImage($request->file->extension())) {
            $this->loadImage($card_id, $request);
        } else {
            $this->loadFile($card_id, $request);
        }

        $attachment = Attachment::create([
            'user_id' => $request->user()->id,
            'name' => $request->file->getClientOriginalName()
        ]);

        Card::find($card_id)->push('attachments', $attachment->_id);

        $attachment->load('user');
        return $attachment;
    }

    protected function isImage(string $extension): bool
    {
        $image_extensions = ['png', 'jpg', 'jpeg', 'gif'];
        return in_array($extension, $image_extensions);
    }

    protected function loadImage(string $card_id, Request $request)
    {
        $thumb_sizes = [900, 300];
//        $file_extension = explode('.', $request->file->getClientOriginalName())[1];
        $img = Image::make($request->file->path());
        $name = $request->file->getClientOriginalName();
        $img->save(public_path() . '/storage/attachments/' . $card_id . '/' . $name);
        foreach ($thumb_sizes as $size) {
            $img->resize($size, null, function ($constraint) {
                $constraint->aspectRatio();
            });
            $img->save(public_path() . '/storage/attachments/' . $card_id . '/thumbnails/' . 'w_'. $size . '_' . $name);
        }
    }

    protected function loadFile(string $card_id, Request $request)
    {
        Storage::disk('public')->put('attachments/' . $card_id . '/' . $request->file->getClientOriginalName(), file_get_contents($request->file->path()));
    }

    public function destroy(string $card_id, string $attachment_id)
    {
        Card::findOrFail($card_id)->pull('attachments', $attachment_id);
        Attachment::find($attachment_id)->delete();
    }
}
