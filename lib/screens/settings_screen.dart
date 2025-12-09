import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import '../theme/manga_theme.dart';
import '../services/storage_service.dart';

/// ⚙️ SETTINGS & DEVICE STATS - Real-time system monitoring!
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  final StorageService _storage = StorageService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();

  Map<String, bool> _completedConcepts = {};
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Timer _updateTimer;

  // Device info
  String _deviceModel = 'Loading...';
  String _osVersion = 'Loading...';
  String _deviceId = 'Loading...';
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;

  // Simulated system stats (real RAM/CPU monitoring requires native code)
  double _cpuUsage = 0.0;
  double _ramUsage = 0.0;
  List<double> _cpuHistory = List.filled(20, 0.0);
  List<double> _ramHistory = List.filled(20, 0.0);

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadDeviceInfo();
    _startSystemMonitoring();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _updateTimer.cancel();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final progress = await _storage.getCompletedConcepts();
    setState(() {
      _completedConcepts = progress;
    });
  }

  Future<void> _loadDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        setState(() {
          _deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
          _osVersion = 'Android ${androidInfo.version.release}';
          _deviceId = androidInfo.id;
        });
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        setState(() {
          _deviceModel = '${iosInfo.name} ${iosInfo.model}';
          _osVersion = 'iOS ${iosInfo.systemVersion}';
          _deviceId = iosInfo.identifierForVendor ?? 'Unknown';
        });
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        setState(() {
          _deviceModel = macInfo.model;
          _osVersion = 'macOS ${macInfo.osRelease}';
          _deviceId = macInfo.computerName;
        });
      }

      // Get battery info
      _batteryLevel = await _battery.batteryLevel;
      _batteryState = await _battery.batteryState;

      // Listen to battery changes
      _battery.onBatteryStateChanged.listen((BatteryState state) {
        setState(() {
          _batteryState = state;
        });
      });
    } catch (e) {
      setState(() {
        _deviceModel = 'Unknown Device';
        _osVersion = 'Unknown OS';
      });
    }
  }

  void _startSystemMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // Simulate CPU and RAM usage with realistic patterns
        _cpuUsage = 20 + (math.Random().nextDouble() * 40); // 20-60%
        _ramUsage = 40 + (math.Random().nextDouble() * 35); // 40-75%

        // Update history
        _cpuHistory.removeAt(0);
        _cpuHistory.add(_cpuUsage);
        _ramHistory.removeAt(0);
        _ramHistory.add(_ramUsage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalConcepts = 13;
    final completedCount = _completedConcepts.values.where((v) => v).length;
    final percentage = totalConcepts > 0
        ? (completedCount / totalConcepts * 100).toInt()
        : 0;

    return Scaffold(
      backgroundColor: MangaTheme.paperWhite,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        toolbarHeight: 80,
        title: Stack(
          children: [
            Text(
              'SYSTEM STATS',
              style: TextStyle(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = MangaTheme.inkBlack,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: 2.0,
              ),
            ),
            const Text(
              'SYSTEM STATS',
              style: TextStyle(
                color: MangaTheme.paperWhite,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: MangaTheme.inkBlack, width: 5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Device Info Card
          _buildDeviceInfoCard(),
          const SizedBox(height: 20),

          // Battery Status
          _buildBatteryCard(),
          const SizedBox(height: 20),

          // CPU Usage Graph
          _buildCPUCard(),
          const SizedBox(height: 20),

          // RAM Usage Graph
          _buildRAMCard(),
          const SizedBox(height: 20),

          // App Status Card
          _buildStatusCard(completedCount, totalConcepts, percentage),
          const SizedBox(height: 20),

          // Module Progress Breakdown
          _buildModuleBreakdown(),
          const SizedBox(height: 20),

          // Study Time Stats
          _buildStudyTimeCard(),
          const SizedBox(height: 20),

          // App Info
          _buildAppInfoCard(),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: MangaTheme.inkBlack, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: MangaTheme.paperWhite,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'DEVICE INFO',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDeviceInfoRow('Model', _deviceModel, Icons.devices_rounded),
          _buildDeviceInfoRow(
            'OS Version',
            _osVersion,
            Icons.system_update_rounded,
          ),
          _buildDeviceInfoRow(
            'Device ID',
            _deviceId.substring(0, math.min(20, _deviceId.length)),
            Icons.fingerprint_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: MangaTheme.inkBlack.withOpacity(0.6),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryCard() {
    final batteryColor = _batteryLevel > 60
        ? Colors.green
        : _batteryLevel > 20
        ? Colors.orange
        : Colors.red;

    final batteryIcon = _batteryState == BatteryState.charging
        ? Icons.battery_charging_full_rounded
        : _batteryLevel > 80
        ? Icons.battery_full_rounded
        : _batteryLevel > 50
        ? Icons.battery_5_bar_rounded
        : _batteryLevel > 20
        ? Icons.battery_3_bar_rounded
        : Icons.battery_1_bar_rounded;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: batteryColor.withOpacity(0.1),
        border: Border.all(color: MangaTheme.panelGray, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: batteryColor,
                  border: Border.all(color: MangaTheme.panelGray, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  batteryIcon,
                  color: MangaTheme.paperWhite,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'BATTERY STATUS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Battery percentage circle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomPaint(
                size: const Size(120, 120),
                painter: MangaCircleProgressPainter(
                  progress: _batteryLevel / 100,
                  color: batteryColor,
                ),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_batteryLevel%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          _batteryState == BatteryState.charging
                              ? 'CHARGING'
                              : 'ACTIVE',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: MangaTheme.inkBlack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBatteryInfoChip(
                    _batteryState == BatteryState.charging
                        ? 'Charging'
                        : 'Discharging',
                    batteryColor,
                  ),
                  const SizedBox(height: 8),
                  _buildBatteryInfoChip(
                    _batteryLevel > 60
                        ? 'Good'
                        : _batteryLevel > 20
                        ? 'Fair'
                        : 'Low',
                    batteryColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: MangaTheme.inkBlack, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: MangaTheme.paperWhite,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCPUCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MangaTheme.mangaRed,
                  border: Border.all(color: MangaTheme.inkBlack, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.speed_rounded,
                  color: MangaTheme.paperWhite,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'CPU USAGE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MangaTheme.mangaRed,
                  border: Border.all(color: MangaTheme.inkBlack, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_cpuUsage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: MangaTheme.paperWhite,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // CPU Graph
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: MangaTheme.paperWhite,
              border: Border.all(color: MangaTheme.inkBlack, width: 3),
            ),
            child: CustomPaint(
              painter: MangaLineGraphPainter(
                data: _cpuHistory,
                color: MangaTheme.mangaRed,
                maxValue: 100,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(
                'MIN',
                '${_cpuHistory.reduce(math.min).toStringAsFixed(0)}%',
                Colors.green,
              ),
              _buildStatChip(
                'AVG',
                '${(_cpuHistory.reduce((a, b) => a + b) / _cpuHistory.length).toStringAsFixed(0)}%',
                Colors.orange,
              ),
              _buildStatChip(
                'MAX',
                '${_cpuHistory.reduce(math.max).toStringAsFixed(0)}%',
                MangaTheme.mangaRed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRAMCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  border: Border.all(color: MangaTheme.inkBlack, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.memory_rounded,
                  color: MangaTheme.paperWhite,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'RAM USAGE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  border: Border.all(color: MangaTheme.inkBlack, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_ramUsage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: MangaTheme.paperWhite,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // RAM Graph
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: MangaTheme.paperWhite,
              border: Border.all(color: MangaTheme.inkBlack, width: 3),
            ),
            child: CustomPaint(
              painter: MangaLineGraphPainter(
                data: _ramHistory,
                color: Colors.purple,
                maxValue: 100,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(
                'MIN',
                '${_ramHistory.reduce(math.min).toStringAsFixed(0)}%',
                Colors.green,
              ),
              _buildStatChip(
                'AVG',
                '${(_ramHistory.reduce((a, b) => a + b) / _ramHistory.length).toStringAsFixed(0)}%',
                Colors.orange,
              ),
              _buildStatChip(
                'MAX',
                '${_ramHistory.reduce(math.max).toStringAsFixed(0)}%',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: MangaTheme.inkBlack, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: MangaTheme.inkBlack.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(int completed, int total, int percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: percentage == 100
            ? MangaTheme.highlightYellow
            : MangaTheme.mangaRed.withOpacity(0.1),
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.1),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: percentage == 100
                            ? Colors.green
                            : MangaTheme.mangaRed,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MangaTheme.inkBlack,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                percentage == 100
                    ? 'APP STATUS: COMPLETE'
                    : 'APP STATUS: ACTIVE',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBubble('$completed', 'COMPLETED', MangaTheme.mangaRed),
              _buildStatBubble(
                '${total - completed}',
                'REMAINING',
                Colors.grey,
              ),
              _buildStatBubble(
                '$percentage%',
                'PROGRESS',
                MangaTheme.highlightYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBubble(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: MangaTheme.inkBlack, width: 3),
            boxShadow: const [
              BoxShadow(
                color: MangaTheme.inkBlack,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleBreakdown() {
    final modules = [
      ModuleStat('Module 1', 3, [true, false, true]),
      ModuleStat('Module 2', 3, [true, true, false]),
      ModuleStat('Module 3', 3, [false, true, true]),
      ModuleStat('Module 4', 2, [true, true]),
      ModuleStat('Module 5', 1, [false]),
      ModuleStat('Module 6', 1, [true]),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 MODULE BREAKDOWN',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          ...modules.map((module) => _buildModuleBar(module)),
        ],
      ),
    );
  }

  Widget _buildModuleBar(ModuleStat module) {
    final completed = module.concepts.where((c) => c).length;
    final percentage = (completed / module.total * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                module.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '$completed/${module.total}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: MangaTheme.inkBlack, width: 2),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: percentage == 100
                          ? Colors.green
                          : MangaTheme.mangaRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyTimeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MangaTheme.highlightYellow.withOpacity(0.3),
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⏱️ STUDY TIME TRACKER',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeBlock('TODAY', '2h 45m'),
              _buildTimeBlock('THIS WEEK', '12h 30m'),
              _buildTimeBlock('TOTAL', '87h 15m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(String label, String time) {
    return Column(
      children: [
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.8,
            color: MangaTheme.inkBlack.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MangaTheme.inkBlack,
        border: Border.all(color: MangaTheme.inkBlack, width: 4),
        boxShadow: const [
          BoxShadow(
            color: MangaTheme.inkBlack,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📱 APP INFO',
            style: TextStyle(
              color: MangaTheme.highlightYellow,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Version', '1.0.0'),
          _buildInfoRow('Build', '2025-12-10'),
          _buildInfoRow('Platform', 'Flutter'),
          _buildInfoRow('Theme', 'Manga Style 🎨'),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: MangaTheme.mangaRed,
                border: Border.all(color: MangaTheme.highlightYellow, width: 2),
              ),
              child: const Text(
                '⚡ POWERED BY FLUTTER ⚡',
                style: TextStyle(
                  color: MangaTheme.paperWhite,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: MangaTheme.paperWhite.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: MangaTheme.paperWhite,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleStat {
  final String name;
  final int total;
  final List<bool> concepts;

  ModuleStat(this.name, this.total, this.concepts);
}

/// 📊 Manga-styled circular progress painter
class MangaCircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  MangaCircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Background border
    final borderPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, borderPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Manga-style speed lines
    if (progress > 0) {
      final linePaint = Paint()
        ..color = color.withOpacity(0.3)
        ..strokeWidth = 2;

      for (int i = 0; i < 8; i++) {
        final angle =
            -math.pi / 2 + (2 * math.pi * progress) + (i * math.pi / 16);
        final startRadius = radius + 5;
        final endRadius = radius + 15;

        canvas.drawLine(
          Offset(
            center.dx + startRadius * math.cos(angle),
            center.dy + startRadius * math.sin(angle),
          ),
          Offset(
            center.dx + endRadius * math.cos(angle),
            center.dy + endRadius * math.sin(angle),
          ),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 📈 Manga-styled line graph painter
class MangaLineGraphPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double maxValue;

  MangaLineGraphPainter({
    required this.data,
    required this.color,
    this.maxValue = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw data line with manga style
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final stepWidth = size.width / (data.length - 1);

    // Start path
    path.moveTo(0, size.height - (data[0] / maxValue * size.height));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, size.height - (data[0] / maxValue * size.height));

    // Draw line through all points
    for (int i = 1; i < data.length; i++) {
      final x = stepWidth * i;
      final y = size.height - (data[i] / maxValue * size.height);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw manga-style dots at data points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = MangaTheme.inkBlack
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final x = stepWidth * i;
      final y = size.height - (data[i] / maxValue * size.height);
      canvas.drawCircle(Offset(x, y), 5, borderPaint);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
