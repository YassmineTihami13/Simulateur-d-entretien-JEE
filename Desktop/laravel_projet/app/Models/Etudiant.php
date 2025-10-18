<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Etudiant extends Model
{
    use HasFactory;

    protected $table = 'etudiants';
    protected $primaryKey = 'id_etudiant'; // Spécifiez la clé primaire
    public $incrementing = true; // Indique si la clé est auto-incrémentée
    protected $keyType = 'int'; 

    protected $fillable = ['nom', 'prenom', 'numero_apogee', 'filiere', 'niveau_validé', 'email','CIN'];

    public function demandes()
    {
        return $this->hasMany(Demande::class, 'id_etudiant');
    }
    public function reclamations()
    {
        return $this->hasMany(Reclamation::class, 'id_etudiant'); // Remplacez `id_etudiant` si nécessaire
    }
}
