<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateKanbanCards extends Migration
{
    public function up()
    {
        Schema::connection('mongodb')->table('kanban_cards', function (Blueprint $collection) {
            $collection->index([ "board_id" => "2dsphere" ]);
            $collection->index([ "column_id" => "2dsphere" ]);
            $collection->index([ "creator_id" => "2dsphere" ]);
        });
    }

    public function down()
    {
        Schema::connection('mongodb')->table('kanban_cards', function (Blueprint $collection) {
            $collection->dropIndex(['board_id_2dsphere']);
            $collection->dropIndex(['column_id_2dsphere']);
            $collection->dropIndex(['creator_id_2dsphere']);
        });
    }
}
