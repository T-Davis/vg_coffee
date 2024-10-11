import 'package:vg_coffee/core/core.dart';
import 'package:vg_coffee/favorites/bloc/favorites_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return switch (state.status) {
          FavoritesStatus.initial =>
            const Center(child: CircularProgressIndicator()),
          FavoritesStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          FavoritesStatus.success =>
            state.images.isEmpty ? const _NoFavorites() : _FavoritesGrid(state),
          FavoritesStatus.error => const _Error(),
        };
      },
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid(this.state);

  final FavoritesState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: state.images.length,
        itemBuilder: (context, index) {
          final image = state.images[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.shade100,
                border: Border.all(
                  color: Colors.deepPurple,
                ),
              ),
              child: Image.memory(
                image.bytes,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoFavorites extends StatelessWidget {
  const _NoFavorites();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Notice(
      icon: Icons.favorite_border,
      text: l10n.coffeePicturesShow,
      subtext: l10n.headToCoffeeTab,
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Notice(
      icon: Icons.sd_storage_outlined,
      text: l10n.troubleRetrievingFavorites,
      subtext: l10n.tapRetry,
      buttonText: l10n.retry,
      onPressed: () => context.read<FavoritesBloc>().add(
            FavoritesLoadImagesRequested(),
          ),
    );
  }
}
