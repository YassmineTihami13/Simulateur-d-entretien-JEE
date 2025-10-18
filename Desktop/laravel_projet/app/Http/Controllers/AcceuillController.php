<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AcceuillController extends Controller
{
    public function index()
    {
        return view('acceuill');
    }
}
