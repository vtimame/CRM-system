<?php

namespace App\Console\Commands;

use App\Models\Core\Event;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Console\Command;

class reportExpiredEvents extends Command
{
    protected NotificationService $notificationService;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'report:expired-events';

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
    public function __construct(NotificationService $notificationService)
    {
        parent::__construct();
        $this->notificationService = $notificationService;
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $start_date = '2020-06-22 00:00:00';
        $now = Carbon::now()->format('Y-m-d H:m');
        $events = Event::where([
            ['status', 'waiting'], ['event_dt', '>', $start_date], ['event_dt', '<', $now]
        ])->get();

        foreach ($events as $event) {
            $call_time = Carbon::parse($event->event_dt)->addHours(2)->format('Y-m-d H:m');
            $meeting_time = Carbon::parse($event->event_dt)->addHours(4)->format('Y-m-d H:m');
            $expired_time_for_managers = Carbon::parse($event->event_dt)->addDays(2)->format('Y-m-d H:m');

            if ($now > $expired_time_for_managers && count($event->user->division->managers) > 0) {
                $this->info('123');
                $report = Event::create([
                    'type' => 'reportManagerExpiredEvents',
                    'initiator_id' => $event->user_id,
                    'card_id' => $event->card_id,
                    'command_type' => $event->command_type
                ]);
                $this->notificationService->send($event->user->division->managers, $report->id);
            }

            if (
                ($event->command_type == 'call' && $now > $call_time)
                || ($event->command_type == 'meeting' && $now > $meeting_time)
            ) {
                $report = Event::create([
                    'type' => 'reportExpiredEvents',
                    'initiator_id' => $event->user_id,
                    'card_id' => $event->card_id,
                    'command_type' => $event->command_type
                ]);
                $this->notificationService->send([$event->user_id], $report->id);
            }
        }

    }
}
