import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

//тугл свитч для переключения страницы
class PagesToogleSwitch extends StatelessWidget {
  final int count;
  final Function changePageFirst;
  final Function changePageSecond;
  const PagesToogleSwitch(
      {Key? key,
      required this.count,
      required this.changePageFirst,
      required this.changePageSecond})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _colors = Theme.of(context).colorScheme;

    return ToggleSwitch(
      minWidth: MediaQuery.of(context).size.width * 0.4,
      initialLabelIndex: count,
      cornerRadius: 8.0,
      activeFgColor: _colors.onTertiary,
      activeBgColor: [
        _colors.tertiary,
      ],
      borderColor: [_colors.tertiary],
      borderWidth: 2,
      inactiveBgColor: _colors.surfaceVariant,
      inactiveFgColor: _colors.onSurfaceVariant,
      fontSize: 16,
      totalSwitches: 2,
      labels: const [
        'Фильмы',
        'Сериалы',
      ],
      onToggle: (index) {
        if (index == 0) {
          changePageFirst();
        } else {
          changePageSecond();
        }
      },
    );
  }
}
