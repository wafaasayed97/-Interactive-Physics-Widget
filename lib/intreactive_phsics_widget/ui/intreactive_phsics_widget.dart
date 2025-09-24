import 'package:flutter/material.dart';

class ColoredBall {
  final String id;
  final Color color;
  final String name;
  bool isMatched;

  ColoredBall({
    required this.id,
    required this.color,
    required this.name,
    this.isMatched = false,
  });

  ColoredBall copyWith({bool? isMatched}) {
    return ColoredBall(
      id: id,
      color: color,
      name: name,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

class PhysicsSimulationWidget extends StatefulWidget {
  const PhysicsSimulationWidget({super.key});

  @override
  _PhysicsSimulationWidgetState createState() =>
      _PhysicsSimulationWidgetState();
}

class _PhysicsSimulationWidgetState extends State<PhysicsSimulationWidget>
    with TickerProviderStateMixin {
  late List<ColoredBall> balls;
  late List<ColoredBall> containers;
  int correctMatches = 0;
  bool gameCompleted = false;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _initializeBalls();
    _celebrationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  void _initializeBalls() {
    balls = [
      ColoredBall(id: '1', color: Colors.red, name: 'Red'),
      ColoredBall(id: '2', color: Colors.blue, name: 'Blue'),
      ColoredBall(id: '3', color: Colors.green, name: 'Green'),
    ];

    containers = [
      ColoredBall(id: 'c1', color: Colors.red, name: 'Red Container'),
      ColoredBall(id: 'c2', color: Colors.blue, name: 'Blue Container'),
      ColoredBall(id: 'c3', color: Colors.green, name: 'Green Container'),
    ];

    correctMatches = 0;
    gameCompleted = false;
  }

  void _resetGame() {
    setState(() {
      _initializeBalls();
    });
    _celebrationController.reset();
  }

  void _onBallDropped(ColoredBall ball, ColoredBall container) {
    setState(() {
      if (ball.color == container.color && !ball.isMatched) {
        // Correct match
        final ballIndex = balls.indexWhere((b) => b.id == ball.id);
        final containerIndex = containers.indexWhere(
          (c) => c.id == container.id,
        );

        balls[ballIndex] = ball.copyWith(isMatched: true);
        containers[containerIndex] = container.copyWith(isMatched: true);

        correctMatches++;

        if (correctMatches == balls.length) {
          gameCompleted = true;
          _celebrationController.forward();
        }

        // Show simple success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfect match!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        // Show simple error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Try again!'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Physics Playground'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: _resetGame, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            // Draggable balls (top section)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDraggableBall(balls[0]), // Red
                  _buildDraggableBall(balls[1]), // Blue
                  _buildDraggableBall(balls[2]), // Green
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Drop targets (bottom section)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDropTarget(containers[0]),
                  _buildDropTarget(containers[1]),
                  _buildDropTarget(containers[2]),
                ],
              ),
            ),
          ],
        ),
      ),
      //
    );
  }

  Widget _buildDraggableBall(ColoredBall ball) {
    if (ball.isMatched) {
      return SizedBox(width: 60, height: 60);
    }

    return Draggable<ColoredBall>(
      data: ball,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ball.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ball.color.withOpacity(0.3),
        ),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(shape: BoxShape.circle, color: ball.color),
      ),
    );
  }

  Widget _buildDropTarget(ColoredBall container) {
    return DragTarget<ColoredBall>(
      onAcceptWithDetails: (details) {
        _onBallDropped(details.data, container);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: container.isMatched
                ? container.color
                : container.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),

            border: isHovering
                ? Border.all(
                    color: container.isMatched
                        ? container.color
                        : container.color,
                    width: 3,
                  )
                : null,
          ),
          child: container.isMatched
              ? const Icon(Icons.check, color: Colors.white, size: 30)
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }
}
