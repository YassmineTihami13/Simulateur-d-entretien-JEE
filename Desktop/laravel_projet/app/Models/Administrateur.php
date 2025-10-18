<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Administrateur extends Authenticatable
{
    use HasFactory;

    protected $table = 'administrateurs';
    protected $primaryKey = 'id_admin';
    public $timestamps = false;
    protected $fillable = ['nom', 'email', 'mot_de_passe'];

    // Pour que password_verify fonctionne
    public function getAuthPassword()
    {
        return $this->mot_de_passe;
    }
}