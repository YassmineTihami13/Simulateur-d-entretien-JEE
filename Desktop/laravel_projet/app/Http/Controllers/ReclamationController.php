<?php

namespace App\Http\Controllers;
use App\Models\Reclamation;
use Illuminate\Http\Request;
use PHPMailer\PHPMailer\PHPMailer;
use Illuminate\Support\Facades\Auth;
class ReclamationController extends Controller
{
    public function index()
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    $reclamations = Reclamation::where('etat_reclamation', 'En cours')
        ->with('etudiant')
        ->get();

    return view('reclamations', compact('reclamations'));
    }else{
        return to_route('login');
    }
}

public function update($id)
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    try {
        // Trouver la réclamation par ID
        $reclamation = Reclamation::findOrFail($id);

        // Exemple de mise à jour
        $reclamation->etat_reclamation = 'Traitée';
        // Ajustez en fonction de votre logique
        $reclamation->save();

        // Réponse JSON réussie
        return response()->json(['success' => true, 'message' => 'Réclamation mise à jour avec succès.']);
    } catch (\Exception $e) {
        // Log de l'erreur
        \Log::error($e->getMessage());

        // Réponse JSON avec erreur
        return response()->json(['success' => false, 'message' => 'Erreur lors de la mise à jour.'], 500);
    }
}else{
    return to_route('login');
}
}
public function reponse(request $request){
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
   
        $request->validate([
            'message' => 'required|string',
            'id_reclamation'=>'required|integer',
        ]);
        // Trouver la réclamation par ID
        $reclamation = Reclamation::findOrFail($request->id_reclamation);
        $etudiant = $reclamation->etudiant;
        
       
        $reclamation->message=$request->message;
        $reclamation->etat_reclamation = 'Traitée';
        $reclamation->save();

        // Envoyer l'e-mail avec PHPMailer
        $mail = new PHPMailer(true);

        try {
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = 'rr9444037@gmail.com';
            $mail->Password = 'ectl omzr ogjz moil'; // Utilisez les variables d'environnement dans un vrai projet
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
            $mail->Port = 465;

            $mail->setFrom('ENSATe@uae.ac.ma', 'ENSATe');
            $mail->addAddress($etudiant->email, $etudiant->nom . ' ' . $etudiant->prenom);
    

            $mail->isHTML(true);
            $mail->Subject = 'Votre demande';
            $mail->Body = '
                Cher etudiant<br><br>
                ' . $reclamation->message;
            $mail->send();
                
            

        } catch (Exception $e) {
            return back()->with('error', "Erreur d'envoi de l'email : {$mail->ErrorInfo}");
        }
        
        
        return to_route('reclam')->with('success','Réclamation mise à jour avec succès.');
    
}else{
    return to_route('login');
}
}
}