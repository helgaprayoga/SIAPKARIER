<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LearningProgress;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function summary(Request $request): JsonResponse
    {
        $user = $request->user();
        $readiness = $user->readinessAssessments()->latest()->first();
        $lastActivity = collect([
            $readiness?->updated_at,
            $user->cvs()->max('updated_at'),
            $user->portfolioProjects()->max('updated_at'),
            $user->learningProgress()->max('updated_at'),
            $user->safeChecklistProgress?->updated_at,
        ])->filter()->max();

        return response()->json([
            'readinessPercentage' => $readiness?->percentage,
            'readinessLabel' => $readiness?->overall_status,
            'completedMaterials' => LearningProgress::query()
                ->where('user_id', $user->id)
                ->whereNotNull('completed_at')
                ->count(),
            'savedCvs' => $user->cvs()->count(),
            'portfolioProjects' => $user->portfolioProjects()->count(),
            'lastUpdatedAt' => $lastActivity,
        ]);
    }
}
