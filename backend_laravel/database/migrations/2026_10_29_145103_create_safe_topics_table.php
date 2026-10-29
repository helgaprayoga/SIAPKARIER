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
        Schema::create('safe_topics', function (Blueprint $table): void {
            $table->id();
            $table->string('title');
            $table->text('summary');
            $table->longText('content');
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamp('source_checked_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('safe_topics');
    }
};
