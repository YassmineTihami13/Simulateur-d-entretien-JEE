<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    

    public function index()
    {
       
        $data = [
            'total_etudiants' => DB::table('etudiants')->count(),
            'total_etudiants_info' => DB::table('etudiants')->where('filiere', 'Genie informatique')->count(),
            'total_etudiants_gscm' => DB::table('etudiants')->where('filiere', 'GSCM')->count(),
            'total_etudiants_2ap' => DB::table('etudiants')->whereIn('filiere', ['2AP1', '2AP2'])->count(),
            'total_demandes' => DB::table('demandes')->count(),
            'demandes_traitees' => DB::table('demandes')->where('etat_demande', 'Validée')->count(),
            'demandes_en_cours' => DB::table('demandes')->where('etat_demande', 'En cours')->count(),
            'total_reclamations' => DB::table('reclamations')->count(),
            'reclamations_traitees' => DB::table('reclamations')->where('etat_reclamation', 'Traitée')->count(),
            'total_relevee' => DB::table('demandes')->where('type_document', 'Relevé de notes')->count(),
            'total_att1' => DB::table('demandes')->where('type_document', 'Attestation de réussite')->count(),
            'total_att2' => DB::table('demandes')->where('type_document', 'Attestation de scolarité')->count(),
            'total_att3' => DB::table('demandes')->where('type_document', 'Convention de stage')->count(),
            'admins' => DB::table('admins')->get()
        ];

        $data['pourcentage_demandes_traitees'] = $data['total_demandes'] > 0 ? round(($data['demandes_traitees'] / $data['total_demandes']) * 100, 2) : 0;
        $data['pourcentage_demandes_en_cours'] = $data['total_demandes'] > 0 ? round(($data['demandes_en_cours'] / $data['total_demandes']) * 100, 2) : 0;
        $data['pourcentage_reclamations_traitees'] = $data['total_reclamations'] > 0 ? round(($data['reclamations_traitees'] / $data['total_reclamations']) * 100, 2) : 0;

        return view('dashboard', $data);
    }
    
}

class ReclamationController extends Controller
{
    public function index()
    {
        return view('reclamations'); // Vue pour les réclamations
    }
}

class HistoriqueController extends Controller
{
    public function index()
    {
        return view('historique'); // Vue pour l'historique
    }
}

class ServiceController extends Controller
{
    public function index()
    {
        return view('services'); // Vue pour les services
    }
}