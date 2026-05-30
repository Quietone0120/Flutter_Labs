<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureUserHasRole
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next, $requiredRole)
    {
        // --- 5-р алхам: Query параметр шалгах (/admin?role=...) ---
        if ($request->is('admin')) {
            $userRole = $request->query('role');

            if (!$userRole || $userRole !== $requiredRole) {
                // accessdenied руу чиглүүлнэ
                return redirect()->route('accessdenied');
            }
        }

        // --- 6-р алхам: URL параметр шалгах (/admin/{role}?role=...) ---
        if ($request->is('admin/*')) {
            $routeRole = $request->route('role');   // {role} параметр
            $queryRole = $request->query('role');   // ?role=... query

            if (!$queryRole || $queryRole !== $requiredRole || $routeRole !== $requiredRole) {
                // зөвшөөрөгдөөгүй бол 403 буцаана
                abort(403, 'Forbidden');
            }
        }

        return $next($request);
    }
}
