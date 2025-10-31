import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthStore extends ChangeNotifier {
  AuthStore({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _user = _auth.currentUser;
    _subscription = _auth.userChanges().listen((user) {
      _user = user;
      _initializing = false;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _initializing = true;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isInitializing => _initializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signInWithEmail(String email, String password) async {
    await _runAuthAction(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await _runAuthAction(() async {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signInWithGoogle() async {
    await _runAuthAction(() async {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        await _auth.signInWithPopup(provider);
        return;
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const _AuthOperationCancelled();
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    });
  }

  Future<void> signInWithApple() async {
    await _runAuthAction(() async {
      if (kIsWeb || (!Platform.isIOS && !Platform.isMacOS)) {
        throw const _AuthUnsupportedOperation('Apple 로그인을 지원하지 않는 플랫폼이에요.');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
    });
  }

  Future<void> signOut() async {
    try {
      _setError(null);
      await _auth.signOut();
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      _setError('로그아웃에 실패했어요. 잠시 후 다시 시도해주세요.');
      rethrow;
    }
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    _setLoading(true);
    _setError(null);
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseAuthError(e));
    } on _AuthOperationCancelled {
      _setError(null);
    } on _AuthUnsupportedOperation catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('요청을 처리할 수 없어요. 인터넷 연결을 확인하고 다시 시도해주세요.');
    } finally {
      _setLoading(false);
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return '이메일 주소 형식이 올바르지 않아요.';
      case 'user-disabled':
        return '해당 계정은 비활성화 상태예요.';
      case 'user-not-found':
        return '일치하는 계정을 찾을 수 없어요.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않아요.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일이에요.';
      case 'weak-password':
        return '비밀번호가 너무 간단해요. 더 복잡하게 설정해주세요.';
      case 'account-exists-with-different-credential':
        return '다른 로그인 방법으로 이미 가입된 계정이에요.';
      case 'credential-already-in-use':
        return '이미 연결된 계정이에요.';
      case 'operation-not-allowed':
        return '해당 로그인 방법이 비활성화되어 있어요.';
      case 'too-many-requests':
        return '요청이 너무 많이 발생했어요. 잠시 후 다시 시도해주세요.';
      default:
        return exception.message ?? '인증 과정에서 문제가 발생했어요.';
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    if (_errorMessage == message) return;
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AuthProvider extends InheritedNotifier<AuthStore> {
  const AuthProvider({
    super.key,
    required AuthStore store,
    required super.child,
  }) : super(notifier: store);

  static AuthStore of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final provider =
          context.dependOnInheritedWidgetOfExactType<AuthProvider>();
      assert(provider != null, 'AuthProvider not found in context');
      return provider!.notifier!;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<AuthProvider>();
      final widget = element?.widget as AuthProvider?;
      assert(widget != null, 'AuthProvider not found in context');
      return widget!.notifier!;
    }
  }
}

class _AuthOperationCancelled implements Exception {
  const _AuthOperationCancelled();
}

class _AuthUnsupportedOperation implements Exception {
  const _AuthUnsupportedOperation(this.message);

  final String message;
}
