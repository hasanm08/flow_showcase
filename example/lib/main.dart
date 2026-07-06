import 'package:flow_showcase/flow_showcase.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlowShowcaseExampleApp());
}

class FlowShowcaseExampleApp extends StatelessWidget {
  const FlowShowcaseExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Showcase Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  FlowShowcaseController? _controller;

  static const _showcaseIds = [
    'nav_home',
    'nav_search',
    'nav_notifications',
    'fab_compose',
  ];

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _startShowcase() {
    _controller?.dispose();
    _controller = FlowShowcaseController.start(
      context,
      ids: _showcaseIds,
      onComplete: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Onboarding complete!')),
        );
      },
      style: const FlowShowcaseStyle(
        nextButtonLabel: 'Continue',
        doneButtonLabel: 'Got it',
        fadeDuration: Duration(milliseconds: 280),
        showStepIndicator: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flow Showcase'),
        actions: [
          FlowShowcaseTarget(
            id: 'app_help',
            title: 'Replay Tour',
            content: 'Open this menu anytime to restart the guided tour.',
            icon: const Icon(Icons.help_outline, size: 20),
            child: IconButton(
              tooltip: 'Help',
              onPressed: _startShowcase,
              icon: const Icon(Icons.help_outline),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _HomeTab(),
          _SearchTab(),
          _AlertsTab(),
        ],
      ),
      floatingActionButton: FlowShowcaseTarget(
        id: 'fab_compose',
        title: 'Create Something New',
        content:
            'Start a draft, upload media, or share an update with one tap.',
        icon: const Icon(Icons.add, size: 20),
        child: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Compose'),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          _ShowcaseDestination(
            id: 'nav_home',
            title: 'Home Feed',
            content:
                'Your personalized timeline and recent activity live here.',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          _ShowcaseDestination(
            id: 'nav_search',
            title: 'Discover',
            content: 'Search people, tags, and trending topics across the app.',
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.manage_search),
            label: 'Search',
          ),
          _ShowcaseDestination(
            id: 'nav_notifications',
            title: 'Stay in the Loop',
            content: 'Mentions, replies, and system alerts appear in this tab.',
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Welcome back',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the help icon or press the button below to experience a '
          'multi-step spotlight tour with adaptive positioning.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            FlowShowcaseController.start(
              context,
              ids: _DashboardPageState._showcaseIds,
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Guided Tour'),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          6,
          (index) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Sample post #${index + 1}'),
              subtitle: const Text(
                  'Scrollable content stays underneath the overlay.'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchTab extends StatelessWidget {
  const _SearchTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search tab'));
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Alerts tab'));
  }
}

class _ShowcaseDestination extends StatelessWidget {
  const _ShowcaseDestination({
    required this.id,
    required this.title,
    required this.content,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final String id;
  final String title;
  final String content;
  final Widget icon;
  final Widget selectedIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FlowShowcaseTarget(
      id: id,
      title: title,
      content: content,
      icon: icon,
      child: NavigationDestination(
        icon: icon,
        selectedIcon: selectedIcon,
        label: label,
      ),
    );
  }
}
