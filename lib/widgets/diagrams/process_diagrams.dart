import 'package:flutter/material.dart';
import '../../theme/manga_theme.dart';

/// Process State Transition Diagram (5-state)
class ProcessStateDiagram extends StatelessWidget {
  const ProcessStateDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 400),
      painter: _ProcessStatePainter(),
    );
  }
}

class _ProcessStatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final statePaint = Paint()
      ..color = MangaTheme.paperWhite
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final arrowPaint = Paint()
      ..color = MangaTheme.mangaRed
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // State positions
    final newState = Offset(size.width * 0.1, size.height * 0.2);
    final readyState = Offset(size.width * 0.5, size.height * 0.2);
    final runningState = Offset(size.width * 0.5, size.height * 0.5);
    final waitingState = Offset(size.width * 0.1, size.height * 0.7);
    final terminatedState = Offset(size.width * 0.9, size.height * 0.5);

    // Draw states (circles)
    void drawState(Offset center, String label) {
      canvas.drawCircle(center, 50, statePaint);
      canvas.drawCircle(center, 50, borderPaint);

      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(
          color: MangaTheme.inkBlack,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2),
      );
    }

    // Draw arrow with label
    void drawArrow(Offset start, Offset end, String label, {bool curved = false}) {
      final path = Path();
      path.moveTo(start.dx, start.dy);

      if (curved) {
        final controlPoint = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2 - 30,
        );
        path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, end.dx, end.dy);
      } else {
        path.lineTo(end.dx, end.dy);
      }

      canvas.drawPath(path, arrowPaint);

      // Draw arrowhead
      final arrowSize = 10.0;

      final arrowPath = Path();
      arrowPath.moveTo(end.dx, end.dy);
      arrowPath.lineTo(
        end.dx - arrowSize,
        end.dy - arrowSize,
      );
      arrowPath.moveTo(end.dx, end.dy);
      arrowPath.lineTo(
        end.dx - arrowSize,
        end.dy + arrowSize,
      );
      canvas.drawPath(arrowPath, arrowPaint);

      // Draw label
      final labelPos = Offset(
        (start.dx + end.dx) / 2,
        curved ? (start.dy + end.dy) / 2 - 50 : (start.dy + end.dy) / 2 - 20,
      );

      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(
          color: MangaTheme.mangaRed,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelPos.dx - textPainter.width / 2, labelPos.dy),
      );
    }

    // Draw all states
    drawState(newState, 'NEW');
    drawState(readyState, 'READY');
    drawState(runningState, 'RUNNING');
    drawState(waitingState, 'WAITING');
    drawState(terminatedState, 'TERMINATED');

    // Draw transitions
    drawArrow(
      Offset(newState.dx + 50, newState.dy),
      Offset(readyState.dx - 50, readyState.dy),
      'ADMIT',
    );

    drawArrow(
      Offset(readyState.dx, readyState.dy + 50),
      Offset(runningState.dx, runningState.dy - 50),
      'DISPATCH',
    );

    drawArrow(
      Offset(runningState.dx - 20, runningState.dy - 30),
      Offset(readyState.dx - 20, readyState.dy + 30),
      'INTERRUPT',
      curved: true,
    );

    drawArrow(
      Offset(runningState.dx - 50, runningState.dy + 30),
      Offset(waitingState.dx + 50, waitingState.dy - 30),
      'I/O WAIT',
    );

    drawArrow(
      Offset(waitingState.dx + 30, waitingState.dy - 50),
      Offset(readyState.dx - 30, readyState.dy + 50),
      'I/O DONE',
      curved: true,
    );

    drawArrow(
      Offset(runningState.dx + 50, runningState.dy),
      Offset(terminatedState.dx - 50, terminatedState.dy),
      'EXIT',
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PCB Structure Diagram
class PCBDiagram extends StatelessWidget {
  const PCBDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPCBHeader('PROCESS CONTROL BLOCK'),
          _buildPCBField('Process ID', 'PID: 1337'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('Process State', 'RUNNING / READY / WAITING'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('Program Counter', 'Address: 0x7FFF5432'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('CPU Registers', 'AX, BX, CX, DX, SP, BP...'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('CPU Scheduling Info', 'Priority, Queue Pointers'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('Memory Info', 'Base, Limit, Page Tables'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('Accounting Info', 'CPU Time, Time Limits'),
          const Divider(color: MangaTheme.inkBlack, thickness: 2),
          _buildPCBField('I/O Status', 'Open Files, Devices'),
        ],
      ),
    );
  }

  Widget _buildPCBHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: MangaTheme.mangaRed,
        border: Border(
          bottom: BorderSide(color: MangaTheme.inkBlack, width: 3),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: MangaTheme.paperWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPCBField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: MangaTheme.shadowGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Process vs Program Comparison
class ProcessVsProgramDiagram extends StatelessWidget {
  const ProcessVsProgramDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            'PROGRAM',
            [
              'Passive entity',
              'Stored on disk',
              'Static',
              'Recipe book',
              'One program →',
              'Many processes',
            ],
            MangaTheme.speedlineBlue,
          ),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: const Text(
            'VS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: MangaTheme.mangaRed,
            ),
          ),
        ),
        Expanded(
          child: _buildCard(
            'PROCESS',
            [
              'Active entity',
              'In memory',
              'Dynamic',
              'Cooking meal',
              'Program +',
              'Execution state',
            ],
            MangaTheme.accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, List<String> points, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: MangaTheme.inkBlack, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MangaTheme.inkBlack,
            ),
          ),
          const SizedBox(height: 12),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Context Switch Diagram
class ContextSwitchDiagram extends StatelessWidget {
  const ContextSwitchDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 300),
      painter: _ContextSwitchPainter(),
    );
  }
}

class _ContextSwitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MangaTheme.mangaRed
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = MangaTheme.paperWhite
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw timeline
    final y = size.height / 2;
    canvas.drawLine(Offset(20, y), Offset(size.width - 20, y), paint);

    // Draw process boxes
    void drawProcessBox(double x, String label, Color color) {
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: 80,
        height: 60,
      );

      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(
        rect,
        Paint()
          ..color = color
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
      );

      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw switch indicator
    void drawSwitch(double x) {
      final switchPaint = Paint()
        ..color = MangaTheme.highlightYellow
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(x, y - 40),
        Offset(x, y + 40),
        switchPaint,
      );

      textPainter.text = const TextSpan(
        text: 'SWITCH',
        style: TextStyle(
          color: MangaTheme.mangaRed,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 50));
    }

    drawProcessBox(80, 'Process A', MangaTheme.speedlineBlue);
    drawSwitch(160);
    drawProcessBox(240, 'Process B', MangaTheme.accentOrange);
    drawSwitch(320);
    drawProcessBox(400, 'Process A', MangaTheme.speedlineBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
