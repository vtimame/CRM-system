<?php

namespace App\Console\Commands;

use App\Models\Core\Event;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Console\Command;
use App\Models\Kanban\Card\Command as UserCommand;
use Illuminate\Support\Facades\Log;

class RemindUsersAboutAction extends Command
{
    protected NotificationService $notificationSrvice;
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'remind:events';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Remind users about scheduled actions';

    /**
     * Create a new command instance.
     *
     * @param NotificationService $notificationService
     */
    public function __construct(NotificationService $notificationService)
    {
        parent::__construct();
        $this->notificationSrvice = $notificationService;
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $time = new \DateTime();
        $events = Event::where([
            ['render_type' => 'call'],
            ['render_type' => 'meeting'],
            ['event_dt', '>', $time->format('Y-m-d H:i')],
            ['status', 'waiting']
        ])->get();

        foreach ($events as $event) {
            $now = Carbon::now()->format('Y-m-d H:i');
            $eventData = [
                'card_id' => $event->card_id,
                'user_id' => $event->user_id,
                'event_dt' => $event->event_dt

            ];

            if ($event->render_type == 'call') $eventData['type'] = 'userMustCall';
            if ($event->render_type == 'meeting') $eventData['type'] = 'userMustMeeting';

            $eventDate = Carbon::parse($event->event_dt)->format('Y-m-d H:i');
            $addOneDayDate = Carbon::now()->addDay()->format('Y-m-d H:i');
            $addOneHourDate = Carbon::now()->addHour()->format('Y-m-d H:i');
            $addFifteenMinutesDate = Carbon::now()->addMinutes(15)->format('Y-m-d H:i');

            dump($event->status);

            if ($eventDate == $addOneDayDate) {
                if ($event->render_type == 'meeting') $this->notify($event->user_id, $eventData);
            } else if ($eventDate == $addOneHourDate) {
                $this->notify($event->user_id, $eventData);
            } else if ($eventDate == $addFifteenMinutesDate) {
                $this->notify($event->user_id, $eventData);
            } else if ($eventDate == $now) {
                if ($event->render_type == 'call') $this->notify($event->user_id, $eventData);
            }
        }
    }

    protected function notify(string $user_id, array $eventData)
    {
        $event = Event::create($eventData);
        $this->notificationSrvice->send([$user_id], $event->id);
    }
}
