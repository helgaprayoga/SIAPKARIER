<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LearningMaterial;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class LearningController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = LearningMaterial::query()
            ->where('is_published', true)
            ->orderBy('sort_order');

        if ($request->filled('category')) {
            $query->where('category_id', $request->string('category')->toString());
        }

        if ($request->filled('q')) {
            $search = $request->string('q')->toString();
            $query->where(function ($builder) use ($search): void {
                $builder->where('title', 'ilike', "%{$search}%")
                    ->orWhere('summary', 'ilike', "%{$search}%");
            });
        }

        return response()->json($query->get());
    }

    public function show(string $slug): JsonResponse
    {
        return response()->json(
            LearningMaterial::query()
                ->where('slug', $slug)
                ->where('is_published', true)
                ->firstOrFail(),
        );
    }

    public function progress(Request $request, LearningMaterial $material): JsonResponse
    {
        abort_unless($material->is_published, 404);

        $data = $request->validate([
            'completed' => ['required', 'boolean'],
        ]);

        if ($data['completed']) {
            DB::table('learning_progress')->updateOrInsert(
                [
                    'user_id' => $request->user()->id,
                    'learning_material_id' => $material->id,
                ],
                [
                    'completed_at' => now(),
                    'updated_at' => now(),
                    'created_at' => now(),
                ],
            );
        } else {
            $request->user()->learningProgress()
                ->where('learning_material_id', $material->id)
                ->delete();
        }

        return response()->json([
            'materialId' => $material->id,
            'completed' => $data['completed'],
        ]);
    }
}
