<?php

namespace App\Http\Controllers;
use App\Models\ReclamForm;
use App\Models\Etudiants;
use Illuminate\Http\Request;

class ReclamFormController extends Controller
{
    public function index()
    {
        return view('reclamation');
    }
    public function store(Request $request)
{
    $request->validate([
        'nom' => 'required|string',
        'prenom' => 'required|string',
        'email' => 'required|email',
        'numero_apogee' => 'required|string',
        'reclamation' => 'required|string',
        
    ]);
    
    $etudiant = Etudiants::where([
        'nom' => $request->nom,
        'prenom' => $request->prenom,
        'email' => $request->email,
        'numero_apogee' => $request->numero_apogee,
    ])->first();

    
    if (!$etudiant) {
        return redirect()->back()->with('message', 'Champs invalides');
    }
    

    // Créez la demande avec Eloquent
    $reclamation = new ReclamForm([
        'id_etudiant'=> $etudiant->id_etudiant, 
        'contenu_reclamation' => $request->input('reclamation'),
        'etat_reclamation' => 'en cours',
        
    ]);
   
    
    if ($reclamation->save()) {
        return redirect()->back()->with('message', 'La reclamation a été enregistrée avec succès.');
    } else {
        return redirect()->back()->with('error', 'Échec de l\'enregistrement de la demande.');
    }
    

}

}
