<?php
namespace App\Http\Controllers;

use App\Models\Demande;
use Illuminate\Http\Request;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;


class DemandeController extends Controller
{
    protected $table = 'demandes'; // Nom de la table dans la base de données

    public $timestamps = false;

    public function etudiant()
    {
        return $this->belongsTo(Etudiant::class, 'id_etudiant');
    }
    public function index()
    {
        if (Auth::check()) {
            $email = Auth::user()->email;
    
            // Vérifie si l'email est vide
            if (empty($email)) {
                return to_route('login')->with('error', 'Veuillez vous reconnecter.');
            }
        // Récupérer les demandes "En cours" avec leurs étudiants associés
        $demandes = Demande::with('etudiant')
            ->where('etat_demande', 'En cours')
            ->get();

        return view('demandes', compact('demandes'));
        }else{
            return to_route('login');
        }
    }

    public function envoyerEmail($id)
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    $demande = Demande::find($id);

    if (!$demande) {
        return redirect()->back()->with('error', 'Demande introuvable.');
    }

    $mail = new PHPMailer(true);

    try {
        // Configurations du serveur SMTP
        $mail->isSMTP();                                            
    $mail->Host       = 'smtp.gmail.com';                    
    $mail->SMTPAuth   = true;                                   
    $mail->Username   = 'rr9444037@gmail.com';                    
    $mail->Password   = 'ectl omzr ogjz moil';                              
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            
    $mail->Port       = 465;    

    $demande->etat_demande = 'Refusée';
    $demande->save();
        // Destinataire(s)
        $mail->setFrom($mail->Username, 'Service Administratif');
        $mail->addAddress($demande->etudiant->email, $demande->etudiant->nom . ' ' . $demande->etudiant->prenom);

        // Contenu de l'email
        $mail->isHTML(true);
        $mail->Subject = 'Refus de votre demande';
        $mail->Body = "
            <p>Bonjour {$demande->etudiant->nom},</p>
            <p>Nous vous informons que votre demande du document {$demande->type_document},( {$demande->entreprise}) {$demande->niveau_demande} a été refusée.</p>
            <p>Veuillez nous contacter pour plus d'informations.</p>
            <p>Cordialement,</p>
            <p>Service Administratif</p>
        ";

        $mail->send();

        return redirect()->route('demandes')->with('success', 'E-mail envoyé avec succès.');
    } catch (Exception $e) {
        return redirect()->back()->with('error', "Erreur lors de l'envoi de l'e-mail : {$mail->ErrorInfo}");
    }
}else{
    return to_route('login');
}
}

public function accepter($id)
{
    if (Auth::check()) {
        $email = Auth::user()->email;

        // Vérifie si l'email est vide
        if (empty($email)) {
            return to_route('login')->with('error', 'Veuillez vous reconnecter.');
        }
    $demande = Demande::findOrFail($id);
    $etudiant = $demande->etudiant;

    $demande->etat_demande = 'Validée';
    $demande->save();
    // Initialiser les variables nécessaires
    $nom_prenom = $etudiant->nom . ' ' . $etudiant->prenom;
    $cin = $etudiant->cin;
    $numero_apogee = $etudiant->numero_apogee;
    $email = $etudiant->email;
    $date_naissance = $etudiant->date_naissance;
    $lieu_naissance = $etudiant->lieu_naissance;
    $annee_scolaire = date('Y') . '/' . (date('Y') + 1);
    $filiere = $etudiant->filiere;

    require_once base_path('vendor/setasign/fpdf/fpdf.php');

    // Créer un nouveau PDF
    $pdf = new \FPDF('P', 'mm', 'A4');
    $pdf->AddPage();
    $pdf->SetFont('Arial', 'B', 16);

    // Ajouter l'image de l'en-tête
    $pdf->Image(public_path('en-tete.png'), 0, 0, 210);
    $pdf->Ln(40);

    // Générer le contenu si le type de document est correct
if ($demande->type_document === 'Attestation de scolarité') {
        $pdf->Cell(0, 10, "ATTESTATION DE SCOLARITE", 0, 1, 'C');
$pdf->Line(63, $pdf->GetY(), 147, $pdf->GetY()); // Dessiner une ligne horizontale sous le titre

$pdf->Ln(20);

// Contenu
$pdf->SetFont('Arial', '', 12);
$pdf->Write(7, "Le Direecteur de l'Ecole Nationale des Sciences Appliquees de Tetouan atteste que : \n\n");

$h = 7;
$retrait = "      ";
$pdf->Write($h, $retrait . "l'etudiant(e)  : ");
$pdf->SetFont('', 'BIU');
$pdf->Write($h, $nom_prenom . "\n");
$pdf->SetFont('Arial', '', 12);



$pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Numéro de la carte nationale :  $cin\n"));
$pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Numéro Apogée : $numero_apogee \n"));
$pdf->Write(7, "Email : $email \n");
$pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "née le  $date_naissance a $lieu_naissance \n"));
$pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Poursuit ses études a l'Ecole Nationale des Sciences Appliquées Tetouan pour l'annee universitaire  $annee_scolaire \n\n"));
$pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Filiére : $filiere\n"));
$pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Année : $annee_scolaire\n\n\n\n\n"));


// Signature et date
$pdf->Cell(0, 10, "Fait a TETOUAN, le " . date('d/m/Y'), 0, 1, 'C');
$pdf->Ln(10);
$pdf->Cell(0, 10, 'Le directeur', 0, 1, 'C');
}elseif ($demande->type_document == 'Attestation de réussite') {
    

        $pdf->Cell(0, 10, "ATTESTATION DE REUSSITE", 0, 1, 'C');
        $pdf->Line(63, $pdf->GetY(), 147, $pdf->GetY()); // Dessiner une ligne horizontale sous le titre
        
        $pdf->Ln(20);
        
        // Contenu
        
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Le Directeur de l'Ecole Nationale des Sciences Appliquées de Tétouan atteste que : \n\n"));
        
        $h = 7;
        $retrait = "      ";
        $pdf->Write($h, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',$retrait . "l'étudiant(e)  : "));
        $pdf->SetFont('', 'BIU');
        $pdf->Write($h, $nom_prenom . "\n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "née le  $date_naissance a $lieu_naissance \n"));
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "a été declaré admise au niveau  \n"));
        $pdf->Write(7, "$demande->niveau_valide\n");
        $annee=($demande->annee_valide)-1;
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"au titre de l'année universitaire $annee - $demande->annee_valide  \n"));
    
    
    
        $pdf->Cell(0, 10, "Fait a TETOUAN, le " . date('d/m/Y'), 0, 1, 'C');
        $pdf->Ln(10);
        $pdf->Cell(0, 10, 'Le directeur', 0, 1, 'C');
        $pdf->Cell(0, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "N étudiant: $numero_apogee"), 0, 1, 'C');
    
      }elseif ($demande->type_document == 'Convention de stage') {//arrete ici

        $pdf->Cell(0, 10, "CONVENTION DE STAGE ", 0, 1, 'C');
        $pdf->Line(63, $pdf->GetY(), 147, $pdf->GetY()); // Dessiner une ligne horizontale sous le titre
        
        $pdf->Ln(20);
        $h = 7;
        // Contenu
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, "Entre : \n");
        $h = 7;
        $retrait = "       ";
        $pdf->Write($h, $retrait . "d'une part : \n");
        $h = 7;
        $retrait = "          ";
        $pdf->Write($h, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',$retrait . "L'Ecole National des Sciences Appliquees Tetouan \n"));
        $pdf->Write(7, "Adresse : M'Hannech 2 B.P 2222 Tetouan \n");
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Téléphone : 0539968802\n"));
        $pdf->Write(7, "Fax: 0539994624\n");
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Representé par : $demande->encadrant_ecole\n\n"));
       
        $h = 7;
        $retrait = "       ";
        $pdf->Write($h, $retrait . "d'autre part : \n");
        $h = 7;
        $retrait = "        ";
        $pdf->Write($h, $retrait . "Nom : $demande->entreprise\n");
        $pdf->Write(7, "Adresse : $demande->lieu_stage \n");
      
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Representé par :$demande->encadrant_entreprise\n"));
        $pdf->Write(7, "Elle concerne  :\n");
        $h = 7;
        $pdf->Write($h, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"L'étudiant(e)  : "));
        $pdf->Write($h, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "l'étudiant(e)  : "));
        $pdf->SetFont('', 'BIU');
        $pdf->Write($h, $nom_prenom . "\n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, "CIN : $cin\n");
        $pdf->Write(7, "Email : $email \n");
     
        $pdf->SetFont('Arial', '', 12);
    
    
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
    
        $pdf->Write(7, "Article 1 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "La presente convention a pour objet de definir les modalites du stage effectue par l'etudiant au sein de l'entreprise ou organisation d'accueil. \n"));
        
    
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        $pdf->Write(7, "Article 2 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Le programme du stage est élaboré par le personnel chargé de l'encadrement du stagiaire, en tenant compte du programme et de spécialité des études du stagiaire, ainsi que des moyens humain et matériel de l'enteprise. Cette dernière se réserve le droit de réorienter l'apprentissage en fonction des qualifications du stagiaire et du rythme de ses activités professionnelles.\n"));
    
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        
        $pdf->Write(7, "Article 3 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Pendant le stage, le stagiaire est soumis aux usages et règlements de l'entreprise, notamment en matière de discipline et des horaires. En cas de manquement à ces règles, l'entreprise se réserve le droit de mettre fin au stage, après avoir prévenullétablissement de formation.\n"));
        
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
      
        $pdf->Write(7, "Article 4 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Au terme de son stage, le stagiaire remettra un rapport de stage à l'entreprise si réclamé par celle-ci.\n"));
    
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        $pdf->Write(7, "Article 5 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Le stagiaire s'engage à garder confidentielle toute information recueillie dans l'entreprise, et à n'utiliser en aucun cas ces informations pour faire l'objet d'une publication, communication à des tiers,conférences, sans l'accord préalable de l'entreprise.\n"));
       
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        $pdf->Write(7, "Article 6 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Le stagiaire est tenu de souscrire une assurance pour la garantir contre les risques d'accident ou d'incident auxquels le stagiaire pourrait être exposé durant la période de son stage.\n"));
        
        
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        $pdf->Write(7, "Article 7 :  \n");
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7,iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "En cas de non-respect de l'une des clauses de cette convention aussi bien par le stagiaire, l'entreprise se réserve le droit de mettre fin à ce stage.\n"));
        
        $pdf->SetFont('Arial', 'B', 12); // Gras (B) et taille 12
        $pdf->SetTextColor(0, 0, 0); //noir
        $pdf->Write(7, "Article 8 :  \n");
    
        $pdf->SetFont('Arial', '', 12);
        $pdf->Write(7, iconv('UTF-8', 'ISO-8859-1//TRANSLIT',"Le stage se déroulera du ... au ... \n"));
       
        
        
        $pdf->Cell(0, 10, "Fait a TETOUAN, le " . date('d/m/Y'), 0, 1, 'C');
        $pdf->Ln(10);
        $pdf->Cell(0, 10, 'Le directeur', 0, 1, 'C');
        $pdf->Cell(0, 10, "N etudiant: $numero_apogee", 0, 1, 'D');
    
        $pdfFile = 'dossiertemp/attestation.pdf';
        $pdf->Output('F', $pdfFile); 
        }elseif ($demande->type_document == 'Relevé de notes') {
            $pdf->SetFont('Arial', 'B', 16);
            $pdf->Cell(0, 10, "RELEVE DE NOTES", 0, 1, 'C');
            $pdf->Line(63, $pdf->GetY(), 147, $pdf->GetY()); // Ligne horizontale sous le titre
            $pdf->Ln(10);

            // Informations sur l'étudiant
            $pdf->SetFont('Arial', '', 12);
            $h = 7;
            $pdf->Write($h, "L'etudiant(e) : ");
            $pdf->SetFont('', 'BIU');
            $pdf->Write($h, $nom_prenom . "\n");
            $pdf->SetFont('Arial', '', 12);
            $pdf->Write($h, "Numero Apogee : $numero_apogee\n");
            $pdf->Write($h, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', "Niveau du relevé de note : ") . $demande->niveau_demande . "\n");
            $pdf->Ln(5);


    
    // En-tête du tableau
            $ap1 = DB::table('2AP1')->whereIn('id_etudiant', [$demande->id_etudiant])->get()->toArray();
            $ap2 = DB::table('2AP2')->whereIn('id_etudiant', [$demande->id_etudiant])->get()->toArray();
            $genie_informatique = DB::table('genie_informatique')->whereIn('id_etudiant', [$demande->id_etudiant])->get()->toArray();
            $gscm = DB::table('gscm')->whereIn('id_etudiant', [$demande->id_etudiant])->get()->toArray();


            if (strtolower(trim($demande->niveau_demande)) === '2ap1') {
                if (!empty($ap1)) {
                    $columns = $ap1[0];
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    foreach ($columns as $colonne => $valeur) {
                        if (empty($valeur) && $valeur !== 0) {
                            $colonne_vide = true;
                            break;
                        }
                        if ($colonne != 'id_etudiant') {
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
        
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
                    }
        
                    if ($nombre_notes > 0) {
                        $moyenne = $total_notes / $nombre_notes;
                        $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                        $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                    } else {
                        $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                    }
                } else {
                    $pdf->Cell(160, 10, 'Aucune donnée disponible pour 2AP1.', 1, 1, 'C');
                }
        }elseif(strtolower(trim($demande->niveau_demande)) === '2pa2'){
            if (!empty($ap2)) {
                $columns = $ap2[0];
                $colonne_vide = false;
                $total_notes = 0;
                $nombre_notes = 0;
    
                foreach ($columns as $colonne => $valeur) {
                    if (empty($valeur) && $valeur !== 0) {
                        $colonne_vide = true;
                        break;
                    }
                    if ($colonne != 'id_etudiant') {
                        $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                        $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
    
                        if (is_numeric($valeur)) {
                            $total_notes += $valeur;
                            $nombre_notes++;
                        }
                    }
                }
    
                if ($nombre_notes > 0) {
                    $moyenne = $total_notes / $nombre_notes;
                    $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                    $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                } else {
                    $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                }
            } else {
                $pdf->Cell(160, 10, 'Aucune donnée disponible pour 2AP1.', 1, 1, 'C');
            }

        }elseif(strtolower(trim($demande->niveau_demande)) === 'ci1'){
            if($etudiant->filiere==='Genie informatique'){
                if (!empty($genie_informatique)) {
                    $columns = $genie_informatique[0];
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    foreach ($columns as $colonne => $valeur) {
                        if ((empty($valeur) && $valeur !== 0) || $colonne=='Modelisation_Programmation_Objet') {
                            $colonne_vide = true;
                            break;  // Sortir de la boucle dès qu'une colonne est vide
                        }
                        if ($colonne != 'id_etudiant') {  // Ignore l'ID de l'étudiant s'il existe dans les colonnes
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
                            
                            // Accumuler les notes si la colonne contient des valeurs numériques
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
                    }
        
                    if ($nombre_notes > 0) {
                        $moyenne = $total_notes / $nombre_notes;
                        $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                        $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                    } else {
                        $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                    }
                } else {
                    $pdf->Cell(160, 10, 'Aucune donnée disponible pour 2AP1.', 1, 1, 'C');
                }
            }elseif($etudiant->filiere==='GSCM'){
                if (!empty($genie_informatique)) {
                    $columns = $genie_informatique[0];
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    foreach ($columns as $colonne => $valeur) {
                        if ((empty($valeur) && $valeur !== 0) || $colonne=='Modelisation_Programmation_Objet') {
                            $colonne_vide = true;
                            break;  // Sortir de la boucle dès qu'une colonne est vide
                        }
                        if ($colonne != 'id_etudiant') {  // Ignore l'ID de l'étudiant s'il existe dans les colonnes
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
                            
                            // Accumuler les notes si la colonne contient des valeurs numériques
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
                    }
        
                    if ($nombre_notes > 0) {
                        $moyenne = $total_notes / $nombre_notes;
                        $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                        $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                    } else {
                        $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                    }
                } else {
                    $pdf->Cell(160, 10, 'Aucune donnée disponible pour 2AP1.', 1, 1, 'C');
                }
            }

        }elseif (strtolower(trim($demande->niveau_demande)) === 'ci2') {
            if ($etudiant->filiere === 'Genie informatique') {
                if (!empty($genie_informatique)) {
                    $columns = array_keys((array)$genie_informatique[0]);
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    $debut_colonne = 'Modelisation_Programmation_Objet';
                    $fin_colonne = 'BD_Relationnelle_Objet_Repartie';
                    $selectionner = false;
                    $colonnes_selectionnees = [];
        
                    // Filtrer les colonnes entre les limites spécifiées
                    foreach ($columns as $colonne) {
                        $colonne = trim($colonne); // Nettoie les espaces
                        if (strcasecmp($colonne, $debut_colonne) == 0) {
                            $selectionner = true; // Début de la sélection
                        }
                        if ($selectionner) {
                            $colonnes_selectionnees[] = $colonne;
                        }
                        if (strcasecmp($colonne, $fin_colonne) == 0) {
                            break; // Arrêter après la dernière colonne
                        }
                    }
        
                    // Récupérer les données pour les colonnes sélectionnées
                    $donnees = DB::table('genie_informatique')
                        ->select($colonnes_selectionnees)
                        ->where('id_etudiant', $demande->id_etudiant)
                        ->first();
        
                    // Afficher les résultats dans le PDF
                    if ($donnees) {
                        $donnees = (array)$donnees; // Convertir en tableau associatif
        
                        foreach ($donnees as $colonne => $valeur) {
                            if (empty($valeur) && $valeur !== 0) {
                                $colonne_vide = true;
                                break;
                            }
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
        
                            // Calcul des notes
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
        
                        if ($nombre_notes > 0) {
                            $moyenne = $total_notes / $nombre_notes;
                            $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                            $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                        } else {
                            $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                        }
                    } else {
                        $pdf->Cell(160, 10, 'Aucune donnée disponible pour CI2.', 1, 1, 'C');
                    }
                }
            }else if($etudiant->filiere==='GSCM'){
                if (!empty($gscm)) {
                    $columns = array_keys((array)$gscm[0]);
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    $debut_colonne = 'Modelisation_Programmation_Objet';
                    $fin_colonne = 'Theorie_Decision_GSI';
                    $selectionner = false;
                    $colonnes_selectionnees = [];
        
                    // Filtrer les colonnes entre les limites spécifiées
                    foreach ($columns as $colonne) {
                        $colonne = trim($colonne); // Nettoie les espaces
                        if (strcasecmp($colonne, $debut_colonne) == 0) {
                            $selectionner = true; // Début de la sélection
                        }
                        if ($selectionner) {
                            $colonnes_selectionnees[] = $colonne;
                        }
                        if (strcasecmp($colonne, $fin_colonne) == 0) {
                            break; // Arrêter après la dernière colonne
                        }
                    }
        
                    // Récupérer les données pour les colonnes sélectionnées
                    $donnees = DB::table('gscm')
                        ->select($colonnes_selectionnees)
                        ->where('id_etudiant', $demande->id_etudiant)
                        ->first();
        
                    // Afficher les résultats dans le PDF
                    if ($donnees) {
                        $donnees = (array)$donnees; // Convertir en tableau associatif
        
                        foreach ($donnees as $colonne => $valeur) {
                            if (empty($valeur) && $valeur !== 0) {
                                $colonne_vide = true;
                                break;
                            }
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
        
                            // Calcul des notes
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
        
                        if ($nombre_notes > 0) {
                            $moyenne = $total_notes / $nombre_notes;
                            $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                            $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                        } else {
                            $pdf->Cell(160, 10, 'Aucun module trouvé.', 1, 1, 'C');
                        }
                    } else {
                        $pdf->Cell(160, 10, 'Aucune donnée disponible pour CI2.', 1, 1, 'C');
                    }
                }
            }
            
        }elseif (strtolower(trim($demande->niveau_demande)) === 'ci3'){
            if ($etudiant->filiere === 'Genie informatique') {
                if (!empty($genie_informatique)) {
                    $columns = array_keys((array)$genie_informatique[0]);
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    $debut_colonne = 'Systemes_Integration_Progiciel';
                    $fin_colonne = 'Management_III';
                    $selectionner = false;
                    $colonnes_selectionnees = [];
        
                    // Filtrer les colonnes entre les limites spécifiées
                    foreach ($columns as $colonne) {
                        $colonne = trim($colonne); // Nettoie les espaces
                        if (strcasecmp($colonne, $debut_colonne) == 0) {
                            $selectionner = true; // Début de la sélection
                        }
                        if ($selectionner) {
                            $colonnes_selectionnees[] = $colonne;
                        }
                        if (strcasecmp($colonne, $fin_colonne) == 0) {
                            break; // Arrêter après la dernière colonne
                        }
                    }
        
                    // Récupérer les données pour les colonnes sélectionnées
                    $donnees = DB::table('genie_informatique')
                        ->select($colonnes_selectionnees)
                        ->where('id_etudiant', $demande->id_etudiant)
                        ->first();
        
                    // Afficher les résultats dans le PDF
                    if ($donnees) {
                        $donnees = (array)$donnees; // Convertir en tableau associatif
        
                        foreach ($donnees as $colonne => $valeur) {
                            if (empty($valeur) && $valeur !== 0) {
                                $colonne_vide = true;
                                break;
                            }
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
        
                            // Calcul des notes
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
        
                        if ($nombre_notes > 0) {
                            $moyenne = $total_notes / $nombre_notes;
                            $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                            $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                        } else {
                            $pdf->Cell(160, 10, 'Aucune note.', 1, 1, 'C');
                        }
                    } else {
                        $pdf->Cell(160, 10, 'Aucune donnée disponible pour CI2.', 1, 1, 'C');
                    }
                }
            }else if($etudiant->filiere==='GSCM'){
                if (!empty($gscm)) {
                    $columns = array_keys((array)$gscm[0]);
                    $colonne_vide = false;
                    $total_notes = 0;
                    $nombre_notes = 0;
        
                    $debut_colonne = 'Logistique_Distribution';
                    $fin_colonne = 'Langues_TEC_III';
                    $selectionner = false;
                    $colonnes_selectionnees = [];
        
                    // Filtrer les colonnes entre les limites spécifiées
                    foreach ($columns as $colonne) {
                        $colonne = trim($colonne); // Nettoie les espaces
                        if (strcasecmp($colonne, $debut_colonne) == 0) {
                            $selectionner = true; // Début de la sélection
                        }
                        if ($selectionner) {
                            $colonnes_selectionnees[] = $colonne;
                        }
                        if (strcasecmp($colonne, $fin_colonne) == 0) {
                            break; // Arrêter après la dernière colonne
                        }
                    }
        
                    // Récupérer les données pour les colonnes sélectionnées
                    $donnees = DB::table('gscm')
                        ->select($colonnes_selectionnees)
                        ->where('id_etudiant', $demande->id_etudiant)
                        ->first();
        
                    // Afficher les résultats dans le PDF
                    if ($donnees) {
                        $donnees = (array)$donnees; // Convertir en tableau associatif
        
                        foreach ($donnees as $colonne => $valeur) {
                            if (empty($valeur) && $valeur !== 0) {
                                $colonne_vide = true;
                                break;
                            }
                            $pdf->Cell(120, 10, iconv('UTF-8', 'ISO-8859-1//TRANSLIT', ucfirst(str_replace('_', ' ', $colonne))), 1, 0, 'C');
                            $pdf->Cell(40, 10, $valeur, 1, 1, 'C');
        
                            // Calcul des notes
                            if (is_numeric($valeur)) {
                                $total_notes += $valeur;
                                $nombre_notes++;
                            }
                        }
        
                        if ($nombre_notes > 0) {
                            $moyenne = $total_notes / $nombre_notes;
                            $pdf->Cell(120, 10, 'Moyenne', 1, 0, 'C');
                            $pdf->Cell(40, 10, number_format($moyenne, 2), 1, 1, 'C');
                        } else {
                            $pdf->Cell(160, 10, 'Aucune note.', 1, 1, 'C');
                        }
                    } else {
                        $pdf->Cell(160, 10, 'Aucune donnée disponible pour CI2.', 1, 1, 'C');
                    }
                }
            }
            
        }

        }

    // Définir le chemin du fichier
    $filePath = public_path("dossiertemp/attestation.pdf");

    // Sauvegarder le PDF
    $pdf->Output('F', $filePath);

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
        $mail->addAttachment($filePath);

        $mail->isHTML(true);
        $mail->Subject = 'Votre demande';
        $mail->Body = '
            Bonjour,<br><br>
            Voici votre document demandé en pièce jointe.<br><br>
            Cordialement,<br>
            Service Administratif';
        $mail->send();
            
        return redirect()->route('view-pdf', ['filename' => 'attestation.pdf']);

    } catch (Exception $e) {
        return back()->with('error', "Erreur d'envoi de l'email : {$mail->ErrorInfo}");
    }




}else{
return to_route('login');
}
}
}
