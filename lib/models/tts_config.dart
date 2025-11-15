class TtsConfig {
  final String language;
  final double speechRate;
  final double pitch;
  final double volume;
  final String? selectedVoice;

  TtsConfig({
    this.language = 'es-ES',
    this.speechRate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.selectedVoice,
  });

  TtsConfig copyWith({
    String? language,
    double? speechRate,
    double? pitch,
    double? volume,
    String? selectedVoice,
  }) {
    return TtsConfig(
      language: language ?? this.language,
      speechRate: speechRate ?? this.speechRate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      selectedVoice: selectedVoice ?? this.selectedVoice,
    );
  }
}

class VoiceOption {
  final String name;
  final String locale;
  final String displayName;

  VoiceOption({
    required this.name,
    required this.locale,
    String? displayName,
  }) : displayName = displayName ?? _formatVoiceName(name);

  // Formatea el nombre de la voz para que sea más legible
  static String _formatVoiceName(String rawName) {
    // Eliminar prefijos comunes
    String formatted = rawName
        .replaceAll('es-es-x-', '')
        .replaceAll('es-mx-x-', '')
        .replaceAll('es-us-x-', '')
        .replaceAll('es-', '')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');

    // Detectar género y tipo de voz
    String gender = '';
    String quality = '';

    if (formatted.toLowerCase().contains('female')) {
      gender = '👩 Mujer';
      formatted = formatted.replaceAll(RegExp(r'female', caseSensitive: false), '');
    } else if (formatted.toLowerCase().contains('male')) {
      gender = '👨 Hombre';
      formatted = formatted.replaceAll(RegExp(r'male', caseSensitive: false), '');
    }

    if (formatted.toLowerCase().contains('network')) {
      quality = '(Alta calidad)';
      formatted = formatted.replaceAll(RegExp(r'network', caseSensitive: false), '');
    } else if (formatted.toLowerCase().contains('local')) {
      quality = '(Estándar)';
      formatted = formatted.replaceAll(RegExp(r'local', caseSensitive: false), '');
    }

    // Limpiar espacios extras
    formatted = formatted.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Capitalizar primera letra
    if (formatted.isNotEmpty) {
      formatted = formatted[0].toUpperCase() + formatted.substring(1);
    }

    // Construir nombre final
    List<String> parts = [];
    if (formatted.isNotEmpty) parts.add(formatted);
    if (gender.isNotEmpty) parts.add(gender);
    if (quality.isNotEmpty) parts.add(quality);

    return parts.join(' - ');
  }

  // Obtener país de la voz
  String get country {
    if (locale.contains('ES')) return '🇪🇸 España';
    if (locale.contains('MX')) return '🇲🇽 México';
    if (locale.contains('AR')) return '🇦🇷 Argentina';
    if (locale.contains('CO')) return '🇨🇴 Colombia';
    if (locale.contains('PE')) return '🇵🇪 Perú';
    if (locale.contains('CL')) return '🇨🇱 Chile';
    return '🌎 Español';
  }

  @override
  String toString() => displayName;
}
