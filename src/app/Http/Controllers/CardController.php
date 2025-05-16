<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\File;

class CardController extends Controller
{
    public function index(): JsonResponse
    {
        $path = storage_path('data/cards.json');

        if (!File::exists($path)) {
            return response()->json(['error' => 'Cards data file not found.'], 404);
        }

        $cards = collect(json_decode(File::get($path), true))
            ->take(3)
            ->values();

        return response()->json($cards);
    }
}