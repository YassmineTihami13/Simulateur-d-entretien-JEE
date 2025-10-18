<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;

use Illuminate\Database\Eloquent\Model;

class Etudiants extends Model
{
    use HasFactory;

    protected $table = 'etudiants';
    protected $primaryKey = 'id_etudiant'; // Spécifiez la clé primaire
    
    protected $fillable = ['id_etudiant','nom', 'prenom', 'email', 'numero_apogee', 'CIN'];
    
    public function demandes()
    {
        return $this->hasMany(DemandeForm::class, 'id_etudiant');
    }
    public function reclamations()
    {
        return $this->hasMany(ReclamForm::class, 'id_etudiant');
    }
}
