import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/core/common_libs.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CoffeeImage(),
        SizedBox(height: 20),
        _Buttons(),
      ],
    );
  }
}

class _CoffeeImage extends StatelessWidget {
  const _CoffeeImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple.shade100,
        border: Border.all(
          color: Colors.deepPurple,
          width: 1.5,
        ),
      ),
      height: 400,
      width: 400,
      child: BlocBuilder<CoffeeBloc, CoffeeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return switch (state.status) {
            CoffeeStatus.initial =>
              const Center(child: CircularProgressIndicator()),
            CoffeeStatus.loadingImage =>
              const Center(child: CircularProgressIndicator()),
            CoffeeStatus.success => Image.memory(
                state.image!.bytes,
                fit: BoxFit.contain,
              ),
            CoffeeStatus.favoritingImage => Image.memory(
                state.image!.bytes,
                fit: BoxFit.contain,
              ),
            CoffeeStatus.error => const Icon(Icons.error),
          };
        },
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              key: const ValueKey('favorite'),
              icon: _favoriteIcon(state),
              onPressed: _favoriteOnPressed(context, state),
              label: Text(l10n.favoriteButtonLabel),
            ),
            ElevatedButton.icon(
              key: const ValueKey('next'),
              icon: const Icon(Icons.forward),
              onPressed: _nextOnPressed(context, state),
              label: Text(l10n.nextButtonLabel),
            ),
          ],
        );
      },
    );
  }

  Icon _favoriteIcon(CoffeeState state) {
    return Icon(
      state.status == CoffeeStatus.success && state.image!.isFavorite
          ? Icons.favorite
          : Icons.favorite_border,
    );
  }

  void Function()? _favoriteOnPressed(BuildContext context, CoffeeState state) {
    return state.status == CoffeeStatus.success
        ? () {
            context.read<CoffeeBloc>().add(
                  CoffeeImageFavoriteStatusChanged(
                    isFavorite: !state.image!.isFavorite,
                  ),
                );
          }
        : null;
  }

  void Function()? _nextOnPressed(BuildContext context, CoffeeState state) {
    return state.status == CoffeeStatus.success ||
            state.status == CoffeeStatus.error
        ? () => context.read<CoffeeBloc>().add(CoffeeImageRequested())
        : null;
  }
}
