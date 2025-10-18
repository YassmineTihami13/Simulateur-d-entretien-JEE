<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReclamForm extends Model
{
    use HasFactory;

    protected $table = 'reclamations';
    protected $primaryKey = 'id_reclamation';
    public $incrementing = true;

    // Si les timestamps ne sont pas utilisés
    public $timestamps = false;
    protected $fillable = [
        'id_etudiant','contenu_reclamation','etat_reclamation',
    ];

    public function etudiant()
    {
        return $this->belongsTo(Etudiants::class, 'id_etudiant');
    }
}
