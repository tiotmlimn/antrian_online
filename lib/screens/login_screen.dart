import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _bgAnimController;
  late AnimationController _floatController;
  late Animation<Offset> _floatAnim;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnim = Tween<Offset>(
      begin: const Offset(0, -8),
      end: const Offset(0, 8),
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildAnimatedBackground(),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 1),
                  _buildHeader(),
                  const Spacer(flex: 2),
                  _buildStartButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgAnimController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                  const Color(0xFF1E3A5F),
                  const Color(0xFF2D1B69),
                  _bgAnimController.value,
                )!,
                Color.lerp(
                  const Color(0xFF3D1B40),
                  const Color(0xFF1A1B4E),
                  _bgAnimController.value,
                )!,
                Color.lerp(
                  const Color(0xFF0F2D3A),
                  const Color(0xFF1A2A4A),
                  _bgAnimController.value,
                )!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60,
                right: -40,
                child: _buildFloatingShape(180, 180, Colors.black.withValues(alpha: 0.06), 30),
              ),
              Positioned(
                bottom: 80,
                left: -50,
                child: _buildFloatingShape(220, 220, Colors.black.withValues(alpha: 0.04), 40),
              ),
              Positioned(
                top: 200,
                left: -30,
                child: _buildFloatingShape(120, 120, Colors.black.withValues(alpha: 0.05), 20),
              ),
              Positioned(
                bottom: 200,
                right: -20,
                child: _buildFloatingShape(100, 100, Colors.black.withValues(alpha: 0.07), 15),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingShape(double w, double h, Color color, double radius) {
    return Transform.rotate(
      angle: math.pi / 4,
      child: SlideTransition(
        position: _floatAnim,
        child: Container(
          width: w, height: h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/unpam.png', width: 80, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(height: 24),
        const Text(
          "UNPAM Health Care",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Antre Tanpa Ribet,\nSehat Tanpa Menunggu.",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.7),
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_rounded, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'Universitas Pamulang',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: () => _showSignInDialog(context),
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Silahkan Login",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignInDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.08),
      barrierLabel: "Sign In",
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      pageBuilder: (context, a, b) => Stack(
        children: [
          Positioned(
            top: -50, left: -50, right: -50, bottom: -50,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.black.withValues(alpha: 0.15)),
              ),
            ),
          ),
          Center(
            child: GlassCard(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              borderRadius: 32,
              padding: const EdgeInsets.all(28),
              child: const SignInForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;
  late AnimationController _loadingController;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _rotationAnim = Tween<double>(begin: 0, end: 2 * math.pi)
      .animate(CurvedAnimation(parent: _loadingController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _isLoading = true);
    _loadingController.repeat();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final success = auth.login(_emailC.text.trim(), _passC.text);

      _loadingController.stop();

      if (success) {
        setState(() => _isLoading = false);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _isError = false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Silahkan Masuk", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
                      Text("Masuk ke akun Anda", style: TextStyle(fontSize: 13, color: AppTheme.lightText)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _buildField('Email', _emailC, Icons.email_outlined, false, 'Masukkan email'),
              const SizedBox(height: 16),
              _buildField('Password', _passC, Icons.lock_outline, true, 'Minimal 6 karakter'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hubungi admin untuk reset password')),
                    );
                  },
                  child: Text('Lupa password?', style: TextStyle(color: AppTheme.primaryIndigo.withValues(alpha: 0.6), fontSize: 12)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryIndigo,
                    disabledBackgroundColor: AppTheme.primaryIndigo.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? AnimatedBuilder(
                          animation: _rotationAnim,
                          builder: (context, child) => Transform.rotate(
                            angle: _rotationAnim.value,
                            child: const Icon(Icons.sync_rounded, color: Colors.white, size: 24),
                          ),
                        )
                      : const Text("Masuk", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Atau', style: TextStyle(color: AppTheme.lightText.withValues(alpha: 0.5), fontSize: 12)),
                  ),
                  const Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              const SizedBox(height: 24),
              _buildGoogleLoginButton(),
              if (_isError) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text('Email atau password salah', style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String hint, TextEditingController c, IconData icon, bool obscure, String errMsg) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      style: TextStyle(color: AppTheme.darkText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.lightText.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppTheme.primaryIndigo, size: 22),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.primaryIndigo, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return errMsg;
        if (!obscure && !v.contains('@')) return 'Email tidak valid';
        if (obscure && v.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
    );
  }

  Widget _buildGoogleLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _googleLogin,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(4),
              child: Image.asset('assets/google.png', width: 35, height: 35),
        ),
        label: Text('Masuk dengan Google', style: TextStyle(color: AppTheme.lightText, fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  void _googleLogin() {
    setState(() => _isLoading = true);
    _loadingController.repeat();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      final success = auth.login(_emailC.text.trim(), _passC.text);

      _loadingController.stop();

      if (success) {
        setState(() => _isLoading = false);
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _isError = false);
        });
      }
    });
  }
}
