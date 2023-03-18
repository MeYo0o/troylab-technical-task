import 'package:bloc/bloc.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';

import 'package:flutter_demo/core/utils/either_extensions.dart';
import 'package:flutter_demo/dependency_injection/app_component.dart';
import 'package:flutter_demo/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/localization/app_localizations_utils.dart';

class LoginPresenter extends Cubit<LoginViewModel> {
  LoginPresenter(
      LoginPresentationModel super.model,
      this.navigator,
      );

  final LoginNavigator navigator;

  // ignore: unused_element
  LoginPresentationModel get _model => state as LoginPresentationModel;

  /// [userNameChanged] called whenever user start type on userName text field
  void userNameChanged(String value) {
    _model.setUserName = value;
    validateLoginFormFields();
  }

  /// [passwordChanged] called whenever user start type on password text field
  void passwordChanged(String value) {
    _model.setPassword = value;
    validateLoginFormFields();
  }

  /// [validateLoginFormFields] used to check login form fields and handle button enabling / disabling
  void validateLoginFormFields() {
    _model.setSignInButtonEnabled =
        _model.password.isNotEmpty && _model.userName.trim().isNotEmpty;
    emit(
      _model.copyWith(
        userName: _model.userName,
        password: _model.password,
        isEnabled: _model.signInButtonEnabled,
      ),
    );
  }

  ///[signInClicked] called when user able to click login button
  Future<void> signInClicked() async {
    await await getIt<LogInUseCase>()
        .execute(username: _model.userName, password: _model.password)
        .observeStatusChanges((result) {
      emit(
        _model.copyWith(
          userName: _model.userName,
          password: _model.password,
          isEnabled: _model.signInButtonEnabled,
          loginResult: result,
        ),
      );
    }).asyncFold(
          (fail) => navigator.showError(fail.displayableFailure()),
          (success) => navigator.showAlert(
        title: appLocalizations.gratz,
        message: appLocalizations.easterEgg,
      ),
    );
  }
}
