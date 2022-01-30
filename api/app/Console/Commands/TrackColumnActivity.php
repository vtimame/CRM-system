<?php

namespace App\Console\Commands;

use App\Models\Core\Event;
use App\Models\Kanban\Column;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Arr;

class TrackColumnActivity extends Command
{
    protected NotificationService $notificationService;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'track:column-activity';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Track activity in cards of column';

    /**
     * Create a new command instance.
     *
     * @param NotificationService $notificationService
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
        $time = Carbon::now()->subDay();
        $columns = Column::with('cards')->where('track_activity', true)->get();
        $cards = Arr::flatten($columns->pluck('cards'));
        $cards = Arr::where($cards, function ($card) use ($time) {
            return $card->updated_at < $time;
        });

        foreach ($cards as $card) {
            $events = Event::where([
                ['card_id', $card->id], ['status', 'waiting'], ['event_dt', '>', Carbon::now()->toDateTimeString()]
            ])->get();
            if (!empty($events)) continue;
            $event = Event::create([
                'type' => 'remindCardActivity',
                'card_id' => $card->_id
            ]);
            $this->notificationService->send($card->members, $event->id);
        }
    }
}
