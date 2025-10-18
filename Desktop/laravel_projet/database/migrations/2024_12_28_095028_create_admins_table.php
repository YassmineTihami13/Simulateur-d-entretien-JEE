<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('admins', function (Blueprint $table) {
            $table->id(); // ID auto-incrémenté
            $table->string('nom'); // Champ pour le nom
            $table->string('email')->unique(); // Champ pour l'email avec contrainte d'unicité
            $table->string('password'); // Champ pour le mot de passe
            $table->timestamps(); // Champs created_at et updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('admins');
        
    }
};
