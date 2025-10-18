<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class HistoriqueController extends Controller
{
    public function index(Request $request)
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    // Valeurs par défaut pour les filtres
    $defaultDocuments = [
        "attestation de scolarité",
        "relevé de notes",
        "convention de stage",
        "attestation de réussite"
    ];

    $defaultStates = ["validée", "refusée"];

    // Récupérer les filtres de la requête
    $documentTypes = $request->input('document_types', []);
    $states = $request->input('states', []);
    

    // Construire la requête avec les filtres
    $query = DB::table('demandes')
    ->join('etudiants', 'demandes.id_etudiant', '=', 'etudiants.id_etudiant')
    ->select('demandes.*', 'etudiants.nom', 'etudiants.prenom');

    // Filtrer par type de document, si fourni
    if (!empty($documentTypes)) {
        $query->whereIn('demandes.type_document', $documentTypes);
    }

    // Filtrer par état (ou ajouter un filtre par défaut)
    if (!empty($states)) {
        $query->whereIn('demandes.etat_demande', $states);
    } else {
        $query->whereIn('demandes.etat_demande', $defaultStates);
    }

    $results = $query->get();

    return view('historique', compact('results', 'defaultDocuments', 'defaultStates', 'documentTypes', 'states'));
    }else{
        return to_route('login');
    }
}


}
