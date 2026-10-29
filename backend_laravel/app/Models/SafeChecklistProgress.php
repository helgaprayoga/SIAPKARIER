<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SafeChecklistProgress extends Model
{
    protected $fillable = [
        'user_id',
        'checklist_version',
        'checked_item_ids',
    ];

    protected function casts(): array
    {
        return [
            'checked_item_ids' => 'array',
            'checklist_version' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
