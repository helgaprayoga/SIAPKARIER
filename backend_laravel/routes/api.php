<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CvController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\LearningController;
use App\Http\Controllers\Api\PortfolioController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ReadinessController;
use App\Http\Controllers\Api\SafeController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function (): void {
    Route::prefix('auth')->group(function (): void {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
    });

    Route::get('readiness/questions', [ReadinessController::class, 'questions']);
    Route::get('learning/materials', [LearningController::class, 'index']);
    Route::get('learning/materials/{slug}', [LearningController::class, 'show']);
    Route::get('safe/topics', [SafeController::class, 'topics']);
    Route::get('safe/checklist', [SafeController::class, 'checklist']);

    Route::middleware('auth:sanctum')->group(function (): void {
        Route::get('auth/me', [AuthController::class, 'me']);
        Route::post('auth/logout', [AuthController::class, 'logout']);

        Route::get('profile', [ProfileController::class, 'show']);
        Route::put('profile', [ProfileController::class, 'update']);

        Route::get('home/summary', [HomeController::class, 'summary']);

        Route::post('readiness/assessments', [ReadinessController::class, 'store']);
        Route::get('readiness/assessments/latest', [ReadinessController::class, 'latest']);
        Route::get('readiness/assessments/{assessment}', [ReadinessController::class, 'show']);

        Route::post('cvs/{cv}/pdf', [CvController::class, 'uploadPdf']);
        Route::apiResource('cvs', CvController::class);

        Route::post('portfolio/projects/{project}/image', [PortfolioController::class, 'uploadImage']);
        Route::apiResource('portfolio/projects', PortfolioController::class)
            ->parameters(['projects' => 'project']);

        Route::put('learning/progress/{material}', [LearningController::class, 'progress']);

        Route::get('safe/progress', [SafeController::class, 'progress']);
        Route::put('safe/progress', [SafeController::class, 'updateProgress']);
    });
});
