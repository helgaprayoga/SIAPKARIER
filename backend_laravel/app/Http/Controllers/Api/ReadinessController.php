<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ReadinessAssessment;
use App\Models\ReadinessQuestion;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class ReadinessController extends Controller
{
    public function questions(): JsonResponse
    {
        return response()->json(
            ReadinessQuestion::query()
                ->where('is_active', true)
                ->orderBy('sort_order')
                ->get(),
        );
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'answers' => ['required', 'array', 'min:1'],
            'answers.*.question_id' => ['required', 'integer', 'distinct', 'exists:readiness_questions,id'],
            'answers.*.value' => ['required', 'integer', 'in:0,1,2'],
        ]);

        $questions = ReadinessQuestion::query()
            ->where('is_active', true)
            ->get()
            ->keyBy('id');
        $answeredQuestionIds = collect($data['answers'])
            ->pluck('question_id')
            ->map(static fn (int $questionId): int => $questionId);

        if (
            $questions->count() !== $answeredQuestionIds->count()
            || $questions->keys()->diff($answeredQuestionIds)->isNotEmpty()
        ) {
            throw ValidationException::withMessages([
                'answers' => ['Semua pertanyaan aktif wajib dijawab.'],
            ]);
        }

        $categoryResults = [];
        $totalPoints = 0;
        $maxPoints = 0;

        foreach ($data['answers'] as $answer) {
            $question = $questions->get($answer['question_id']);
            $points = 2 - $answer['value'];
            $categoryId = $question->category_id;

            $categoryResults[$categoryId] ??= [
                'categoryId' => $categoryId,
                'label' => $question->category_label,
                'points' => 0,
                'maxPoints' => 0,
            ];
            $categoryResults[$categoryId]['points'] += $points;
            $categoryResults[$categoryId]['maxPoints'] += 2;
            $totalPoints += $points;
            $maxPoints += 2;
        }

        foreach ($categoryResults as &$category) {
            $category['percentage'] = $category['maxPoints'] === 0
                ? 0
                : (int) round(($category['points'] / $category['maxPoints']) * 100);
            $category['status'] = $this->statusFor($category['percentage']);
        }
        unset($category);

        $percentage = $maxPoints === 0
            ? 0
            : (int) round(($totalPoints / $maxPoints) * 100);

        $assessment = DB::transaction(function () use (
            $request,
            $data,
            $categoryResults,
            $totalPoints,
            $maxPoints,
            $percentage,
        ): ReadinessAssessment {
            $assessment = ReadinessAssessment::create([
                'user_id' => $request->user()->id,
                'total_points' => $totalPoints,
                'max_points' => $maxPoints,
                'percentage' => $percentage,
                'overall_status' => $this->statusFor($percentage),
                'category_results' => array_values($categoryResults),
            ]);

            $assessment->answers()->createMany(
                collect($data['answers'])
                    ->map(fn (array $answer): array => [
                        'readiness_question_id' => $answer['question_id'],
                        'value' => $answer['value'],
                    ])
                    ->all(),
            );

            return $assessment;
        });

        return response()->json($assessment->load('answers.question'), 201);
    }

    public function latest(Request $request): JsonResponse
    {
        return response()->json(
            $request->user()->readinessAssessments()->latest()->first(),
        );
    }

    public function show(Request $request, ReadinessAssessment $assessment): JsonResponse
    {
        abort_unless($assessment->user_id === $request->user()->id, 404);

        return response()->json($assessment->load('answers.question'));
    }

    private function statusFor(int $percentage): string
    {
        return match (true) {
            $percentage >= 67 => 'Sudah Mulai',
            $percentage >= 34 => 'Perlu Dikembangkan',
            default => 'Langkah Awal',
        };
    }
}
