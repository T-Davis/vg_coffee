import 'package:coffee_repository/coffee_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/coffee/coffee.dart';
import 'package:vg_coffee/core/core.dart';
import 'package:vg_coffee/favorites/favorites.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          create: (context) => CoffeeBloc(GetIt.instance<CoffeeRepository>())
            ..add(CoffeeImageRequested()),
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
    return Scaffold(
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
