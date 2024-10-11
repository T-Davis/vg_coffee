import 'package:coffee_repository/coffee_repository.dart';
import 'package:vg_coffee/coffee/coffee.dart';
import 'package:vg_coffee/core/core.dart';
import 'package:vg_coffee/favorites/favorites.dart';

class App extends StatelessWidget {
  const App({required CoffeeRepository coffeeRepository, super.key})
      : _coffeeRepository = coffeeRepository;

  final CoffeeRepository _coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) =>
              CoffeeBloc(_coffeeRepository)..add(CoffeeImageRequested()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => FavoritesBloc(_coffeeRepository)
            ..add(FavoritesLoadImagesRequested()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  final PageController _pageController = PageController();
  final _screens = [
    const CoffeeScreen(),
    const FavoritesScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<CoffeeBloc, CoffeeState>(
      listenWhen: (previous, current) =>
          previous.status == CoffeeStatus.favoritingImage &&
          current.status == CoffeeStatus.success,
      listener: (context, state) {
        state.image!.isFavorite
            ? context.read<FavoritesBloc>().add(
                  FavoritesAddImageRequested(
                    filename: state.image!.filename,
                    bytes: state.image!.bytes,
                  ),
                )
            : context
                .read<FavoritesBloc>()
                .add(FavoritesRemoveImageRequested(state.image!.filename));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.appBarTitle,
            semanticsLabel: '${l10n.appBarTitle} ${l10n.appBar}',
          ),
        ),
        body: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            state.selectedTab == 0 ? _animateToPage(0) : _animateToPage(1);
          },
          child: PageView(
            controller: _pageController,
            children: _screens,
          ),
        ),
        bottomNavigationBar: const VgcBottomNavigationBar(),
      ),
    );
  }

  Future<void> _animateToPage(int index) {
    return _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
