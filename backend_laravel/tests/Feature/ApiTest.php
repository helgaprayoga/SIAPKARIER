<?php

namespace Tests\Feature;

use App\Models\User;
use Database\Seeders\ReadinessQuestionSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_and_read_profile(): void
    {
        $response = $this->postJson('/api/v1/auth/register', [
            'name' => 'Raka Aditya',
            'email' => 'raka@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertCreated()->assertJsonStructure(['user', 'token']);

        $this->withHeader('Authorization', 'Bearer '.$response->json('token'))
            ->getJson('/api/v1/auth/me')
            ->assertOk()
            ->assertJsonPath('email', 'raka@example.com');
    }

    public function test_readiness_assessment_calculates_transparently(): void
    {
        $this->seed(ReadinessQuestionSeeder::class);
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $questions = $this->getJson('/api/v1/readiness/questions')
            ->assertOk()
            ->json();

        $answers = array_map(
            static fn (array $question): array => [
                'question_id' => $question['id'],
                'value' => 0,
            ],
            $questions,
        );

        $this->postJson('/api/v1/readiness/assessments', ['answers' => $answers])
            ->assertCreated()
            ->assertJsonPath('percentage', 100)
            ->assertJsonPath('overall_status', 'Sudah Mulai');
    }

    public function test_readiness_requires_all_active_questions(): void
    {
        $this->seed(ReadinessQuestionSeeder::class);
        Sanctum::actingAs(User::factory()->create());
        $question = $this->getJson('/api/v1/readiness/questions')->json()[0];

        $this->postJson('/api/v1/readiness/assessments', [
            'answers' => [[
                'question_id' => $question['id'],
                'value' => 0,
            ]],
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('answers');
    }

    public function test_user_cv_is_reflected_in_home_summary(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $this->postJson('/api/v1/cvs', [
            'title' => 'CV Magang',
            'data' => ['fullName' => 'Raka Aditya'],
            'template' => 'focus',
        ])->assertCreated();

        $this->getJson('/api/v1/home/summary')
            ->assertOk()
            ->assertJsonPath('savedCvs', 1)
            ->assertJsonPath('portfolioProjects', 0);
    }
}
