<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SafeChecklistItem;
use App\Models\SafeChecklistProgress;
use App\Models\SafeTopic;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SafeController extends Controller
{
    public function topics(): JsonResponse
    {
        return response()->json(SafeTopic::query()->orderBy('sort_order')->get());
    }

    public function checklist(Request $request): JsonResponse
    {
        $version = (int) $request->integer('version', 1);

        return response()->json([
            'version' => $version,
            'items' => SafeChecklistItem::query()
                ->where('version', $version)
                ->orderBy('sort_order')
                ->get(),
        ]);
    }

    public function progress(Request $request): JsonResponse
    {
        return response()->json(
            $request->user()->safeChecklistProgress()->first(),
        );
    }

    public function updateProgress(Request $request): JsonResponse
    {
        $data = $request->validate([
            'checklist_version' => ['required', 'integer', 'min:1'],
            'checked_item_ids' => ['required', 'array'],
            'checked_item_ids.*' => ['integer', 'distinct', 'exists:safe_checklist_items,id'],
        ]);

        $progress = SafeChecklistProgress::updateOrCreate(
            ['user_id' => $request->user()->id],
            $data,
        );

        return response()->json($progress);
    }
}
