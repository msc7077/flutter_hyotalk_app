import 'package:flutter/material.dart';
import 'package:flutter_hyotalk_app/features/home/presentation/pages/home_tab_page.dart';
import 'package:flutter_hyotalk_app/features/shopping/presentation/pages/shopping_tab_page.dart';
import 'package:flutter_hyotalk_app/features/work_diary/presentation/pages/work_diary_tab_page.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
    const NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: '업무일지'),
    const NavigationDestination(
      icon: Icon(Icons.shopping_bag_outlined),
      selectedIcon: Icon(Icons.shopping_bag),
      label: '쇼핑몰',
    ),
    const NavigationDestination(
      icon: Icon(Icons.more_horiz_outlined),
      selectedIcon: Icon(Icons.more_horiz),
      label: '더보기',
    ),
  ];

  final List<Widget> _pages = [const HomeTabPage(), const WorkDiaryTabPage(), const ShoppingTabPage()];

  final List<String> _routes = ['/home', '/work-diary', '/shopping'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 초기 인덱스 설정
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(currentLocation);
    if (index >= 0 && index != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == 3) {
      // "더보기" 탭은 서브페이지로 열기
      context.push('/mypage');
    } else {
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      context.go(_routes[index]);
    }
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 경로에 따라 인덱스 동기화
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final index = _routes.indexOf(currentLocation);
    if (index != -1 && _currentIndex != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentIndex != index) {
          try {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            }
          } catch (e) {
            // PageController가 아직 준비되지 않은 경우 무시
          }
        }
      });
    }

    return Scaffold(
      body: PageView(controller: _pageController, onPageChanged: _onPageChanged, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
      ),
    );
  }
}
