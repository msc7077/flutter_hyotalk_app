import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/extensions/context_media_query_extension.dart';
import 'package:flutter_hyotalk_app/core/theme/app_colors.dart';
import 'package:flutter_hyotalk_app/core/theme/app_dimensions.dart';
import 'package:flutter_hyotalk_app/core/theme/app_text_styles.dart';
import 'package:flutter_hyotalk_app/core/theme/app_texts.dart';
import 'package:flutter_hyotalk_app/core/widget/dialog/app_common_dialog.dart';
import 'package:flutter_hyotalk_app/core/widget/loading/app_loading_indicator.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_hyotalk_app/router/app_router_path.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  bool _isAutoLogin = false;

  @override
  void dispose() {
    _idTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // 로그인 성공 시 홈으로 이동
          context.go(AppRouterPath.home);
        } else if (state is AuthFailure) {
          AppCommonDialog.show(context, state.message, title: AppTexts.loginFailed);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: context.safeHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingW20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: AppDimensions.spacingV60,
                              bottom: AppDimensions.spacingV25,
                            ),
                            child: Text(AppTexts.login, style: AppTextStyles.text32blackW700),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _idTextEditingController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radius10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radius10),
                                      borderSide: const BorderSide(color: AppColors.primary),
                                    ),
                                    hintText: AppTexts.id,
                                    labelText: AppTexts.id,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTexts.enterId;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppDimensions.spacingV20),
                                TextFormField(
                                  controller: _passwordTextEditingController,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  keyboardType: TextInputType.visiblePassword,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radius10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppDimensions.radius10),
                                      borderSide: const BorderSide(color: AppColors.primary),
                                    ),
                                    hintText: AppTexts.password,
                                    labelText: AppTexts.password,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTexts.enterPassword;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppDimensions.spacingV20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          side: WidgetStateBorderSide.resolveWith(
                                            (states) => _isAutoLogin == true
                                                ? BorderSide(
                                                    width: AppDimensions.spacingW0_0,
                                                    color: AppColors.transparent,
                                                  )
                                                : BorderSide(
                                                    width: AppDimensions.spacingW1_5,
                                                    color: AppColors.black26,
                                                  ),
                                          ),
                                          activeColor: _isAutoLogin == true
                                              ? AppColors.primary
                                              : AppColors.transparent,
                                          value: _isAutoLogin,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isAutoLogin = value ?? false;
                                            });
                                          },
                                        ),
                                        Text(
                                          AppTexts.autoLogin,
                                          style: AppTextStyles.text13blackW400.copyWith(
                                            color: AppColors.grey4A4A4A,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppDimensions.spacingV20),
                                SizedBox(
                                  width: AppDimensions.buttonWidthFull,
                                  height: AppDimensions.buttonHeight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFFDE048),
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppDimensions.radius50),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            FocusScope.of(context).unfocus();
                                            if (_formKey.currentState!.validate()) {
                                              context.read<AuthBloc>().add(
                                                LoginRequested(
                                                  id: _idTextEditingController.text,
                                                  password: _passwordTextEditingController.text,
                                                  isAutoLogin: _isAutoLogin,
                                                ),
                                              );
                                            }
                                          },
                                    child: Text(
                                      AppTexts.login,
                                      style: AppTextStyles.text18blackW700.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppDimensions.spacingV15),
                          SizedBox(
                            width: AppDimensions.buttonWidthFull,
                            height: AppDimensions.buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: AppColors.orangeEB5E2B),
                                  borderRadius: BorderRadius.circular(AppDimensions.radius50),
                                ),
                              ),
                              onPressed: () {
                                // TODO: 회원가입 화면으로 이동
                                // context.go('/register');
                              },
                              child: Text(
                                AppTexts.register,
                                style: AppTextStyles.text16blackW700.copyWith(
                                  color: AppColors.orangeEB5E2B,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppDimensions.spacingV15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: 아이디 찾기 화면으로 이동
                                    // context.go('/find-id');
                                  },
                                  child: Text(
                                    AppTexts.findId,
                                    style: AppTextStyles.text13blackW400.copyWith(
                                      color: AppColors.grey888888,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '┃',
                                style: AppTextStyles.text12blackW400.copyWith(
                                  color: AppColors.greyA2A2A2,
                                ),
                              ),
                              Flexible(
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: 비밀번호 재설정 화면으로 이동
                                    // context.go('/reset-password');
                                  },
                                  child: Text(
                                    AppTexts.resetPassword,
                                    style: AppTextStyles.text13blackW400.copyWith(
                                      color: AppColors.grey888888,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 로딩 오버레이
                if (isLoading)
                  AbsorbPointer(
                    child: Container(
                      color: AppColors.black.withValues(alpha: 0.5),
                      child: const Center(child: AppLoadingIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
