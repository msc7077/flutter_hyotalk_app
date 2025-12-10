import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_hyotalk_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          context.go('/home');
        } else if (state is AuthFailure) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('로그인 실패'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 60.h, bottom: 25.h),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            hintText: '아이디',
                            labelText: '아이디',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _passwordTextEditingController,
                          obscureText: true,
                          enableSuggestions: false,
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: Colors.amber),
                            ),
                            hintText: '비밀번호',
                            labelText: '비밀번호',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해 주세요.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => _isAutoLogin == true
                                        ? const BorderSide(
                                            width: 0.0,
                                            color: Colors.transparent,
                                          )
                                        : BorderSide(
                                            width: 1.5.w,
                                            color: Colors.black26,
                                          ),
                                  ),
                                  activeColor: _isAutoLogin == true
                                      ? Colors.amber
                                      : Colors.transparent,
                                  value: _isAutoLogin,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isAutoLogin = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  '자동로그인',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0XFF4A4A4A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: 1.sw / 5.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0XFFFDE048),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
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
                                              password:
                                                  _passwordTextEditingController
                                                      .text,
                                              isAutoLogin: _isAutoLogin,
                                            ),
                                          );
                                        }
                                      },
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        '로그인',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    height: 1.sw / 5.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0XFFF5602A)),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      onPressed: () {
                        // TODO: 회원가입 화면으로 이동
                        // context.go('/register');
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: const Color(0XFFEB5E2B),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
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
                            '아이디 찾기',
                            style: TextStyle(
                              color: const Color(0XFF888888),
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '┃',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0XFFA2A2A2),
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            // TODO: 비밀번호 재설정 화면으로 이동
                            // context.go('/reset-password');
                          },
                          child: Text(
                            '비밀번호 재설정',
                            style: TextStyle(
                              color: const Color(0XFF888888),
                              fontSize: 13.sp,
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
      ),
    );
  }
}
