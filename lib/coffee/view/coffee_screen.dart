import 'dart:typed_data';

import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/core/core.dart';

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
      child: BlocConsumer<CoffeeBloc, CoffeeState>(
        listener: (context, state) {
          if (state.status == CoffeeStatus.errorSavingOrDeletingImage) {
            ScaffoldMessenger.of(context).showSnackBar(
              _snackbar(context.l10n.whoopsSavingOrRemoving),
            );
          }
        },
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return switch (state.status) {
            CoffeeStatus.initial =>
              const Center(child: CircularProgressIndicator()),
            CoffeeStatus.loadingImage =>
              const Center(child: CircularProgressIndicator()),
            CoffeeStatus.success => _ShowImage(state.image!.bytes),
            CoffeeStatus.favoritingImage => _ShowImage(state.image!.bytes),
            CoffeeStatus.errorFetchingImage => const _FetchingError(),
            CoffeeStatus.errorSavingOrDeletingImage =>
              _ShowImage(state.image!.bytes),
          };
        },
      ),
    );
  }

  SnackBar _snackbar(String message) {
    return SnackBar(
      backgroundColor: Colors.purple.shade50,
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.deepPurple,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
    );
  }
}

class _ShowImage extends StatelessWidget {
  const _ShowImage(this.bytes);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      bytes,
      fit: BoxFit.contain,
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
    return state.status == CoffeeStatus.success ||
            state.status == CoffeeStatus.errorSavingOrDeletingImage
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
            state.status == CoffeeStatus.errorFetchingImage ||
            state.status == CoffeeStatus.errorSavingOrDeletingImage
        ? () => context.read<CoffeeBloc>().add(CoffeeImageRequested())
        : null;
  }
}

class _FetchingError extends StatelessWidget {
  const _FetchingError();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Notice(
      icon: Icons.wifi_find_outlined,
      text: l10n.couldNotLoadTheImage,
      subtext: l10n.checkYourInternetConnection,
    );
  }
}
