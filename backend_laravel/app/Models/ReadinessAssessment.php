<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ReadinessAssessment extends Model
{
    protected $fillable = [
        'user_id',
        'total_points',
        'max_points',
        'percentage',
        'overall_status',
        'category_results',
    ];

    protected function casts(): array
    {
        return [
            'category_results' => 'array',
            'total_points' => 'integer',
            'max_points' => 'integer',
            'percentage' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function answers(): HasMany
    {
        return $this->hasMany(ReadinessAnswer::class);
    }
}
