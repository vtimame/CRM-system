<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use Illuminate\Console\Command;

class MakeJWT extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'make:jwt {alias}';

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
        $user = User::where('alias', $this->argument('alias'))->first();
        $this->info($user->createToken('debug api key', [])->plainTextToken);
    }
}
