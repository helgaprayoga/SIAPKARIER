<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PortfolioProject;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PortfolioController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json(
            $request->user()->portfolioProjects()->latest('updated_at')->get(),
        );
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate($this->rules());
        $project = $request->user()->portfolioProjects()->create($data);

        return response()->json($project, 201);
    }

    public function show(Request $request, PortfolioProject $project): JsonResponse
    {
        $this->ensureOwner($request, $project);

        return response()->json($project);
    }

    public function update(Request $request, PortfolioProject $project): JsonResponse
    {
        $this->ensureOwner($request, $project);
        $project->update($request->validate($this->rules(true)));

        return response()->json($project->fresh());
    }

    public function uploadImage(Request $request, PortfolioProject $project): JsonResponse
    {
        $this->ensureOwner($request, $project);
        $request->validate([
            'image' => ['required', 'image', 'mimes:jpg,jpeg,png', 'max:5120'],
        ]);

        $disk = config('filesystems.default');
        $path = $request->file('image')->store('portfolio/'.$request->user()->id, $disk);
        $project->update(['image_path' => $path]);

        return response()->json([
            'path' => $path,
            'url' => Storage::disk($disk)->url($path),
            'project' => $project->fresh(),
        ]);
    }

    public function destroy(Request $request, PortfolioProject $project): JsonResponse
    {
        $this->ensureOwner($request, $project);
        $project->delete();

        return response()->json(['message' => 'Proyek berhasil dihapus.']);
    }

    private function rules(bool $sometimes = false): array
    {
        $prefix = $sometimes ? 'sometimes|' : '';

        return [
            'title' => $prefix.'required|string|min:3|max:100',
            'short_description' => $prefix.'nullable|string|max:600',
            'problem' => $prefix.'nullable|string|max:600',
            'role' => $prefix.'required|string|min:2|max:80',
            'process' => $prefix.'nullable|string|max:1000',
            'result' => $prefix.'nullable|string|max:600',
            'tools' => $prefix.'nullable|array',
            'tools.*' => 'string|max:80',
            'skills' => $prefix.'nullable|array',
            'skills.*' => 'string|max:80',
            'link' => $prefix.'nullable|url|max:255',
            'reflection' => $prefix.'nullable|string|max:1000',
        ];
    }

    private function ensureOwner(Request $request, PortfolioProject $project): void
    {
        abort_unless($project->user_id === $request->user()->id, 404);
    }
}
