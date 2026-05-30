// main.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

// ─── Splash Screen ────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _taglineFade =
        CurvedAnimation(parent: _taglineController, curve: Curves.easeIn);

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Staggered entrance
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _taglineController.forward();

    // Hold splash for a moment then navigate
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const QuotePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo icon
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoFade,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Text(
                      '\u201C',
                      style: TextStyle(
                        fontSize: 64,
                        height: 1.1,
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // App name
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Text(
                  'Daily Quotes',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                'Inspiration at your fingertips',
                style: TextStyle(
                  fontSize: 15,
                  color: cs.onPrimary.withOpacity(0.75),
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 80),

            // Subtle loading dots
            FadeTransition(
              opacity: _taglineFade,
              child: _LoadingDots(color: cs.onPrimary.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated three-dot loader
class _LoadingDots extends StatefulWidget {
  final Color color;
  const _LoadingDots({required this.color});

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _animations = _controllers
        .map((c) =>
            Tween<double>(begin: 0, end: -8).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Quote Model ──────────────────────────────────────────────────────────────
class Quote {
  final String text;
  final String author;
  final bool isLocal;

  const Quote({required this.text, required this.author, this.isLocal = false});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json['content'] as String,
        author: json['author'] as String,
        isLocal: false,
      );
}

// ─── Bundled offline quotes ───────────────────────────────────────────────────
const List<Quote> kLocalQuotes = [
  Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs", isLocal: true),
  Quote(text: "In the middle of every difficulty lies opportunity.", author: "Albert Einstein", isLocal: true),
  Quote(text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius", isLocal: true),
  Quote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon", isLocal: true),
  Quote(text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", isLocal: true),
  Quote(text: "Success is not final, failure is not fatal — it is the courage to continue that counts.", author: "Winston Churchill", isLocal: true),
  Quote(text: "The only impossible journey is the one you never begin.", author: "Tony Robbins", isLocal: true),
  Quote(text: "In three words I can sum up everything I've learned about life: it goes on.", author: "Robert Frost", isLocal: true),
  Quote(text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky", isLocal: true),
  Quote(text: "Whether you think you can or you think you can't, you're right.", author: "Henry Ford", isLocal: true),
  Quote(text: "The mind is everything. What you think you become.", author: "Buddha", isLocal: true),
  Quote(text: "An unexamined life is not worth living.", author: "Socrates", isLocal: true),
  Quote(text: "Spread love everywhere you go. Let no one ever come to you without leaving happier.", author: "Mother Teresa", isLocal: true),
  Quote(text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", author: "Nelson Mandela", isLocal: true),
  Quote(text: "Happiness is not something ready-made. It comes from your own actions.", author: "Dalai Lama", isLocal: true),
  Quote(text: "Do not go where the path may lead; go instead where there is no path and leave a trail.", author: "Ralph Waldo Emerson", isLocal: true),
  Quote(text: "You will face many defeats in life, but never let yourself be defeated.", author: "Maya Angelou", isLocal: true),
  Quote(text: "Tell me and I forget. Teach me and I remember. Involve me and I learn.", author: "Benjamin Franklin", isLocal: true),
  Quote(text: "The secret of getting ahead is getting started.", author: "Mark Twain", isLocal: true),
  Quote(text: "It always seems impossible until it's done.", author: "Nelson Mandela", isLocal: true),
  Quote(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt", isLocal: true),
  Quote(text: "Start where you are. Use what you have. Do what you can.", author: "Arthur Ashe", isLocal: true),
  Quote(text: "Dream big and dare to fail.", author: "Norman Vaughan", isLocal: true),
  Quote(text: "Act as if what you do makes a difference. It does.", author: "William James", isLocal: true),
  Quote(text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson", isLocal: true),
];

// ─── Quote Page ───────────────────────────────────────────────────────────────
class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();

  final List<Quote> _pool = [...kLocalQuotes];
  final List<Quote> _onlineBuffer = [];

  Quote? _currentQuote;
  int _lastPoolIndex = -1;
  bool _isFetching = false;
  bool _isOnline = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _showNextFromPool(animate: false);
    _controller.forward();
    _fetchOnlineQuotes(count: 10);
  }

  void _showNextFromPool({bool animate = true}) {
    if (_onlineBuffer.isNotEmpty) {
      _pool.addAll(_onlineBuffer);
      _onlineBuffer.clear();
    }
    int index;
    do {
      index = _random.nextInt(_pool.length);
    } while (index == _lastPoolIndex && _pool.length > 1);
    _lastPoolIndex = index;
    setState(() => _currentQuote = _pool[index]);
  }

  Future<void> _newQuote() async {
    await _controller.reverse();
    _showNextFromPool();
    _controller.forward();
    if (_onlineBuffer.length < 3) _fetchOnlineQuotes(count: 8);
  }

  Future<void> _fetchOnlineQuotes({int count = 8}) async {
    if (_isFetching) return;
    setState(() => _isFetching = true);
    try {
      final uri =
          Uri.parse('https://api.quotable.io/quotes/random?limit=$count');
      final response =
          await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _onlineBuffer.addAll(data.map((j) => Quote.fromJson(j)));
          _isOnline = true;
        });
      }
    } catch (_) {
      setState(() => _isOnline = false);
    } finally {
      setState(() => _isFetching = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Daily Quotes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Tooltip(
              message: _isOnline
                  ? 'Online — live quotes active'
                  : 'Offline — using built-in quotes',
              child: Icon(
                _isOnline
                    ? Icons.cloud_done_rounded
                    : Icons.cloud_off_rounded,
                size: 20,
                color: _isOnline
                    ? cs.primary.withOpacity(0.8)
                    : cs.onSurface.withOpacity(0.35),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              Text(
                '\u201C',
                style: TextStyle(
                  fontSize: 80,
                  height: 0.8,
                  color: cs.primary.withOpacity(0.25),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: isDark
                          ? cs.surfaceContainerHighest
                          : cs.primaryContainer.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                          color: cs.primary.withOpacity(0.12)),
                    ),
                    child: _currentQuote == null
                        ? Center(
                            child: CircularProgressIndicator(
                                color: cs.primary, strokeWidth: 2))
                        : Column(
                            children: [
                              Text(
                                _currentQuote!.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.65,
                                  fontStyle: FontStyle.italic,
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 32,
                                      height: 1.5,
                                      color:
                                          cs.primary.withOpacity(0.5)),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      _currentQuote!.author,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: cs.primary,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                      width: 32,
                                      height: 1.5,
                                      color:
                                          cs.primary.withOpacity(0.5)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _currentQuote!.isLocal
                                      ? cs.surfaceContainerHighest
                                      : cs.primaryContainer
                                          .withOpacity(0.5),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _currentQuote!.isLocal
                                          ? Icons.storage_rounded
                                          : Icons.cloud_rounded,
                                      size: 12,
                                      color: _currentQuote!.isLocal
                                          ? cs.onSurface.withOpacity(0.4)
                                          : cs.primary.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _currentQuote!.isLocal
                                          ? 'Built-in'
                                          : 'Live',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _currentQuote!.isLocal
                                            ? cs.onSurface
                                                .withOpacity(0.4)
                                            : cs.primary.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const Spacer(),

              if (_isOnline)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${_pool.length + _onlineBuffer.length} quotes available',
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _newQuote,
                  icon: _isFetching
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: cs.onPrimary),
                        )
                      : const Icon(Icons.auto_awesome_rounded, size: 20),
                  label: const Text(
                    'New Quote',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                _isOnline
                    ? 'Powered by Quotable API • Infinite quotes'
                    : '25 built-in quotes • Connect for more',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withOpacity(0.35),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}