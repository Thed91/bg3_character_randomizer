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

  GeneratedCharacter generate({required String originCategory}) {
    final raceData = generateRaceAndSubRace();
    final classData = generateClassAndSubClass();
    final selectedClass = classData['charClass']!;

    String finalOrigin;
    if (originCategory == 'Готовый персонаж') {
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
      background: generateBackground(),
      origin: finalOrigin,
      alignment: generateAlignment(),
      deity: generateDeity(selectedClass),
      warlockPact: generateWarlockPact(selectedClass),
      fightingStyle: generateFightingStyle(selectedClass),
    );
  }
}
