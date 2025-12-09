import 'package:flutter/material.dart';
import '../../theme/manga_theme.dart';

/// Gantt Chart for Scheduling Algorithms
class GanttChartDiagram extends StatelessWidget {
  final List<GanttProcess> processes;
  final String title;

  const GanttChartDiagram({
    super.key,
    required this.processes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MangaTheme.inkBlack,
          ),
        ),
        const SizedBox(height: 12),
        CustomPaint(
          size: Size(double.infinity, 100 + (processes.length * 50)),
          painter: _GanttChartPainter(processes),
        ),
      ],
    );
  }
}

class GanttProcess {
  final String name;
  final int startTime;
  final int endTime;
  final Color color;

  GanttProcess({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

class _GanttChartPainter extends CustomPainter {
  final List<GanttProcess> processes;

  _GanttChartPainter(this.processes);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Find max time
    int maxTime = 0;
    for (var p in processes) {
      if (p.endTime > maxTime) maxTime = p.endTime;
    }

    final timelineHeight = 60.0;
    final processHeight = 40.0;
    final padding = 20.0;
    final chartWidth = size.width - 100;
    final pixelsPerUnit = chartWidth / maxTime;

    // Draw timeline
    final linePaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(padding, timelineHeight),
      Offset(padding + chartWidth, timelineHeight),
      linePaint,
    );

    // Draw time markers
    for (int i = 0; i <= maxTime; i++) {
      final x = padding + (i * pixelsPerUnit);
      canvas.drawLine(
        Offset(x, timelineHeight),
        Offset(x, timelineHeight + 10),
        linePaint,
      );

      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: MangaTheme.inkBlack,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, timelineHeight + 15),
      );
    }

    // Draw processes
    for (var i = 0; i < processes.length; i++) {
      final p = processes[i];
      final y = timelineHeight + 40 + (i * 50);
      final x = padding + (p.startTime * pixelsPerUnit);
      final width = (p.endTime - p.startTime) * pixelsPerUnit;

      // Draw process box
      final rect = Rect.fromLTWH(x, y, width, processHeight);

      final fillPaint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = MangaTheme.inkBlack
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, borderPaint);

      // Draw process name
      textPainter.text = TextSpan(
        text: p.name,
        style: const TextStyle(
          color: MangaTheme.inkBlack,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x + (width / 2) - (textPainter.width / 2),
          y + (processHeight / 2) - (textPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Preemptive vs Non-Preemptive Comparison
class PreemptiveComparisonDiagram extends StatelessWidget {
  const PreemptiveComparisonDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            'NON-PREEMPTIVE',
            [
              'Process runs till completion',
              'No interruption',
              'Simple implementation',
              'Poor response time',
              'Example: FCFS, SJF',
            ],
            MangaTheme.speedlineBlue,
            Icons.lock,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: const Text(
            'VS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: MangaTheme.mangaRed,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCard(
            'PREEMPTIVE',
            [
              'Can be interrupted',
              'Better response time',
              'Complex implementation',
              'Context switching overhead',
              'Example: SRTF, RR',
            ],
            MangaTheme.accentOrange,
            Icons.swap_horiz,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    String title,
    List<String> points,
    Color color,
    IconData icon,
  ) {
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
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(point, style: const TextStyle(fontSize: 12)),
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

/// Round Robin Time Quantum Visualization
class RoundRobinDiagram extends StatelessWidget {
  const RoundRobinDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _RoundRobinPainter(),
    );
  }
}

class _RoundRobinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw ready queue
    final queueY = 40.0;
    final boxWidth = 60.0;
    final boxHeight = 50.0;

    final processes = ['P1', 'P2', 'P3', 'P4'];
    final colors = [
      MangaTheme.mangaRed,
      MangaTheme.speedlineBlue,
      MangaTheme.accentOrange,
      MangaTheme.highlightYellow,
    ];

    // Draw queue label
    textPainter.text = const TextSpan(
      text: 'READY QUEUE',
      style: TextStyle(
        color: MangaTheme.inkBlack,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, queueY - 25));

    // Draw processes in queue
    for (int i = 0; i < processes.length; i++) {
      final x = 20 + (i * (boxWidth + 10));
      final rect = Rect.fromLTWH(x, queueY, boxWidth, boxHeight);

      final fillPaint = Paint()
        ..color = colors[i].withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = MangaTheme.inkBlack
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, fillPaint);
      canvas.drawRect(rect, borderPaint);

      textPainter.text = TextSpan(
        text: processes[i],
        style: const TextStyle(
          color: MangaTheme.inkBlack,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x + (boxWidth / 2) - (textPainter.width / 2),
          queueY + (boxHeight / 2) - (textPainter.height / 2),
        ),
      );
    }

    // Draw CPU box
    final cpuY = queueY + 100;
    final cpuRect = Rect.fromLTWH(size.width / 2 - 60, cpuY, 120, 60);

    final cpuPaint = Paint()
      ..color = MangaTheme.mangaRed
      ..style = PaintingStyle.fill;

    final cpuBorderPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(cpuRect, cpuPaint);
    canvas.drawRect(cpuRect, cpuBorderPaint);

    textPainter.text = const TextSpan(
      text: 'CPU\n(Time Slice)',
      style: TextStyle(
        color: MangaTheme.paperWhite,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout(maxWidth: 100);
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, cpuY + 15),
    );

    // Draw arrow from queue to CPU
    final arrowPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arrowPath = Path();
    arrowPath.moveTo(20 + boxWidth / 2, queueY + boxHeight);
    arrowPath.lineTo(size.width / 2, cpuY);
    canvas.drawPath(arrowPath, arrowPaint);

    // Draw arrow back to queue
    final backArrowPath = Path();
    backArrowPath.moveTo(size.width / 2 + 60, cpuY + 30);
    backArrowPath.quadraticBezierTo(
      size.width / 2 + 100,
      cpuY - 20,
      20 + (boxWidth + 10) * 3 + boxWidth / 2,
      queueY + boxHeight,
    );
    canvas.drawPath(backArrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
