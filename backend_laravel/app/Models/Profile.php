<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Profile extends Model
{
    protected $fillable = [
        'user_id',
        'study_program',
        'semester',
        'career_interest',
        'avatar_initials',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
