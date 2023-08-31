part of core_ui;

abstract class AppColors {
  factory AppColors.of(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? const LightColors()
        : const DarkColors();
  }

  Color get primaryBg;

  Color get white;

  Color get gray;

  Color get blue;

  Color get darkGray;

  Color get hilightBlue;

  Color get black;
}

class DarkColors extends LightColors {
  const DarkColors();
}

class LightColors implements AppColors {
  const LightColors();

  @override
  // RGBO(236, 239, 241, 1)
  Color get primaryBg => const Color(0xFFeceff1);

  @override
  Color get white => const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color get gray => const Color.fromRGBO(217, 217, 217, 1);

  @override
  Color get blue => const Color.fromRGBO(29, 71, 153, 1);

  @override
  Color get darkGray => const Color.fromRGBO(92, 92, 92, 1);

  @override
  Color get hilightBlue => const Color.fromRGBO(232, 237, 245, 1);

  @override
  Color get black => Colors.black;
}
