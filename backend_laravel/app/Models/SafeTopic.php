<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SafeTopic extends Model
{
    protected $fillable = [
        'title',
        'summary',
        'content',
        'sort_order',
        'source_checked_at',
    ];

    protected function casts(): array
    {
        return ['source_checked_at' => 'datetime'];
    }
}
