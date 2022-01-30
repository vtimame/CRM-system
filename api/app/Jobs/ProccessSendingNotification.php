<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Ixudra\Curl\Facades\Curl;

class ProccessSendingNotification implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected string $user_id;
    protected string $notification_id;

    /**
     * Create a new job instance.
     *
     * @param string $user_id
     * @param string $notification_id
     */
    public function __construct(string $user_id, string $notification_id)
    {
        $this->user_id = $user_id;
        $this->notification_id = $notification_id;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        Curl::to(config('oycrm.service.oymailer').'/notification')
            ->withData(['user_id' => $this->user_id, 'notification_id' => $this->notification_id])->post();
    }
}
