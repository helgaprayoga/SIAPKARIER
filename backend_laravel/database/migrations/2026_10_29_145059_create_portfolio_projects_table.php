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
        Schema::create('portfolio_projects', function (Blueprint $table): void {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('title');
            $table->string('short_description')->nullable();
            $table->text('problem')->nullable();
            $table->string('role');
            $table->text('process')->nullable();
            $table->text('result')->nullable();
            $table->json('tools')->nullable();
            $table->json('skills')->nullable();
            $table->string('image_path')->nullable();
            $table->string('link')->nullable();
            $table->text('reflection')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'updated_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('portfolio_projects');
    }
};
