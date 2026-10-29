<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json($request->user()->load('profile'));
    }

    public function update(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['sometimes', 'required', 'string', 'min:2', 'max:80'],
            'study_program' => ['nullable', 'string', 'max:80'],
            'semester' => ['nullable', 'integer', 'between:1,14'],
            'career_interest' => ['nullable', 'string', 'max:80'],
        ]);

        $user = $request->user();
        if (array_key_exists('name', $data)) {
            $user->update(['name' => $data['name']]);
        }

        $profile = $user->profile()->updateOrCreate(
            ['user_id' => $user->id],
            collect($data)->except('name')->all(),
        );

        return response()->json($user->fresh()->load('profile'));
    }
}
