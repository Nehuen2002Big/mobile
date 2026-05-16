import 'dart:math' as math;

/// Distancia en metros entre dos puntos (lat,lon) usando la formula de
/// Haversine sobre una esfera de radio 6371 km. Suficiente para distancias
/// operativas; el error vs geodesica sobre el elipsoide WGS84 es < 0.5%.
double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final phi1 = lat1 * math.pi / 180;
  final phi2 = lat2 * math.pi / 180;
  final dphi = (lat2 - lat1) * math.pi / 180;
  final dlambda = (lon2 - lon1) * math.pi / 180;
  final a = math.sin(dphi / 2) * math.sin(dphi / 2) +
      math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) * math.sin(dlambda / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

/// Resultado de proyectar un punto sobre una polyline:
/// - [segmentIndex]: indice del segmento `[i, i+1]` mas cercano dentro
///   de la lista de coordenadas. `0` si el polyline tiene 0 o 1 puntos.
/// - [projLat] / [projLon]: punto sobre el polyline mas cercano al
///   punto de entrada. Si la polyline esta vacia, devuelve el input.
/// - [distM]: distancia en metros entre el punto de entrada y la
///   proyeccion. Sirve para auto-reroute (MC-021): si supera el
///   threshold (50 m) por mas de N segundos, recomputamos.
class ProjectionOnPolyline {
  const ProjectionOnPolyline({
    required this.segmentIndex,
    required this.projLat,
    required this.projLon,
    required this.distM,
  });

  final int segmentIndex;
  final double projLat;
  final double projLon;
  final double distM;
}

/// Proyecta `(lat, lon)` sobre una polyline `coords` formateada como
/// GeoJSON: lista de `[lon, lat]`. Devuelve el segmento mas cercano,
/// la proyeccion exacta y la distancia.
///
/// Implementacion: por cada segmento, proyectamos en un plano
/// equirectangular local (aproximacion valida a distancias <100 km
/// con error <0.5%). Convertimos lat/lon → metros relativos al primer
/// punto del segmento, hacemos proyeccion escalar 2D, y reconvertimos
/// la proyeccion a lat/lon.
///
/// **Performance**: O(n) sobre los segmentos. Para polylines tipicas
/// de viajes (cientos a miles de puntos) es <1 ms en mobile.
ProjectionOnPolyline projectOnPolyline({
  required double lat,
  required double lon,
  required List<List<double>> coords,
}) {
  if (coords.isEmpty) {
    return ProjectionOnPolyline(
      segmentIndex: 0,
      projLat: lat,
      projLon: lon,
      distM: 0,
    );
  }
  if (coords.length == 1) {
    final p = coords[0];
    final pLon = p[0];
    final pLat = p[1];
    return ProjectionOnPolyline(
      segmentIndex: 0,
      projLat: pLat,
      projLon: pLon,
      distM: haversineMeters(lat, lon, pLat, pLon),
    );
  }

  var bestDist = double.infinity;
  var bestIdx = 0;
  var bestLat = coords[0][1];
  var bestLon = coords[0][0];

  for (var i = 0; i < coords.length - 1; i++) {
    final a = coords[i];
    final b = coords[i + 1];
    if (a.length < 2 || b.length < 2) continue;
    final aLon = a[0], aLat = a[1];
    final bLon = b[0], bLat = b[1];

    // Conversion local a metros usando equirectangular alrededor del
    // segmento. Origen = a; eje x = este (lon), eje y = norte (lat).
    final phiRad = aLat * math.pi / 180;
    final mPerDegLat = 111132.0;
    final mPerDegLon = 111132.0 * math.cos(phiRad);
    final ax = 0.0, ay = 0.0;
    final bx = (bLon - aLon) * mPerDegLon;
    final by = (bLat - aLat) * mPerDegLat;
    final px = (lon - aLon) * mPerDegLon;
    final py = (lat - aLat) * mPerDegLat;

    final dx = bx - ax;
    final dy = by - ay;
    final segLenSq = dx * dx + dy * dy;
    double t;
    if (segLenSq < 1e-9) {
      // Segmento degenerado (a==b): proyeccion = a.
      t = 0;
    } else {
      t = ((px - ax) * dx + (py - ay) * dy) / segLenSq;
      if (t < 0) {
        t = 0;
      } else if (t > 1) {
        t = 1;
      }
    }
    final projXm = ax + t * dx;
    final projYm = ay + t * dy;
    // Reconvertir a lat/lon.
    final projLatI = aLat + projYm / mPerDegLat;
    final projLonI =
        mPerDegLon == 0 ? aLon : aLon + projXm / mPerDegLon;
    final distI = haversineMeters(lat, lon, projLatI, projLonI);
    if (distI < bestDist) {
      bestDist = distI;
      bestIdx = i;
      bestLat = projLatI;
      bestLon = projLonI;
    }
  }

  return ProjectionOnPolyline(
    segmentIndex: bestIdx,
    projLat: bestLat,
    projLon: bestLon,
    distM: bestDist,
  );
}
