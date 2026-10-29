<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ReadinessAnswer extends Model
{
    protected $fillable = [
        'readiness_assessment_id',
        'readiness_question_id',
        'value',
    ];

    protected function casts(): array
    {
        return ['value' => 'integer'];
    }

    public function assessment(): BelongsTo
    {
        return $this->belongsTo(ReadinessAssessment::class, 'readiness_assessment_id');
    }

    public function question(): BelongsTo
    {
        return $this->belongsTo(ReadinessQuestion::class, 'readiness_question_id');
    }
}
