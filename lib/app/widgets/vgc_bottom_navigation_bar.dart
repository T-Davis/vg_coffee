import 'package:vg_coffee/core/core.dart';

class VgcBottomNavigationBar extends StatelessWidget {
  const VgcBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return BottomNavigationBar(
            onTap: (value) => context.read<AppBloc>().add(
                  AppTabSelected(index: value),
                ),
            currentIndex: context.read<AppBloc>().state.selectedTab,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.coffee,
                  semanticLabel: l10n.coffeeTabIcon,
                ),
                label: l10n.coffeeTabLabel,
                tooltip: l10n.coffeeTooltip,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  semanticLabel: l10n.favoritesTabIcon,
                ),
                label: l10n.favoritesTabLabel,
                tooltip: l10n.favoritesTooltip,
              ),
            ],
          );
        },
      ),
    );
  }
}
