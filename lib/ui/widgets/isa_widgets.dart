// IsaTech Fleet - Widgets reutilizables del design system
//
// Helpers Dart que portan los patrones visuales del system que no se
// modelan en `ThemeData`:
//
//   IsaStatusPill    - badges semanticos (ACTIVO / L2 / PENDIENTE / INFO)
//   IsaStatusDot     - indicadores 8x8 con glow
//   IsaTopoBackground - patron topografico de fondo (`.bg-topo`)
//   IsaGradientText  - texto con clip cyan->blue (`.text-gradient-cyan`)
//
// Convencion de import desde widgets:
//   import '../../../ui/theme/app_theme.dart' show IsaColors;
//   import '../../../ui/widgets/isa_widgets.dart';
// (ajustar `../../../` segun la profundidad de la pantalla).

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart' show IsaColors;

// ===================================================================
// IsaStatusPill - badge semantico con fondo translucido + ring + label
// ===================================================================
//
// Reemplaza el patron Tailwind del SPA:
//
//   <span className="rounded-full bg-emerald-500/15 px-2 py-0.5
//     text-[10px] font-bold text-emerald-400
//     ring-1 ring-emerald-500/30">ACTIVO</span>
//
// Uso tipico:
//
//   IsaStatusPill(tone: IsaPillTone.ok,      label: 'ACTIVO')
//   IsaStatusPill(tone: IsaPillTone.warning, label: 'PENDIENTE')
//   IsaStatusPill(tone: IsaPillTone.danger,  label: 'L3')
//   IsaStatusPill(tone: IsaPillTone.info,    label: 'INFO',
//                 icon: Icons.check_circle)

enum IsaPillTone { ok, warning, danger, info, special, idle }

class IsaStatusPill extends StatelessWidget {
  const IsaStatusPill({
    super.key,
    required this.tone,
    required this.label,
    this.icon,
  });

  final IsaPillTone tone;
  final String label;
  final IconData? icon;

  _PillStyle get _style {
    switch (tone) {
      case IsaPillTone.ok:
        return const _PillStyle(
          IsaColors.emerald400,
          Color(0x2622C55E),
          Color(0x5922C55E),
        );
      case IsaPillTone.warning:
        return const _PillStyle(
          IsaColors.amber400,
          Color(0x1AFBBF24),
          Color(0x4DFBBF24),
        );
      case IsaPillTone.danger:
        return const _PillStyle(
          IsaColors.rose400,
          Color(0x26FB7185),
          Color(0x66FB7185),
        );
      case IsaPillTone.info:
        return const _PillStyle(
          IsaColors.cyan300,
          Color(0x2E22D3EE),
          Color(0x6622D3EE),
        );
      case IsaPillTone.special:
        return const _PillStyle(
          IsaColors.purple400,
          Color(0x26A855F7),
          Color(0x66A855F7),
        );
      case IsaPillTone.idle:
        return const _PillStyle(
          IsaColors.zinc400,
          Color(0x3371717A),
          Color(0x6671717A),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: s.ring, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: s.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: s.fg,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              fontFamily: 'SpaceMono',
              // SpaceMono se puede tomar via GoogleFonts si se quiere
              // forzar la familia; el fallback Material a system mono
              // queda OK visualmente.
            ),
          ),
        ],
      ),
    );
  }
}

class _PillStyle {
  const _PillStyle(this.fg, this.bg, this.ring);
  final Color fg;
  final Color bg;
  final Color ring;
}

// ===================================================================
// IsaStatusDot - indicador 8x8 con glow
// ===================================================================
//
// Equivalente Flutter de `.status-dot-active/warning/danger/idle` del
// CSS. El glow esta implementado como `BoxShadow.blurRadius`.
//
// Uso:
//
//   IsaStatusDot(tone: IsaDotTone.active)
//   IsaStatusDot(tone: IsaDotTone.warning, size: 10)

enum IsaDotTone { active, warning, danger, idle }

class IsaStatusDot extends StatelessWidget {
  const IsaStatusDot({super.key, required this.tone, this.size = 8});

  final IsaDotTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final Color glow;
    switch (tone) {
      case IsaDotTone.active:
        color = IsaColors.emerald400;
        glow = const Color(0x6634D399);
        break;
      case IsaDotTone.warning:
        color = IsaColors.amber400;
        glow = const Color(0x66FBBF24);
        break;
      case IsaDotTone.danger:
        color = IsaColors.rose400;
        glow = const Color(0x66FB7185);
        break;
      case IsaDotTone.idle:
        color = IsaColors.zinc500;
        glow = Colors.transparent;
        break;
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: glow == Colors.transparent
            ? null
            : [BoxShadow(color: glow, blurRadius: 8, spreadRadius: 0.5)],
      ),
    );
  }
}

// ===================================================================
// IsaTopoBackground - patron topografico (`.bg-topo`)
// ===================================================================
//
// Replica del fondo del SPA: circulos concentricos zinc-800 sobre
// zinc-950 con un radial gradient cyan al 3% en el tope. Pensado para
// envolver el Scaffold del area autenticada.
//
// Uso:
//
//   IsaTopoBackground(
//     child: Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: ...,
//       body: ...,
//     ),
//   )
//
// El Scaffold queda transparente y deja ver el patron debajo. El
// `CustomPaint` es liviano: dibuja 11 circulos en 3 grupos.

class IsaTopoBackground extends StatelessWidget {
  const IsaTopoBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1.4),
          radius: 0.9,
          colors: [Color(0x0822D3EE), Color(0x0009090B)],
          stops: [0.0, 1.0],
        ),
        color: IsaColors.zinc950,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _TopoPainter())),
          child,
        ],
      ),
    );
  }
}

class _TopoPainter extends CustomPainter {
  // Centros de los grupos de circulos como fraccion de [width, height].
  // Mismos centros que el SVG del CSS para que ambas superficies tengan
  // la misma firma visual.
  static const _groups = <(double, double, List<double>)>[
    // (cx, cy, radii)
    (0.50, 0.50, [60, 110, 160, 210, 260]),
    (0.17, 0.20, [30, 55, 80]),
    (0.83, 0.80, [40, 70]),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = IsaColors.zinc800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Tile el patron cada 600px para que se repita en pantallas grandes.
    final cellW = math.min(600.0, size.width);
    final cellH = math.min(600.0, size.height);

    for (double ty = 0; ty < size.height; ty += cellH) {
      for (double tx = 0; tx < size.width; tx += cellW) {
        for (final g in _groups) {
          final cx = tx + g.$1 * cellW;
          final cy = ty + g.$2 * cellH;
          for (final r in g.$3) {
            canvas.drawCircle(Offset(cx, cy), r, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ===================================================================
// IsaGradientText - texto con clip cyan-400 -> blue-400
// ===================================================================
//
// Equivalente Flutter de `.text-gradient-cyan`. Reservado para titulos
// hero y numeros KPI destacados - no para texto corrido.
//
// Uso:
//
//   IsaGradientText(
//     '142',
//     style: TextStyle(fontSize: 64, fontWeight: FontWeight.w700,
//                      fontFamily: 'Syne', letterSpacing: -1),
//   )

class IsaGradientText extends StatelessWidget {
  const IsaGradientText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [IsaColors.cyan400, IsaColors.blue400],
      ).createShader(rect),
      child: Text(text, style: style),
    );
  }
}
