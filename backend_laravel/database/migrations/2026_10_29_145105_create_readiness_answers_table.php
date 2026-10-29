<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('readiness_answers', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('readiness_assessment_id')->constrained()->cascadeOnDelete();
            $table->foreignId('readiness_question_id')->constrained()->restrictOnDelete();
            $table->unsignedTinyInteger('value');
            $table->timestamps();

            $table->unique(['readiness_assessment_id', 'readiness_question_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('readiness_answers');
    }
};
