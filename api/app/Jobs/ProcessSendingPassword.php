<?php

namespace App\Jobs;

use App\Models\Core\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Ixudra\Curl\Facades\Curl;

class ProcessSendingPassword implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected User $user;
    protected string $password;

    /**
     * Create a new job instance.
     *
     * @param User $user
     * @param string $password
     */
    public function __construct(User $user, string $password)
    {
        $this->user = $user;
        $this->password = $password;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        Log::channel('pins')->info($this->user->surname.' '.$this->user->name.': '.$this->password);
        Curl::to(config('oycrm.service.sms.host'))
            ->withData([
                'login' => config('oycrm.service.sms.login'),
                'psw' => config('oycrm.service.sms.password'),
                'phones' => '7'.$this->user->mobile_phone,
                'mes' => 'Ваш новый пин-код: '.$this->password,
                'sender' => 'oycrm'
            ])
            ->post();
    }
}
