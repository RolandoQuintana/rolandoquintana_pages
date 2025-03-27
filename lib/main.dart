import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'components/gradient_card.dart';
import 'components/animated_button.dart';
import 'components/glassmorphic_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload Google Fonts
  try {
    await GoogleFonts.pendingFonts();
  } catch (e) {
    print('Error loading Google Fonts: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolando Quintana',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
          secondary: const Color(0xFF00FFA3),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showContent = false;
  bool _fontsLoaded = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {
    'WELCOME': GlobalKey(),
    'PROJECTS': GlobalKey(),
    'EXPERIENCE': GlobalKey(),
    'ABOUT': GlobalKey(),
  };
  final Map<String, bool> _sectionVisible = {
    'WELCOME': false,
    'PROJECTS': false,
    'EXPERIENCE': false,
    'ABOUT': false,
  };
  String _activeSection = 'WELCOME';
  int _currentSlideIndex = 0;

  final List<HeroSlide> _heroSlides = [
    HeroSlide(
      title: 'SOFTWARE\nDEVELOPER.',
      subtitle: 'Creating innovative solutions through code and design.',
      imageUrl: 'https://picsum.photos/1200/800?random=0',
    ),
    HeroSlide(
      title: 'PRODUCT\nDESIGNER.',
      subtitle: 'Crafting intuitive experiences that delight users.',
      imageUrl: 'https://picsum.photos/1200/800?random=1',
    ),
    HeroSlide(
      title: 'TECH\nINNOVATOR.',
      subtitle: 'Pushing boundaries in the digital realm.',
      imageUrl: 'https://picsum.photos/1200/800?random=2',
    ),
    HeroSlide(
      title: 'CREATIVE\nTHINKER.',
      subtitle: 'Transforming ideas into reality.',
      imageUrl: 'https://picsum.photos/1200/800?random=3',
    ),
  ];

  final List<ProjectData> _projects = [
    ProjectData(
      title: 'Flutter Portfolio',
      description: 'A modern, responsive portfolio website built with Flutter',
      imageUrl: 'https://picsum.photos/800/500?random=1',
    ),
    ProjectData(
      title: 'Tech Innovation',
      description: 'Exploring the boundaries of technology',
      imageUrl: 'https://picsum.photos/800/500?random=2',
    ),
    ProjectData(
      title: 'Digital Experience',
      description: 'Creating immersive digital experiences',
      imageUrl: 'https://picsum.photos/800/500?random=3',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Check if fonts are loaded
    GoogleFonts.pendingFonts().then((_) {
      if (mounted) {
        setState(() => _fontsLoaded = true);
      }
    }).catchError((error) {
      print('Error loading fonts: $error');
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showContent = true);
        _fadeController.forward();
      }
    });

    _scrollController.addListener(() {
      _checkSectionVisibility();
      setState(() {}); // Update state for parallax effect
    });
    _startSlideshow();
  }

  void _startSlideshow() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentSlideIndex = (_currentSlideIndex + 1) % _heroSlides.length;
          _slideController.reset();
          _slideController.forward();
        });
        _startSlideshow();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkSectionVisibility() {
    for (var entry in _sectionKeys.entries) {
      final renderObject = entry.value.currentContext?.findRenderObject();
      if (renderObject is RenderBox) {
        final position = renderObject.localToGlobal(Offset.zero);
        if (position.dy < MediaQuery.of(context).size.height * 0.8) {
          setState(() {
            _sectionVisible[entry.key] = true;
            _activeSection = entry.key;
          });
        }
      }
    }
  }

  void _scrollToSection(String section) {
    final key = _sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      setState(() => _activeSection = section);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_fontsLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Main content
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    width: 600,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNavButton('WELCOME', isActive: true),
                                _buildNavButton('PROJECTS'),
                                _buildNavButton('EXPERIENCE'),
                                _buildNavButton('ABOUT'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Base background
              Container(
                color: Colors.black,
              ),
              // Subtle gradient overlays
              Positioned(
                top: -200,
                right: -100,
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6B4BA3).withOpacity(0.15),
                        const Color(0xFF6B4BA3).withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              // Scrollable content
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Hero Section
                    Container(
                      key: _sectionKeys['WELCOME'],
                      height: screenSize.height,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        children: [
                          // Hero Background Image with Parallax
                          Positioned(
                            right: -100,
                            top: screenSize.height * 0.1,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1500),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Transform.translate(
                                key: ValueKey(_currentSlideIndex),
                                offset: Offset(0, _scrollController.hasClients ? _scrollController.offset * 0.3 : 0),
                                child: Container(
                                  width: screenSize.width * 0.6,
                                  height: screenSize.height * 0.6,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_heroSlides[_currentSlideIndex].imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                        colors: [
                                          Colors.black.withOpacity(0),
                                          Colors.black.withOpacity(1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Hero Content with Parallax
                          Positioned(
                            left: 0,
                            top: screenSize.height * 0.2,
                            child: Transform.translate(
                              offset: Offset(0, _scrollController.hasClients ? _scrollController.offset * 0.1 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '• 001',
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'ROLANDO D QUINTANA',
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 3,
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: screenSize.width * 0.8,
                                    child: ScrambleText(
                                      text: _heroSlides[_currentSlideIndex].title,
                                      style: TextStyle(
                                        fontSize: screenSize.width * 0.12,
                                        height: 0.85,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -5,
                                        color: Colors.white,
                                      ),
                                      duration: const Duration(milliseconds: 2000),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: 500,
                                    child: ScrambleText(
                                      text: _heroSlides[_currentSlideIndex].subtitle,
                                      style: TextStyle(
                                        fontSize: 32,
                                        height: 1.2,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      duration: const Duration(milliseconds: 3000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Projects Section
                    Container(
                      key: _sectionKeys['PROJECTS'],
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• 002',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'A FAMILIAR\nWORLD... SET\nON A DIFFERENT\nPATH.',
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.08,
                                    height: 0.9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -3,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 2,
                                child: _buildProjectsGrid(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                    // Experience Section
                    Container(
                      key: _sectionKeys['EXPERIENCE'],
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• 003',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'PROFESSIONAL\nEXPERIENCE.',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.06,
                              height: 0.9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          GlassmorphicContainer(
                            blur: 10.0,
                            opacity: 0.1,
                            borderRadius: 16.0,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              width: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Senior Software Engineer',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      ),
                                      Text(
                                        '2020 - Present',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Company Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Led the development of multiple high-impact projects, including a complete redesign of the company\'s core platform. Implemented modern architecture patterns and best practices.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildExperienceChip('Flutter'),
                                      _buildExperienceChip('Dart'),
                                      _buildExperienceChip('Firebase'),
                                      _buildExperienceChip('Cloud Functions'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // About Section
                    Container(
                      key: _sectionKeys['ABOUT'],
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• 004',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'ABOUT ME',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.06,
                              height: 0.9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: GlassmorphicContainer(
                                  blur: 10.0,
                                  opacity: 0.1,
                                  borderRadius: 16.0,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Passionate about creating beautiful and functional digital experiences.',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'I am a software developer with a keen eye for design and a passion for creating seamless user experiences. With expertise in Flutter, React, and modern web technologies, I bring ideas to life through clean, efficient code and intuitive interfaces.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white.withOpacity(0.7),
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 1,
                                child: GlassmorphicContainer(
                                  blur: 10.0,
                                  opacity: 0.1,
                                  borderRadius: 16.0,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Skills',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _buildExperienceChip('Flutter'),
                                            _buildExperienceChip('Dart'),
                                            _buildExperienceChip('React'),
                                            _buildExperienceChip('TypeScript'),
                                            _buildExperienceChip('Firebase'),
                                            _buildExperienceChip('Node.js'),
                                            _buildExperienceChip('UI/UX Design'),
                                            _buildExperienceChip('Git'),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        AnimatedButton(
                                          text: 'Download CV',
                                          width: double.infinity,
                                          height: 45,
                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                          textColor: Colors.black,
                                          borderRadius: 8,
                                          onPressed: () {
                                            // TODO: Implement CV download
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return GlassmorphicContainer(
          blur: 10.0,
          opacity: 0.1,
          borderRadius: 16.0,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            width: 1,
          ),
          child: Stack(
            children: [
              // Project Background Image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ).createShader(bounds),
                    blendMode: BlendMode.darken,
                    child: Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Project Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'PROJECT ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedButton(
                      text: 'View Project',
                      width: 150,
                      height: 40,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Colors.black,
                      borderRadius: 8,
                      onPressed: () {
                        // TODO: Implement project view action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavButton(String text, {bool isActive = false}) {
    return TextButton(
      onPressed: () => _scrollToSection(text),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: text == _activeSection ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 14,
              letterSpacing: 1.5,
              fontWeight: text == _activeSection ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (text == _activeSection)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExperienceChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ProjectData {
  final String title;
  final String description;
  final String imageUrl;

  ProjectData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class HeroSlide {
  final String title;
  final String subtitle;
  final String imageUrl;

  HeroSlide({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

class ScrambleText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const ScrambleText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<ScrambleText> createState() => _ScrambleTextState();
}

class _ScrambleTextState extends State<ScrambleText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _displayText = '';
  String _previousText = '';
  final Random _random = Random();
  late TextPainter _textPainter;
  double _finalTextWidth = 0;

  // Use only monospace characters for scrambling to maintain consistent height
  final String _scrambleChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<>{}[]()/\\|_+-=*&^%\$#@!~';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation.addListener(_updateText);
    _previousText = widget.text;
    _displayText = widget.text;

    // Calculate the width of the final text
    _textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();
    _finalTextWidth = _textPainter.width;

    _controller.forward();
  }

  @override
  void didUpdateWidget(ScrambleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _previousText = oldWidget.text;
      // Recalculate the width of the new final text
      _textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        textDirection: TextDirection.ltr,
      )..layout();
      _finalTextWidth = _textPainter.width;
      _controller.reset();
      _controller.forward();
    }
  }

  void _updateText() {
    if (!mounted) return;

    final progress = _animation.value;

    // Split texts into lines
    final newLines = widget.text.split('\n');
    final oldLines = _previousText.split('\n');

    // Process each line separately
    final processedLines = List<String>.generate(
      max(newLines.length, oldLines.length),
      (lineIndex) {
        final newLine = lineIndex < newLines.length ? newLines[lineIndex] : '';
        final oldLine = lineIndex < oldLines.length ? oldLines[lineIndex] : '';

        final targetLength = newLine.length;
        final previousLength = oldLine.length;
        final maxLength = max(targetLength, previousLength);

        // Calculate how many characters to show from each line
        final currentLength = (maxLength * progress).round();

        if (currentLength == 0) {
          return oldLine;
        }

        final newChars = newLine.split('');
        final oldChars = oldLine.split('');

        // Pad the shorter line with spaces if needed
        while (newChars.length < maxLength) newChars.add(' ');
        while (oldChars.length < maxLength) oldChars.add(' ');

        // Only show as many characters as the final text will have
        final scrambled = List<String>.generate(targetLength, (index) {
          if (index < currentLength) {
            // Characters that have been reached are stable
            return newChars[index];
          } else if (index < previousLength) {
            // Characters that haven't been reached yet are scrambling
            return _scrambleChars[_random.nextInt(_scrambleChars.length)];
          }
          // For remaining positions, show scrambled characters
          return _scrambleChars[_random.nextInt(_scrambleChars.length)];
        });

        // Ensure the final text is exactly the new text when animation is complete
        if (progress >= 1.0) {
          return newLine;
        }

        return scrambled.join();
      },
    );

    setState(() => _displayText = processedLines.join('\n'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _finalTextWidth,
      child: Text(
        _displayText,
        style: widget.style,
      ),
    );
  }
}
