import 'package:flutter/material.dart';

class GptResponse extends StatefulWidget {
  final String transcription;
  const GptResponse({Key? key, required this.transcription}) : super(key: key);

  @override
  _GptResponseState createState() => _GptResponseState();
}

class _GptResponseState extends State<GptResponse>
    with TickerProviderStateMixin {
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _opacityAnimations = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimations() {
    final words = widget.transcription.split(' ');
    int delay = 0;
    for (int i = 0; i < words.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _animationControllers.add(controller);

      final animation = Tween<double>(begin: 0, end: 1).animate(controller);
      _opacityAnimations.add(animation);

      Future.delayed(Duration(milliseconds: delay), () {
        if (mounted) {
          controller.forward();
        }
      });

      delay += 200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.transcription.split(' ');
    return Wrap(
      children: List.generate(words.length, (index) {
        return AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimations[index].value,
              child: Text(
                words[index] + ' ',
                style: TextStyle(fontSize: 18),
              ),
            );
          },
        );
      }),
    );
  }
}
