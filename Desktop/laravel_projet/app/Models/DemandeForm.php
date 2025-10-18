<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DemandeForm extends Model
{

    use HasFactory;

    protected $table = 'demandes';
    protected $primaryKey = 'id_demande';
    public $incrementing = true;

    // Si les timestamps ne sont pas utilisés
    public $timestamps = false;
    protected $fillable = [
        'id_etudiant', 'type_document','etat_demande','niveau_demande','lieu_stage',
        'encadrant_ecole', 'encadrant_entreprise', 'dure_stage',
        'sujet_stage', 'entreprise',
    ];

    public function etudiant()
    {
        return $this->belongsTo(Etudiants::class, 'id_etudiant');
    }

    
}
