// IsaTech Fleet - Dark Material 3 theme
//
// Theme oscuro de la plataforma IsaTech Fleet Monitoring para que la
// app del chofer comparta paleta y tipografias con el SPA de monitoreo.
//
// Reglas de marca aplicadas aca:
//   - Fondo zinc-950 (#09090B), card zinc-900, border zinc-800.
//   - Brand accent cyan-400 (#22D3EE) - selecciones, FocusNode, branding.
//   - Boton primario BLANCO (zinc-100 sobre zinc-900). El cyan NO es
//     primario: se reserva como acento sutil.
//   - Tipografia: Syne (headings), Plus Jakarta Sans (body), Space Mono
//     (mono) via google_fonts.
//   - Semanticos: emerald (ok), amber (warning), rose/red (danger),
//     purple (eventos especiales L3).
//
// Dependencias requeridas (ya estan en pubspec.yaml):
//   google_fonts: ^6.2.1

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta cruda - espejo de `colors_and_type.css` del design system.
/// Convencion: nunca hardcodear estos hex en widgets; siempre usar el
/// `ColorScheme` o un getter de `Theme.of(context)`. Solo `IsaColors`
/// puede usarlos directo (y los SVG con `stroke` fijo / Leaflet, que
/// reciben strings de color).
class IsaColors {
  // Spine zinc
  static const zinc950 = Color(0xFF09090B);
  static const zinc900 = Color(0xFF18181B);
  static const zinc800 = Color(0xFF27272A);
  static const zinc700 = Color(0xFF3F3F46);
  static const zinc600 = Color(0xFF52525B);
  static const zinc500 = Color(0xFF71717A);
  static const zinc400 = Color(0xFFA1A1AA);
  static const zinc300 = Color(0xFFD4D4D8);
  static const zinc200 = Color(0xFFE4E4E7);
  static const zinc100 = Color(0xFFF4F4F5);

  // Brand
  static const cyan300 = Color(0xFF67E8F9);
  static const cyan400 = Color(0xFF22D3EE);
  static const cyan500 = Color(0xFF06B6D4);
  static const blue400 = Color(0xFF60A5FA);
  static const blue500 = Color(0xFF3B82F6);

  // Status / semantic
  static const emerald400 = Color(0xFF34D399);
  static const emerald500 = Color(0xFF22C55E);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const rose400 = Color(0xFFFB7185);
  static const rose500 = Color(0xFFF43F5E);
  static const red400 = Color(0xFFF87171);
  static const red500 = Color(0xFFEF4444);
  static const red700 = Color(0xFFB91C1C);
  static const red900 = Color(0xFF7F1D1D);

  // Special events
  static const purple400 = Color(0xFFA78BFA);
  static const purple500 = Color(0xFFA855F7);
  static const violet500 = Color(0xFF8B5CF6);
  static const orange500 = Color(0xFFF97316);
}

/// Radii estandar - mismos valores que `--radius-*` del CSS.
class IsaRadii {
  static const sm = Radius.circular(6); // badges interiores
  static const md = Radius.circular(8); // inputs / botones
  static const lg = Radius.circular(12); // card raw
  static const xl = Radius.circular(16); // UI primitives, modales
  static const pill = Radius.circular(999);
}

/// Theme principal. Llamado desde `lib/app.dart` en `buildAppTheme()`.
ThemeData buildAppTheme() {
  // El primario de Material es BLANCO (zinc-100). Esto es deliberado:
  // en una UI tan oscura, el boton primario blanco-sobre-negro contrasta
  // mas que cualquier color y se lee como el call-to-action principal.
  // El cyan-400 va como `secondary` (acento de marca) - se usa en
  // seleccion de texto, logo, gradients y badges info.
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: IsaColors.zinc100,
    onPrimary: IsaColors.zinc900,
    primaryContainer: IsaColors.zinc800,
    onPrimaryContainer: IsaColors.zinc100,
    secondary: IsaColors.cyan400,
    onSecondary: IsaColors.zinc950,
    secondaryContainer: Color(0x1A22D3EE), // cyan-400 / 10
    onSecondaryContainer: IsaColors.cyan300,
    tertiary: IsaColors.amber400,
    onTertiary: IsaColors.zinc950,
    tertiaryContainer: Color(0x1AFBBF24),
    onTertiaryContainer: IsaColors.amber400,
    error: IsaColors.red500,
    onError: Colors.white,
    errorContainer: Color(0xFF7F1D1D),
    onErrorContainer: Color(0xFFFECACA),
    surface: IsaColors.zinc900,
    onSurface: IsaColors.zinc100,
    surfaceContainerLowest: IsaColors.zinc950,
    surfaceContainerLow: IsaColors.zinc900,
    surfaceContainer: IsaColors.zinc900,
    surfaceContainerHigh: IsaColors.zinc800,
    surfaceContainerHighest: IsaColors.zinc800,
    surfaceDim: IsaColors.zinc950,
    surfaceBright: IsaColors.zinc800,
    onSurfaceVariant: IsaColors.zinc400,
    outline: IsaColors.zinc700,
    outlineVariant: IsaColors.zinc800,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: IsaColors.zinc100,
    onInverseSurface: IsaColors.zinc900,
    inversePrimary: IsaColors.cyan500,
  );

  // --- Tipografia ----------------------------------------------------
  // Headings -> Syne, body -> Plus Jakarta Sans, mono -> Space Mono.
  TextStyle heading(double size, FontWeight weight, {Color? color}) =>
      GoogleFonts.syne(
        fontSize: size,
        fontWeight: weight,
        height: 1.15,
        letterSpacing: -0.2,
        color: color ?? IsaColors.zinc100,
      );

  TextStyle body(
    double size,
    FontWeight weight, {
    Color? color,
    double height = 1.45,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? IsaColors.zinc200,
      );

  final textTheme = TextTheme(
    displayLarge: heading(44, FontWeight.w700),
    displayMedium: heading(36, FontWeight.w700),
    displaySmall: heading(28, FontWeight.w700),
    headlineLarge: heading(32, FontWeight.w700),
    headlineMedium: heading(24, FontWeight.w700),
    headlineSmall: heading(18, FontWeight.w600),
    titleLarge: heading(18, FontWeight.w600),
    titleMedium:
        body(15, FontWeight.w600, color: IsaColors.zinc100, height: 1.3),
    titleSmall:
        body(13, FontWeight.w600, color: IsaColors.zinc100, height: 1.3),
    bodyLarge: body(16, FontWeight.w400, height: 1.55),
    bodyMedium: body(14, FontWeight.w400),
    bodySmall: body(13, FontWeight.w400, color: IsaColors.zinc400),
    labelLarge:
        body(14, FontWeight.w600, color: IsaColors.zinc100, height: 1.3),
    labelMedium:
        body(12, FontWeight.w500, color: IsaColors.zinc400, height: 1.3),
    labelSmall:
        body(11, FontWeight.w500, color: IsaColors.zinc500, height: 1.3),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: IsaColors.zinc950,
    canvasColor: IsaColors.zinc950,
    dividerColor: IsaColors.zinc800,
    hintColor: IsaColors.zinc500,
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    textTheme: textTheme,
    primaryTextTheme: textTheme,

    appBarTheme: AppBarTheme(
      backgroundColor: IsaColors.zinc950.withValues(alpha: 0.9),
      foregroundColor: IsaColors.zinc100,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      titleTextStyle: heading(16, FontWeight.w600),
      shape: const Border(
        bottom: BorderSide(color: IsaColors.zinc800, width: 1),
      ),
      iconTheme: const IconThemeData(color: IsaColors.zinc300, size: 22),
    ),

    cardTheme: const CardThemeData(
      color: IsaColors.zinc900,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(IsaRadii.lg),
        side: BorderSide(color: IsaColors.zinc800, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: IsaColors.zinc950,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: body(14, FontWeight.w400, color: IsaColors.zinc500),
      labelStyle: body(12, FontWeight.w500, color: IsaColors.zinc500),
      floatingLabelStyle:
          body(12, FontWeight.w500, color: IsaColors.cyan400),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        borderSide: BorderSide(color: IsaColors.zinc800),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        borderSide: BorderSide(color: IsaColors.zinc800),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        borderSide: BorderSide(color: IsaColors.zinc600, width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        borderSide: BorderSide(color: IsaColors.red500),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        borderSide: BorderSide(color: IsaColors.red500, width: 1.5),
      ),
    ),

    // --- Boton primario: BLANCO sobre fondo oscuro ------------------
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: IsaColors.zinc100,
        foregroundColor: IsaColors.zinc900,
        disabledBackgroundColor: IsaColors.zinc700,
        disabledForegroundColor: IsaColors.zinc500,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: body(14, FontWeight.w600, color: IsaColors.zinc900),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(IsaRadii.md),
        ),
      ),
    ),

    // Secondary / outlined -> zinc-800 con ring zinc-700
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: IsaColors.zinc800,
        foregroundColor: IsaColors.zinc100,
        side: const BorderSide(color: IsaColors.zinc700),
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: body(14, FontWeight.w600, color: IsaColors.zinc100),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(IsaRadii.md),
        ),
      ),
    ),

    // Text button - para acciones secundarias inline (Cancelar, etc.)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: IsaColors.zinc300,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: body(14, FontWeight.w600, color: IsaColors.zinc300),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(IsaRadii.md),
        ),
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: IsaColors.zinc300,
        minimumSize: const Size(44, 44),
        padding: EdgeInsets.zero,
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: IsaColors.zinc800,
      labelStyle: body(12, FontWeight.w600, color: IsaColors.zinc200),
      side: const BorderSide(color: IsaColors.zinc700),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(IsaRadii.pill),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: IsaColors.zinc900,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(IsaRadii.xl),
        side: BorderSide(color: IsaColors.zinc700),
      ),
      titleTextStyle: heading(18, FontWeight.w600),
      contentTextStyle: body(14, FontWeight.w400, height: 1.5),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: IsaColors.zinc900,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: IsaColors.zinc900,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: IsaRadii.xl),
        side: BorderSide(color: IsaColors.zinc700),
      ),
      dragHandleColor: IsaColors.zinc700,
      dragHandleSize: Size(40, 4),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: IsaColors.zinc800,
      contentTextStyle: body(13, FontWeight.w500, color: IsaColors.zinc100),
      actionTextColor: IsaColors.cyan400,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(IsaRadii.md),
        side: BorderSide(color: IsaColors.zinc700),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: IsaColors.zinc800,
      space: 1,
      thickness: 1,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: IsaColors.zinc400,
      textColor: IsaColors.zinc200,
      titleTextStyle: body(14, FontWeight.w500, color: IsaColors.zinc100),
      subtitleTextStyle: body(12, FontWeight.w400, color: IsaColors.zinc400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: IsaColors.cyan400,
      linearTrackColor: IsaColors.zinc800,
      circularTrackColor: IsaColors.zinc800,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: IsaColors.amber400.withValues(alpha: 0.9),
      foregroundColor: IsaColors.zinc900,
      elevation: 6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(IsaRadii.pill),
        side: BorderSide(color: IsaColors.amber400),
      ),
    ),

    // Seleccion de texto en cyan-400 - la firma visual de marca.
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: IsaColors.cyan400,
      selectionColor: Color(0x6622D3EE),
      selectionHandleColor: IsaColors.cyan400,
    ),
  );
}
