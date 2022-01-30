<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Route;

class RouteServiceProvider extends ServiceProvider
{
    /**
     * This namespace is applied to your controller routes.
     *
     * In addition, it is set as the URL generator's root namespace.
     *
     * @var string
     */
    protected $api_namespace = 'App\Http\Controllers';
    protected $user_namespace = 'App\Http\Controllers\User';
    protected $auth_namespace = 'App\Http\Controllers\Auth';
    protected $api_kanban_namespace = 'App\Http\Controllers\Kanban';
    protected $api_pbx_namespace = 'App\Http\Controllers\PBX';
    protected $api_site_namespace = 'App\Http\Controllers\Site';
    protected $api_stats_namespace = 'App\Http\Controllers\Stats';

    /**
     * Define your route model bindings, pattern filters, etc.
     *
     * @return void
     */
    public function boot()
    {
        parent::boot();
    }

    /**
     * Define the routes for the application.
     *
     * @return void
     */
    public function map()
    {
        $this->mapAuthRoutes();
        $this->mapUserRoutes();
        $this->mapApiRoutes();
        $this->mapKanbanRoutes();
        $this->map3cxRoutes();
        $this->mapSiteRoutes();
        $this->mapStatsRoutes();
    }

    protected function mapAuthRoutes()
    {
        Route::prefix('auth')
            ->middleware('api')
            ->namespace($this->auth_namespace)
            ->group(base_path('routes/api/auth.php'));
    }

    protected function mapUserRoutes()
    {
        Route::prefix('user')
            ->middleware(['api', 'auth:sanctum'])
            ->namespace($this->user_namespace)
            ->group(base_path('routes/api/user.php'));
    }

    protected function mapApiRoutes()
    {
        Route::middleware(['api', 'auth:sanctum'])
            ->namespace($this->api_namespace)
            ->group(base_path('routes/api.php'));
    }

    protected function mapKanbanRoutes()
    {
        Route::prefix('kanban')
            ->middleware(['api', 'auth:sanctum'])
            ->namespace($this->api_kanban_namespace)
            ->group(base_path('routes/api/kanban.php'));
    }

    protected function mapStatsRoutes()
    {
        Route::prefix('stats')
            ->middleware(['api', 'auth:sanctum'])
            ->namespace($this->api_stats_namespace)
            ->group(base_path('routes/api/stats.php'));
    }

    protected function map3cxRoutes()
    {
        Route::prefix('pbx')
//            ->middleware(['api', 'auth:sanctum'])
            ->namespace($this->api_pbx_namespace)
            ->group(base_path('routes/api/pbx.php'));
    }

    protected function mapSiteRoutes()
    {
        Route::prefix('site')
            ->namespace($this->api_site_namespace)
            ->group(base_path('routes/api/site.php'));
    }
}
