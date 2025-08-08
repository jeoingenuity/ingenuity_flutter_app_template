import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/auth_bloc.dart';

// Form input validation
class EmailInput extends FormzInput<String, String> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }
}

class PasswordInput extends FormzInput<String, String> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  String? validator(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EmailInput _email = const EmailInput.pure();
  PasswordInput _password = const PasswordInput.pure();
  bool _isPasswordVisible = false;
  bool _isSignUpMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    setState(() {
      _email = EmailInput.dirty(_emailController.text);
    });
  }

  void _onPasswordChanged() {
    setState(() {
      _password = PasswordInput.dirty(_passwordController.text);
    });
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isSignUpMode) {
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              email: email,
              password: password,
              name: email
                  .split('@')
                  .first, // Use email prefix as name for simplicity
            ),
          );
    } else {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: email,
              password: password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Field
            TextFormField(
              controller: _emailController,
              onChanged: (_) => _onEmailChanged(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.email,
                hintText: context.l10n.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
                errorText: _email.isNotValid ? _email.error : null,
              ),
              validator: (value) => EmailInput.dirty(value ?? '').error,
            ),

            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              controller: _passwordController,
              onChanged: (_) => _onPasswordChanged(),
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onSubmit(),
              decoration: InputDecoration(
                labelText: context.l10n.password,
                hintText: context.l10n.passwordHint,
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
                errorText: _password.isNotValid ? _password.error : null,
              ),
              validator: (value) => PasswordInput.dirty(value ?? '').error,
            ),

            const SizedBox(height: 24),

            // Submit Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return FilledButton(
                  onPressed: isLoading ? null : _onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isSignUpMode
                              ? context.l10n.signUp
                              : context.l10n.signIn,
                        ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Switch between Sign In / Sign Up
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUpMode = !_isSignUpMode;
                });
              },
              child: Text(
                _isSignUpMode
                    ? context.l10n.alreadyHaveAccount
                    : context.l10n.dontHaveAccount,
              ),
            ),

            // Forgot Password (only show in sign in mode)
            if (!_isSignUpMode) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.forgotPasswordNotImplemented),
                    ),
                  );
                },
                child: Text(context.l10n.forgotPassword),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
