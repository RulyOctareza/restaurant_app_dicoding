enum NavigationRoute {
  homeRoute('/home'),
  detailRoute('/detail'),
  searchPage('/searchpage'),
  settingScreen('/setting');

  const NavigationRoute(this.name);
  final String name;
}
