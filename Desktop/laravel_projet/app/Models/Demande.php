<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Demande extends Model
{
    use HasFactory;

    
    protected $table = 'demandes';
    protected $primaryKey = 'id_demande'; // Spécifiez la clé primaire
    public $incrementing = true;
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = ['type_document', 'niveau_demande', 'etat_demande', 'id_etudiant'];

    
    public function etudiant()
    {
        return $this->belongsTo(Etudiant::class, 'id_etudiant');
    }
}
