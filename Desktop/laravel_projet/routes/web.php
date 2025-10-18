<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\DemandeController;
use App\Http\Controllers\ReclamationController;
use App\Http\Controllers\HistoriqueController;
use App\Http\Controllers\AcceuillController;
use App\Http\Controllers\DemandesController;
use App\Http\Controllers\ReclamFormController;

Route::get('/', function () {
    return view('welcome');
});
//routes de login
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login']);

//routes du dashboard
//Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
Route::get('/dashboard', [AuthController::class, 'dashboard'])->name('dashboard');


//route de l'acceuill
Route::get('/acceuill', [AcceuillController::class, 'index'])->name('acceuill');

//routes des demandes
Route::get('/demandes', [DemandeController::class, 'index'])->name('demandes');

//routes des réclamations
Route::get('/reclam', [ReclamationController::class, 'index'])->name('reclam');
Route::put('/reclamations/{id}', [ReclamationController::class, 'update']);
Route::post('/reponse', [ReclamationController::class, 'reponse'])->name('repo.reponse');

//routes des historiques
Route::get('/historique', [HistoriqueController::class, 'index'])->name('historique');

//route de déconnexion


//routes du formulaire des demandes


Route::get('/demande', [DemandesController::class, 'index'])->name('demande');
Route::post('/demande/store', [DemandesController::class, 'store'])->name('demande.store');


//routes du formulaire des réclamantions
Route::get('/reclamation', [ReclamFormController::class, 'index'])->name('reclamation');
Route::post('/reclamation/store', [ReclamFormController::class, 'store'])->name('reclamation.store');

//Reffuser une demande
Route::get('/demande/refuser/{id}', [DemandeController::class, 'envoyerEmail'])->name('demande.refuser');

//accepter une demande
Route::get('/demande/accepter/{id}', [DemandeController::class, 'accepter'])->name('demande.accepter');

//route pour visualiser le pdf du document accepté
Route::get('/view-pdf/{filename}', function ($filename) {
    $filePath = public_path("dossiertemp/$filename");
    if (file_exists($filePath)) {
        return response()->file($filePath);
    } else {
        abort(404);
    }
})->name('view-pdf');

//route pour la deconnexion
Route::get('/logout', [AuthController::class, 'logout'])->name('logout');
