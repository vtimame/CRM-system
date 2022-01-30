<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use Illuminate\Console\Command;
use PHPMailer\PHPMailer\PHPMailer;

class TestEmailNotifications extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'test:email-notifications';

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
        $users = User::where('alias', 'i.chernega')->get();
        $data = [];
        foreach ($users as $user) {
            if (!isset($user->email)) continue;
            $data[] = $user;

            $mail = new PHPMailer();
            $mail->isSMTP();
            $mail->Host = 'localhost';
            $mail->Port = 1025;

            $mail->From = 'from@example.com';
            $mail->FromName = 'Mailer';
            $mail->Subject = 'Here is the subject';
            $mail->Body    = '123';
            $mail->addAddress('i.chernega@oy2b.ru');
            $mail->send();
        }
        dd(count($data));
    }
}
