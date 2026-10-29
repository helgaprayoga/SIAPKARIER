<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PortfolioProject extends Model
{
    protected $fillable = [
        'user_id',
        'title',
        'short_description',
        'problem',
        'role',
        'process',
        'result',
        'tools',
        'skills',
        'image_path',
        'link',
        'reflection',
    ];

    protected function casts(): array
    {
        return [
            'tools' => 'array',
            'skills' => 'array',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
