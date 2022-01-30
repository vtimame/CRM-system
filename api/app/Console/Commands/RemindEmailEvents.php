<?php

namespace App\Console\Commands;

use App\Jobs\ProccessSendingMorningNotification;
use App\Models\Core\Event;
use App\Models\Core\User;
use Carbon\Carbon;
use Illuminate\Console\Command;

class RemindEmailEvents extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'remind:email-events';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

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
        $date = Carbon::now();
        if ($date->format('H:i') == '08:00') {
            $events = Event::where([
                ['render_type' => 'call'],
                ['render_type' => 'meeting'],
                ['event_dt', '>', $date->format('Y-m-d H:i')],
                ['event_dt', '<', $date->addDay()->setHour(0)->setMinutes(0)->setSeconds(0)->format('Y-m-d H:i')],
                ['status', 'waiting']
            ])->get();

            $ids = [];
            foreach ($events as $event) {
                $ids[] = $event->_id;
            }

            ProccessSendingMorningNotification::dispatch($ids);
        }
    }
}
