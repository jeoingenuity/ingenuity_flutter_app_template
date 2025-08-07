import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingenuity_flutter_app_template/counter/counter.dart';
import 'package:ingenuity_flutter_app_template/l10n/l10n.dart';
import 'package:ingenuity_flutter_app_template/core/di/injection_container.dart';
import 'package:ingenuity_flutter_app_template/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ingenuity_flutter_app_template/features/auth/presentation/pages/login_page.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate back to login when user logs out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.counterAppBarTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              tooltip: l10n.signOut,
            ),
          ],
        ),
        body: const Center(child: CounterText()),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().decrement(),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
