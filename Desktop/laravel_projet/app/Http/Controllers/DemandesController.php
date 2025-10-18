<?php


namespace App\Http\Controllers;

use App\Models\DemandeForm;
use App\Models\Etudiants;
use Illuminate\Http\Request;

class DemandesController extends Controller
{
    public function index()
    {
        return view('demande');
    }
    public function store(Request $request)
{
    $request->validate([
        'nom' => 'required|string',
        'prenom' => 'required|string',
        'email' => 'required|email',
        'numero_apogee' => 'required|string',
        'CIN' => 'required|string',
        'type_document' => 'required|string',
        'niveau_demande' => 'nullable|string', // Peut être null
        'lieu_stage' => 'nullable|string', // Peut être null
        'encadrant_ecole' => 'nullable|string', // Peut être null
        'encadrant_entreprise' => 'nullable|string', // Peut être null
        'dure_stage' => 'nullable|integer', // Peut être null
        'sujet_stage' => 'nullable|string', // Peut être null
        'entreprise' => 'nullable|string', // Peut être null
    ]);
    
    $etudiant = Etudiants::where([
        'nom' => $request->nom,
        'prenom' => $request->prenom,
        'email' => $request->email,
        'CIN' => $request->CIN,
        'numero_apogee' => $request->numero_apogee,
    ])->first();

    
    if (!$etudiant) {
        return redirect()->back()->with('message', 'Champs invalides');

    }
    

    // Créez la demande avec Eloquent
    $demande = new DemandeForm([
        'id_etudiant'=> $etudiant->id_etudiant, 
        'type_document' => $request->input('type_document'),
        'etat_demande' => 'en cours',
        'niveau_demande' => $request->input('niveau_demande'),
        'lieu_stage' => $request->input('lieu_stage'),
        'encadrant_ecole' => $request->input('encadrant_ecole'),
        'encadrant_entreprise' => $request->input('encadrant_entreprise'),
        'dure_stage' => $request->input('dure_stage'),
        'sujet_stage' => $request->input('sujet_stage'),
        'entreprise' => $request->input('entreprise'),
    ]);
   
    
    if ($demande->save()) {
        return redirect()->back()->with('message', 'La demande a été enregistrée avec succès.');
    } else {
        return redirect()->back()->with('error', 'Échec de l\'enregistrement de la demande.');
    }
    

}

}
