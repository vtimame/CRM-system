<?php

namespace App\Console\Commands;

use App\Models\Core\Department;
use App\Models\Core\Division;
use App\Models\Core\Event;
use App\Models\Core\User;
use App\Models\Core\UserRole;
use App\Models\Kanban\Board;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Address;
use App\Models\Kanban\Card\Contact;
use App\Models\Kanban\Card\Client;
use App\Models\Kanban\Card\Operator;
use App\Models\Kanban\Card\Attachment;
use App\Models\Kanban\Card\Comment;
use App\Models\Kanban\Card\Command as CardCommand;
use App\Models\Kanban\Card\ManagerProfile;
use App\Models\Kanban\Card\ExploringProfile;
use App\Models\Kanban\Column;
use Illuminate\Console\Command;

class DeleteMysqlId extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:delete-mysql-id';

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
        UserRole::all()->each(fn ($el) => $el->unset('id'));
        User::all()->each(fn ($el) => $el->unset('id'));
        Division::all()->each(fn ($el) => $el->unset('id'));
        Department::all()->each(fn ($el) => $el->unset('id'));
        Card::all()->each(fn ($el) => $el->unset('id'));
        Board::all()->each(fn ($el) => $el->unset('id'));
        Column::all()->each(fn ($el) => $el->unset('id'));
        ExploringProfile::all()->each(fn ($el) => $el->unset('id'));
        ManagerProfile::all()->each(fn ($el) => $el->unset('id'));
        Address::all()->each(fn ($el) => $el->unset('id'));
        Contact::all()->each(fn ($el) => $el->unset('id'));
        Client::all()->each(fn ($el) => $el->unset('id'));
        Operator::all()->each(fn ($el) => $el->unset('id'));
        Attachment::all()->each(fn ($el) => $el->unset('id'));
        Comment::all()->each(fn ($el) => $el->unset('id'));
        CardCommand::all()->each(fn ($el) => $el->unset('id'));
        Event::all()->each(fn ($el) => $el->unset('id'));
    }
}
