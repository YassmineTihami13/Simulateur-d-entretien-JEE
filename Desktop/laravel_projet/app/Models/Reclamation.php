<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;

use Illuminate\Database\Eloquent\Model;

class Reclamation extends Model
{
    // Spécifiez le nom de la table si différent du modèle
    protected $table = 'reclamations';

    // Clé primaire personnalisée si ce n'est pas "id"
    protected $primaryKey = 'id_reclamation';

    // Si la clé primaire n'est pas auto-incrémentée
    public $incrementing = true;

    // Si les timestamps ne sont pas utilisés
    public $timestamps = false;

    // Déclarez les champs pouvant être mis à jour
    protected $fillable = ['etat_reclamation','message'];
    public function etudiant()
{
    return $this->belongsTo(Etudiant::class, 'id_etudiant');
}
}
