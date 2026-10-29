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
        Schema::create('learning_materials', function (Blueprint $table): void {
            $table->id();
            $table->string('slug')->unique();
            $table->string('category_id', 80);
            $table->string('category_label');
            $table->string('title');
            $table->text('summary');
            $table->longText('content');
            $table->unsignedSmallInteger('duration_minutes');
            $table->string('content_type', 30);
            $table->string('source_type', 20)->default('internal');
            $table->string('source_name')->nullable();
            $table->string('external_url')->nullable();
            $table->timestamp('source_checked_at')->nullable();
            $table->boolean('is_published')->default(false);
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->index(['is_published', 'category_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('learning_materials');
    }
};
