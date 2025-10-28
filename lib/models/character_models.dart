/// Модель для расы или класса, содержащая список подвариантов.
class CharacterData {
  final String name;
  final List<String> subOptions;

  CharacterData({required this.name, required this.subOptions});

  @override
  String toString() => '$name: ${subOptions.join(', ')}';
}

/// Модель для хранения всех данных игры.
class GameData {
  final List<CharacterData> races;
  final List<CharacterData> classes;
  final List<String> backgrounds;
  final List<String> origins;
  final List<String> alignments;
  final Map<String, String> alignmentDescriptions;
  final Map<String, String> raceDescriptions;
  final Map<String, String> classDescriptions;
  final Map<String, String> backgroundDescriptions;
  final Map<String, String> originDescriptions;
  final Map<String, String> deityDescriptions;
  final Map<String, String> warlockPactDescriptions;
  final Map<String, String> fightingStyleDescriptions;
  final List<String> deities;
  final List<String> warlockPacts;
  final Map<String, List<String>> fightingStyles;

  GameData({
    required this.races,
    required this.classes,
    required this.backgrounds,
    required this.origins,
    required this.alignments,
    required this.alignmentDescriptions,
    required this.raceDescriptions,
    required this.classDescriptions,
    required this.backgroundDescriptions,
    required this.originDescriptions,
    required this.deityDescriptions,
    required this.warlockPactDescriptions,
    required this.fightingStyleDescriptions,
    required this.deities,
    required this.warlockPacts,
    required this.fightingStyles,
  });
}

/// Модель для сгенерированного персонажа.
class GeneratedCharacter {
  String race;
  String subRace;
  String charClass;
  String subClass;
  String background;
  String? origin;
  String? alignment;
  String? deity;
  String? warlockPact;
  String? fightingStyle;

  GeneratedCharacter({
    required this.race,
    required this.subRace,
    required this.charClass,
    required this.subClass,
    required this.background,
    this.origin,
    this.alignment,
    this.deity,
    this.warlockPact,
    this.fightingStyle,
  });

  GeneratedCharacter copyWith({
    String? race,
    String? subRace,
    String? charClass,
    String? subClass,
    String? background,
    String? origin,
    String? alignment,
    String? deity,
    String? warlockPact,
    String? fightingStyle,
  }) {
    return GeneratedCharacter(
      race: race ?? this.race,
      subRace: subRace ?? this.subRace,
      charClass: charClass ?? this.charClass,
      subClass: subClass ?? this.subClass,
      background: background ?? this.background,
      origin: origin ?? this.origin,
      alignment: alignment ?? this.alignment,
      deity: deity ?? this.deity,
      warlockPact: warlockPact ?? this.warlockPact,
      fightingStyle: fightingStyle ?? this.fightingStyle,
    );
  }

  @override
  String toString() {
    return 'Персонаж BG3:\n'
        '  Раса: $subRace $race\n'
        '  Класс: $subClass $charClass\n'
        '  Предыстория: $background\n'
        '  Происхождение: $origin\n'
        '  Мировоззрение: $alignment\n'
        '  Божество: $deity\n'
        '  Пакт колдуна: $warlockPact\n'
        '  Боевой стиль: $fightingStyle';
  }
}
