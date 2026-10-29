<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SafeChecklistItem extends Model
{
    protected $fillable = [
        'text',
        'help_text',
        'sort_order',
        'version',
    ];
}
