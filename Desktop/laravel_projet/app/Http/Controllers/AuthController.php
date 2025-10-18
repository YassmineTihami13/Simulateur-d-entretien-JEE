<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\Administrateur;
use App\Models\admin;
use Illuminate\Support\Facades\Auth;


class AuthController extends Controller
{
    public function showLoginForm()
    {
        return view('auth.login');
    }


    
public function login(Request $request)
{
    // Validate inputs
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|min:6',
    ]);
  
    
    $credentials = ['email'=>$request->email,'password'=>$request->password];

    // Attempt to authenticate
    if (Auth::attempt($credentials)) {
        $request->session()->regenerate();
        return redirect()->intended('dashboard')->with($request->email);
    }

    return back()->withErrors([
        'email' => 'The provided credentials do not match our records.',
    ]);
}
public function dashboard()
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    
    $admins = admin::all(); // Exemple de données pour la vue
   
    
    
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
            'admins' => DB::table('admins')->get(),
            'email' => Auth::user()->nom
        ];

        $data['pourcentage_demandes_traitees'] = $data['total_demandes'] > 0 ? round(($data['demandes_traitees'] / $data['total_demandes']) * 100, 2) : 0;
        $data['pourcentage_demandes_en_cours'] = $data['total_demandes'] > 0 ? round(($data['demandes_en_cours'] / $data['total_demandes']) * 100, 2) : 0;
        $data['pourcentage_reclamations_traitees'] = $data['total_reclamations'] > 0 ? round(($data['reclamations_traitees'] / $data['total_reclamations']) * 100, 2) : 0;

        return view('dashboard', $data);
    }else{
        return to_route('login');
    }
}
public function logout()
{
Session::flush();
Auth::logout();
return to_route('login')->with('success','vous etes déconnecté');
}
    
}
