<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Cv;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CvController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json(
            $request->user()->cvs()->latest('updated_at')->get(),
        );
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'title' => ['nullable', 'string', 'max:120'],
            'data' => ['required', 'array'],
            'template' => ['nullable', 'string', 'in:focus,classic,modern'],
        ]);

        $cv = $request->user()->cvs()->create([
            'title' => $data['title'] ?? 'CV Tanpa Judul',
            'data' => $data['data'],
            'template' => $data['template'] ?? 'focus',
        ]);

        return response()->json($cv, 201);
    }

    public function show(Request $request, Cv $cv): JsonResponse
    {
        $this->ensureOwner($request, $cv);

        return response()->json($cv);
    }

    public function update(Request $request, Cv $cv): JsonResponse
    {
        $this->ensureOwner($request, $cv);

        $data = $request->validate([
            'title' => ['sometimes', 'nullable', 'string', 'max:120'],
            'data' => ['sometimes', 'array'],
            'template' => ['sometimes', 'string', 'in:focus,classic,modern'],
        ]);

        $cv->update($data);

        return response()->json($cv->fresh());
    }

    public function uploadPdf(Request $request, Cv $cv): JsonResponse
    {
        $this->ensureOwner($request, $cv);

        $request->validate([
            'pdf' => ['required', 'file', 'mimes:pdf', 'max:10240'],
        ]);

        $disk = config('filesystems.default');
        $path = $request->file('pdf')->store('cvs/'.$request->user()->id, $disk);
        $cv->update(['pdf_path' => $path]);

        return response()->json([
            'path' => $path,
            'url' => Storage::disk($disk)->url($path),
            'cv' => $cv->fresh(),
        ]);
    }

    public function destroy(Request $request, Cv $cv): JsonResponse
    {
        $this->ensureOwner($request, $cv);
        $cv->delete();

        return response()->json(['message' => 'CV berhasil dihapus.']);
    }

    private function ensureOwner(Request $request, Cv $cv): void
    {
        abort_unless($cv->user_id === $request->user()->id, 404);
    }
}
