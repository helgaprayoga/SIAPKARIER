<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class LearningMaterial extends Model
{
    protected $fillable = [
        'slug',
        'category_id',
        'category_label',
        'title',
        'summary',
        'content',
        'duration_minutes',
        'content_type',
        'source_type',
        'source_name',
        'external_url',
        'source_checked_at',
        'is_published',
        'sort_order',
    ];

    protected function casts(): array
    {
        return [
            'source_checked_at' => 'datetime',
            'is_published' => 'boolean',
        ];
    }

    public function progress(): HasMany
    {
        return $this->hasMany(LearningProgress::class);
    }
}
