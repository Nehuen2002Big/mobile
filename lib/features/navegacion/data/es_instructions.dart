import '../models/trip_navigation.dart';

/// Traduce una NavigationManeuver al texto del banner. El backend ya
/// entrega `instruction_es` listo, pero este fallback se usa por si el
/// payload llega con instruccion vacia.
String instruccionEsFallback({
  required NavigationManeuver maneuver,
  String? calle,
}) {
  final type = maneuver.type;
  final mod = maneuver.modifier ?? '';
  switch (type) {
    case 'depart':
      return calle != null && calle.isNotEmpty
          ? 'Arrancá por $calle'
          : 'Arrancá';
    case 'arrive':
      if (mod == 'left') return 'Llegaste (a tu izquierda)';
      if (mod == 'right') return 'Llegaste (a tu derecha)';
      return 'Llegaste al destino';
    case 'roundabout':
    case 'rotary':
      final exit = maneuver.exit;
      if (exit != null) {
        return 'En la rotonda, tomá la ${_ord(exit)} salida';
      }
      return 'Seguí por la rotonda';
    case 'merge':
      return 'Incorporate al tránsito';
    case 'on ramp':
      return 'Tomá la rampa';
    case 'off ramp':
      return 'Salí por la rampa';
    case 'end of road':
      return 'Al final de la calle, girá ${_dir(mod)}';
    case 'fork':
      return 'Tomá la bifurcación ${_dir(mod)}';
    case 'continue':
    case 'new name':
      return calle != null && calle.isNotEmpty
          ? 'Seguí por $calle'
          : 'Seguí recto';
    case 'turn':
      return calle != null && calle.isNotEmpty
          ? 'Girá ${_dir(mod)} en $calle'
          : 'Girá ${_dir(mod)}';
    default:
      return 'Seguí';
  }
}

String _dir(String m) {
  switch (m) {
    case 'left':
      return 'a la izquierda';
    case 'right':
      return 'a la derecha';
    case 'slight left':
      return 'levemente a la izquierda';
    case 'slight right':
      return 'levemente a la derecha';
    case 'sharp left':
      return 'fuertemente a la izquierda';
    case 'sharp right':
      return 'fuertemente a la derecha';
    case 'uturn':
      return 'en U';
    case 'straight':
      return 'recto';
    default:
      return '';
  }
}

String _ord(int n) {
  switch (n) {
    case 1:
      return 'primera';
    case 2:
      return 'segunda';
    case 3:
      return 'tercera';
    case 4:
      return 'cuarta';
    case 5:
      return 'quinta';
    default:
      return '${n}ª';
  }
}

/// Devuelve el icono apropiado para la maniobra. La UI lo mappea a IconData.
IconKey iconoManiobra(NavigationManeuver? m) {
  if (m == null) return IconKey.arrowUpward;
  switch (m.type) {
    case 'arrive':
      return IconKey.flag;
    case 'roundabout':
    case 'rotary':
      return IconKey.roundaboutRight;
    case 'merge':
      return IconKey.merge;
    case 'on ramp':
    case 'off ramp':
      return IconKey.forkRight;
    case 'end of road':
    case 'fork':
    case 'turn':
      return _byModifier(m.modifier);
    case 'continue':
    case 'new name':
    case 'depart':
      return IconKey.arrowUpward;
    default:
      return _byModifier(m.modifier);
  }
}

IconKey _byModifier(String? mod) {
  switch (mod) {
    case 'left':
      return IconKey.turnLeft;
    case 'right':
      return IconKey.turnRight;
    case 'slight left':
      return IconKey.turnSlightLeft;
    case 'slight right':
      return IconKey.turnSlightRight;
    case 'sharp left':
      return IconKey.turnSharpLeft;
    case 'sharp right':
      return IconKey.turnSharpRight;
    case 'uturn':
      return IconKey.uTurnLeft;
    case 'straight':
      return IconKey.arrowUpward;
    default:
      return IconKey.arrowUpward;
  }
}

enum IconKey {
  arrowUpward,
  turnLeft,
  turnRight,
  turnSlightLeft,
  turnSlightRight,
  turnSharpLeft,
  turnSharpRight,
  uTurnLeft,
  roundaboutRight,
  forkRight,
  merge,
  flag,
}
