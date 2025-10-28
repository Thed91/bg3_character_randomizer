import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bg3cr/services/character_randomizer.dart';
import 'package:bg3cr/models/character_models.dart';
import 'package:bg3cr/data/game_data.dart';

class Bg3RandomizerScreen extends StatefulWidget {
  const Bg3RandomizerScreen({super.key});

  @override
  State<Bg3RandomizerScreen> createState() => _Bg3RandomizerScreenState();
}

class _Bg3RandomizerScreenState extends State<Bg3RandomizerScreen> {
  final CharacterRandomizer _randomizer = CharacterRandomizer(allBg3Data);
  GeneratedCharacter? _currentCharacter;
  String _selectedOriginCategory = 'Свой персонаж';
  final Set<String> _frozenOptions = {};

  void _rollCharacter() {
    setState(() {
      _currentCharacter = _randomizer.generate(originCategory: _selectedOriginCategory, frozenOptions: _frozenOptions, currentCharacter: _currentCharacter);
    });
  }

  void _toggleFreeze(String option) {
    setState(() {
      if (_frozenOptions.contains(option)) {
        _frozenOptions.remove(option);
      } else {
        _frozenOptions.add(option);
      }
    });
  }

  void _copyToClipboard() {
    if (_currentCharacter == null) return;
    final textToCopy = _currentCharacter.toString();
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Персонаж скопирован в буфер обмена!')),
      );
    });
  }

  void _reroll(String option) {
    if (_currentCharacter == null) return;
    setState(() {
      _currentCharacter = _randomizer.reroll(option, _currentCharacter!);
    });
  }

  void _showDescription(String title, String? description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2A26),
          title: Text(title, style: const TextStyle(color: Color(0xFFD4AF37))),
          content: Text(description ?? 'Описание не найдено.', style: const TextStyle(color: Color(0xFFEAE0D5))),
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть', style: TextStyle(color: Color(0xFFD4AF37))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultTile(String title, String? value, String optionKey, {VoidCallback? onInfo}) {
    if (value == null) return const SizedBox.shrink();

    final isFrozen = _frozenOptions.contains(optionKey);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: GestureDetector(
        key: ValueKey<String>(value), // Важно для работы AnimatedSwitcher
        onTap: () => _reroll(optionKey),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (onInfo != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Color.fromRGBO(212, 175, 55, 0.7)),
                    onPressed: onInfo,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFFEAE0D5)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isFrozen ? Icons.lock : Icons.lock_open, color: isFrozen ? const Color(0xFFD4AF37) : Colors.grey),
                  onPressed: () => _toggleFreeze(optionKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎲 Рандомайзер Персонажа BG3'),
        actions: [
          if (_currentCharacter != null)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _copyToClipboard,
              tooltip: 'Скопировать персонажа',
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedOriginCategory,
                  items: ['Свой персонаж', 'Тёмный соблазн', 'Готовый персонаж'].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedOriginCategory = newValue;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Категория происхождения',
                  ),
                ),
              ),
              if (_currentCharacter != null) ...[
                _buildSectionHeader('Основная информация'),
                if (_currentCharacter!.origin == 'Свой персонаж' || _currentCharacter!.origin == 'Тёмный соблазн')
                  _buildResultTile(
                    'Раса/Подраса',
                    '${_currentCharacter!.race}${_currentCharacter!.subRace != '(Нет Подрасы)' ? ' - ${_currentCharacter!.subRace}' : ''}',
                    'race',
                    onInfo: () => _showDescription(_currentCharacter!.race, allBg3Data.raceDescriptions[_currentCharacter!.race]),
                  ),
                _buildResultTile(
                  'Класс/Подкласс',
                  '${_currentCharacter!.charClass} - ${_currentCharacter!.subClass}',
                  'class',
                  onInfo: () => _showDescription(_currentCharacter!.charClass, allBg3Data.classDescriptions[_currentCharacter!.charClass]),
                ),
                _buildResultTile(
                  'Предыстория',
                  _currentCharacter!.background,
                  'background',
                  onInfo: () => _showDescription(_currentCharacter!.background, allBg3Data.backgroundDescriptions[_currentCharacter!.background]),
                ),
                _buildResultTile(
                  'Мировоззрение',
                  _currentCharacter!.alignment,
                  'alignment',
                  onInfo: () => _showDescription(_currentCharacter!.alignment!, allBg3Data.alignmentDescriptions[_currentCharacter!.alignment!]),
                ),
                _buildSectionHeader('🎯 Ключевые Выборы'),
                if (_currentCharacter!.origin != 'Свой персонаж' && _currentCharacter!.origin != 'Тёмный соблазн')
                  _buildResultTile(
                    'Происхождение',
                    _currentCharacter!.origin,
                    'origin',
                    onInfo: () => _showDescription(_currentCharacter!.origin!, allBg3Data.originDescriptions[_currentCharacter!.origin!]),
                  ),
                if (_currentCharacter!.deity != null)
                  _buildResultTile(
                    'Божество',
                    _currentCharacter!.deity,
                    'deity',
                    onInfo: () => _showDescription(_currentCharacter!.deity!, allBg3Data.deityDescriptions[_currentCharacter!.deity!]),
                  ),
                if (_currentCharacter!.warlockPact != null)
                  _buildResultTile(
                    'Договор колдуна',
                    _currentCharacter!.warlockPact,
                    'warlockPact',
                    onInfo: () => _showDescription(_currentCharacter!.warlockPact!, allBg3Data.warlockPactDescriptions[_currentCharacter!.warlockPact!]),
                  ),
                if (_currentCharacter!.fightingStyle != null)
                  _buildResultTile(
                    'Боевой Стиль',
                    _currentCharacter!.fightingStyle,
                    'fightingStyle',
                    onInfo: () => _showDescription(_currentCharacter!.fightingStyle!, allBg3Data.fightingStyleDescriptions[_currentCharacter!.fightingStyle!]),
                  ),
                const SizedBox(height: 20),
              ] else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Выберите категорию и нажмите СГЕНЕРИРОВАТЬ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                child: ElevatedButton.icon(
                  onPressed: _rollCharacter,
                  icon: const Icon(Icons.casino, color: Colors.white),
                  label: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'СГЕНЕРИРОВАТЬ ПЕРСОНАЖА',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
