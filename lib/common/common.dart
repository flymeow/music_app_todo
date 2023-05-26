import 'package:flutter/material.dart';
import 'package:flutter_music/views/home/home.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class MyColors {
  static const Color secondary = Color.fromARGB(255, 40, 214, 130);
}

class PlayerProgressBar extends StatefulWidget {
  const PlayerProgressBar({
    Key? key,
    required this.position,
    required this.duration,
    this.onSeek,
  }) : super(key: key);

  final Duration position;
  final Duration duration;
  final Function(Duration)? onSeek;

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  double? dragVal;

  @override
  Widget build(BuildContext context) {
    double value = dragVal ?? widget.position.inMilliseconds.toDouble();
    if (widget.duration.inMilliseconds <= 0) {
      value = 0.0;
    }
    double _val = value > widget.duration.inMilliseconds.toDouble()
        ? widget.duration.inMilliseconds.toDouble()
        : value;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -24,
              right: -24,
              child: SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: Colors.white,
                    activeTrackColor: MyColors.secondary,
                    inactiveTrackColor: Color(0x33ffffff),
                    overlayColor: Color(0x44ffffff),
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  ),
                  child: Slider(
                    value: _val,
                    max: widget.duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        dragVal = value;
                      });
                    },
                    onChangeEnd: (value) {
                      widget.onSeek
                          ?.call(Duration(milliseconds: value.round()));
                      dragVal = null;
                    },
                  )),
            ),
            Positioned(
              bottom: 0,
              child: Text(_timeString(widget.position),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                _timeString(widget.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _timeString(Duration time) {
    final minutes =
        time.inMinutes.remainder(Duration.minutesPerHour).toString();
    final seconds = time.inSeconds
        .remainder(Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0');
    return time.inHours > 0
        ? "${time.inHours}:${minutes.padLeft(2, "0")}:$seconds"
        : "$minutes:$seconds";
  }
}
