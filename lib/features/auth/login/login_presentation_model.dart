import 'package:dartz/dartz.dart';
import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';

/// Model used by presenter, contains fields that are relevant to presenters and implements ViewModel to expose data to view (page)
class LoginPresentationModel implements LoginViewModel {
  /// Creates the initial state
  LoginPresentationModel.initial(
      // ignore: avoid_unused_constructor_parameters
      LoginInitialParams initialParams,
      ) : loginResult = const FutureResult.empty();

  /// Used for the copyWith method
  LoginPresentationModel._(
      String? userName,
      String? password,
      bool? isEnabled,
      this.loginResult,
      ) {
    setPassword = password ?? '';
    setUserName = userName ?? '';
    setSignInButtonEnabled = isEnabled ?? false;

  }

  final FutureResult<Either<LogInFailure, User>> loginResult;

  String? _userName;
  String? _password;
  bool? _signInButtonEnabled;

  @override
  String get userName => _userName ?? '';

  @override
  String get password => _password ?? '';

  @override
  bool get signInButtonEnabled => _signInButtonEnabled ?? false;

  @override
  bool get isLoading => loginResult.isPending();

  set setPassword(String password) => _password = password;

  set setUserName(String userName) => _userName = userName;

  set setSignInButtonEnabled(bool signInButtonEnabled) =>
      _signInButtonEnabled = signInButtonEnabled;

  LoginPresentationModel copyWith({
    FutureResult<Either<LogInFailure, User>>? loginResult,
    required String userName,
    required String password,
    required bool isEnabled,
  }) {
    return LoginPresentationModel._(
      userName,
      password,
      isEnabled,
      loginResult ?? this.loginResult,
    );
  }
}

/// Interface to expose fields used by the view (page).
abstract class LoginViewModel {
  /// [signInButtonEnabled] enable or disable signInButton based on username and password fields status
  bool get signInButtonEnabled;

  bool get isLoading;

  String get userName;

  String get password;
}
