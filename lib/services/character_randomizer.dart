import 'dart:math';
import 'package:bg3cr/models/character_models.dart';

class CharacterRandomizer {
  final Random _random = Random();
  final GameData data;

  CharacterRandomizer(this.data);

  T _selectRandom<T>(List<T> list) {
    return list[_random.nextInt(list.length)];
  }

  Map<String, String> generateRaceAndSubRace() {
    final CharacterData selectedRaceData = _selectRandom(data.races);
    final String selectedRace = selectedRaceData.name;
    final String selectedSubRace = _selectRandom(selectedRaceData.subOptions);
    return {'race': selectedRace, 'subRace': selectedSubRace};
  }

  Map<String, String> generateClassAndSubClass() {
    final CharacterData selectedClassData = _selectRandom(data.classes);
    final String selectedClass = selectedClassData.name;
    final String selectedSubClass = selectedClassData.subOptions.isNotEmpty
        ? _selectRandom(selectedClassData.subOptions)
        : '(Не применимо на уровне 1)';
    return {'charClass': selectedClass, 'subClass': selectedSubClass};
  }

  String generateBackground() {
    return _selectRandom(data.backgrounds);
  }

  String generateAlignment() {
    return _selectRandom(data.alignments);
  }

  String? generateDeity(String charClass) {
    if (charClass == 'Жрец' || charClass == 'Паладин') {
      return _selectRandom(data.deities);
    }
    return null;
  }

  String? generateWarlockPact(String charClass) {
    if (charClass == 'Колдун') {
      return _selectRandom(data.warlockPacts);
    }
    return null;
  }

  String? generateFightingStyle(String charClass) {
    if (data.fightingStyles.containsKey(charClass)) {
      return _selectRandom(data.fightingStyles[charClass]!);
    }
    return null;
  }

  GeneratedCharacter generate({
    required String originCategory,
    required Set<String> frozenOptions,
    GeneratedCharacter? currentCharacter,
  }) {
    final raceData = frozenOptions.contains('race') ? {'race': currentCharacter!.race, 'subRace': currentCharacter.subRace} : generateRaceAndSubRace();
    final classData = frozenOptions.contains('class') ? {'charClass': currentCharacter!.charClass, 'subClass': currentCharacter.subClass} : generateClassAndSubClass();
    final selectedClass = classData['charClass']!;

    String finalOrigin;
    if (frozenOptions.contains('origin')) {
      finalOrigin = currentCharacter!.origin!;
    } else if (originCategory == 'Готовый персонаж') {
      final premadeOrigins = data.origins.where((o) => o != 'Свой персонаж' && o != 'Тёмный соблазн').toList();
      finalOrigin = _selectRandom(premadeOrigins);
    } else {
      finalOrigin = originCategory;
    }

    return GeneratedCharacter(
      race: raceData['race']!,
      subRace: raceData['subRace']!,
      charClass: selectedClass,
      subClass: classData['subClass']!,
      background: frozenOptions.contains('background') ? currentCharacter!.background : generateBackground(),
      origin: finalOrigin,
      alignment: frozenOptions.contains('alignment') ? currentCharacter!.alignment : generateAlignment(),
      deity: frozenOptions.contains('deity') ? currentCharacter!.deity : generateDeity(selectedClass),
      warlockPact: frozenOptions.contains('warlockPact') ? currentCharacter!.warlockPact : generateWarlockPact(selectedClass),
      fightingStyle: frozenOptions.contains('fightingStyle') ? currentCharacter!.fightingStyle : generateFightingStyle(selectedClass),
    );
  }

  GeneratedCharacter reroll(String option, GeneratedCharacter character) {
    switch (option) {
      case 'race':
        final raceData = generateRaceAndSubRace();
        return character.copyWith(race: raceData['race'], subRace: raceData['subRace']);
      case 'class':
        final classData = generateClassAndSubClass();
        return character.copyWith(charClass: classData['charClass'], subClass: classData['subClass']);
      case 'background':
        return character.copyWith(background: generateBackground());
      case 'alignment':
        return character.copyWith(alignment: generateAlignment());
      case 'deity':
        return character.copyWith(deity: generateDeity(character.charClass));
      case 'warlockPact':
        return character.copyWith(warlockPact: generateWarlockPact(character.charClass));
      case 'fightingStyle':
        return character.copyWith(fightingStyle: generateFightingStyle(character.charClass));
      default:
        return character;
    }
  }
}
