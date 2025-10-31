import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../state/auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canShowAppleSignIn {
    if (kIsWeb) return false;
    final platform = defaultTargetPlatform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSignIn(AuthStore authStore) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    FocusScope.of(context).unfocus();
    await authStore.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    final error = authStore.errorMessage;
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _handleGoogleSignIn(AuthStore authStore) async {
    FocusScope.of(context).unfocus();
    await authStore.signInWithGoogle();
    if (!mounted) return;
    final error = authStore.errorMessage;
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _handleAppleSignIn(AuthStore authStore) async {
    FocusScope.of(context).unfocus();
    await authStore.signInWithApple();
    if (!mounted) return;
    final error = authStore.errorMessage;
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStore = AuthProvider.of(context, listen: false);
    return AnimatedBuilder(
      animation: authStore,
      builder: (context, _) {
        final isLoading = authStore.isLoading;
        final theme = Theme.of(context);
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/images/Ttotoy_under_title.webp',
                        height: 96,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'TtoToy에 오신 것을 환영해요!',
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '로그인 후 다양한 장난감을 만나보세요.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              enabled: !isLoading,
                              decoration: const InputDecoration(
                                labelText: '이메일',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '이메일을 입력해주세요.';
                                }
                                if (!value.contains('@')) {
                                  return '올바른 이메일 주소가 아니에요.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              autofillHints: const [AutofillHints.password],
                              enabled: !isLoading,
                              decoration: const InputDecoration(
                                labelText: '비밀번호',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '비밀번호를 입력해주세요.';
                                }
                                if (value.length < 6) {
                                  return '비밀번호는 6자 이상이어야 해요.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: isLoading ? null : () => _handleEmailSignIn(authStore),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('로그인'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignupPage(),
                                        ),
                                      );
                                    },
                              child: const Text('계정이 없으신가요? 회원가입'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(child: Divider(color: theme.dividerColor)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('또는'),
                          ),
                          Expanded(child: Divider(color: theme.dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : () => _handleGoogleSignIn(authStore),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.g_translate, size: 24),
                            const SizedBox(width: 12),
                            const Text('Google로 계속하기'),
                          ],
                        ),
                      ),
                      if (_canShowAppleSignIn) ...[
                        const SizedBox(height: 12),
                        //SignInWithAppleButton(
                          //onPressed: isLoading ? null : () => _handleAppleSignIn(authStore),
                          //style: SignInWithAppleButtonStyle.black,
                          //borderRadius: BorderRadius.circular(10),
                        //),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
