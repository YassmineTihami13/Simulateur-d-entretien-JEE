<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class admin extends Model
{
    use HasFactory;

    protected $table = 'admins';
    protected $primaryKey = 'id';
    public $timestamps = false;
    protected $fillable = ['nom', 'email', 'password'];

    // Pour que password_verify fonctionne
    public function getAuthPassword()
    {
        return $this->password;
    }
}
