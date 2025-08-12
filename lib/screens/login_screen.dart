import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool hasMinLength = false;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasDigit = false;
  bool hasSymbol = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().add(LoginEmailChanged(_emailController.text));
  }

  void _onPasswordChanged() {
    final pass = _passwordController.text;

    setState(() {
      hasMinLength = pass.length >= 8;
      hasUpper = RegExp(r'[A-Z]').hasMatch(pass);
      hasLower = RegExp(r'[a-z]').hasMatch(pass);
      hasDigit = RegExp(r'[0-9]').hasMatch(pass);
      hasSymbol = RegExp(
        r'[!@#\$&*~%^&()_+\-=\[\]{};:"\\|,.<>\/?]',
      ).hasMatch(pass);
    });

    context.read<LoginBloc>().add(LoginPasswordChanged(pass));
  }

  void _onSubmit() {
    context.read<LoginBloc>().add(LoginSubmitted());
  }

  Widget _buildCriteriaRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel,
          color: met ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: met ? Colors.green : Colors.red,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.status == LoginStatus.failure) {
            final msg = state.errorMessage ?? 'Login failed';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => _onEmailChanged(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (_) => _onPasswordChanged(),
              ),
              const SizedBox(height: 8),

              // Password criteria UI
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCriteriaRow("Minimum 8 characters", hasMinLength),
                    _buildCriteriaRow("At least 1 uppercase letter", hasUpper),
                    _buildCriteriaRow("At least 1 lowercase letter", hasLower),
                    _buildCriteriaRow("At least 1 number", hasDigit),
                    _buildCriteriaRow("At least 1 symbol", hasSymbol),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final enabled =
                      state.isEmailValid &&
                      state.isPasswordValid &&
                      state.status != LoginStatus.submitting;
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: enabled ? _onSubmit : null,
                      child: state.status == LoginStatus.submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Submit'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Sample (valid) credentials: test@example.com / Password1!',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
