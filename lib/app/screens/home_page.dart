import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_restapi/app/data/model/country_model.dart';
import 'package:flutter_country_restapi/app/data/service/country_service.dart';
import 'package:url_launcher/url_launcher.dart';

enum SortType { name, capital, continent }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country>? countries;
  List<Country>? initCountries;
  bool isLoading = true;
  bool showSearchField = false;
  SortType sortType = SortType.name;
  final _gitUrl =
      Uri.parse('https://www.google.com');

  @override
  void initState() {
    super.initState();

    loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        floatingActionButton: getFAB(context),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: getWidget(),
          ),
        ));
  }

  Future<void> loadCountries() async {
    final countryService = CountryService();
    initCountries = await countryService.getAllCountries();
    countries = initCountries;
    sortCountries(SortType.name);
  }

  void searchCountry(String place) {
    if (initCountries != null) {
      setState(() {
        countries = initCountries!
            .where((c) =>
                c.name!.common!.toLowerCase().contains(place.toLowerCase()) ||
                (c.capital != null && c.capital!.isNotEmpty ? c.capital!.first.toLowerCase().contains(place.toLowerCase()) : false) ||
                (c.continents != null && c.continents!.isNotEmpty ? c.continents!.first.toLowerCase().contains(place.toLowerCase()) : false))
            .toList();
      });
    }
  }

  Future<void> sortCountries(SortType type) async {
    setState(() {
      isLoading = true;
      sortType = type;
    });
    if (countries != null) {
      countries!.sort((a, b) {
        switch (type) {
          case SortType.name:
            final nameA = a.name?.common?.toLowerCase();
            final nameB = b.name?.common?.toLowerCase();
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          case SortType.capital:
            final nameA = a.capital != null && a.capital!.isNotEmpty ? a.capital?.first.toLowerCase() : null;
            final nameB = b.capital != null && b.capital!.isNotEmpty ? b.capital?.first.toLowerCase() : null;
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          case SortType.continent:
            final nameA = a.continents != null && a.continents!.isNotEmpty ? a.continents?.first.toLowerCase() : null;
            final nameB = b.continents != null && b.continents!.isNotEmpty ? b.continents?.first.toLowerCase() : null;
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          default:
            return 0;
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      isLoading = false;
    });
  }

  Row getFAB(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        showSearchField
            ? Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  constraints: const BoxConstraints(maxWidth: 500, minWidth: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 3, offset: const Offset(0, 1)),
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    enabled: true,
                    onChanged: searchCountry,
                  ),
                ),
              )
            : Container(),
        const SizedBox(width: 8),
        FloatingActionButton(
          tooltip: 'Search',
          onPressed: () {
            setState(() {
              if (showSearchField) {
                searchCountry('');
              }
              showSearchField = !showSearchField;
            });
          },
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                        : Tween<double>(begin: 0.75, end: 1).animate(anim),
                    child: ScaleTransition(scale: anim, child: child),
                  ),
              child: showSearchField ? const Icon(Icons.close, key: ValueKey('icon1')) : const Icon(Icons.search, key: ValueKey('icon2'))),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          tooltip: 'Source code',
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      actions: [
                        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                      ],
                      title: const Text('Open-source project'),
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                text:
                                    'This project seeks to demonstrate how to consume a REST API, and its complete source code is available on GitHub via this ',
                              ),
                              TextSpan(
                                text: 'LINK',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()..onTap = () => launchUrl(_gitUrl,mode: LaunchMode.externalApplication),
                              ),
                              TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                text: '.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
          },
          child: const Icon(Icons.code),
        ),
      ],
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: Container(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Row(
          children: [
            getAppBarButton(SortType.name),
            const SizedBox(width: 8),
            getAppBarButton(SortType.capital),
            const SizedBox(width: 8),
            getAppBarButton(SortType.continent),
            const SizedBox(width: 8),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('Flag', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }

  Expanded getAppBarButton(SortType type) {
    final text = type == SortType.name
        ? 'Name'
        : type == SortType.capital
            ? 'Capital'
            : 'Continent';
    return Expanded(
      child: GestureDetector(
        onTap: () => sortCountries(type),
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          decoration: sortType == type
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                )))
              : null,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getWidget() {
    if (countries == null || isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (countries!.isEmpty) {
      return const Center(
        child: Text('No country found!'),
      );
    } else {
      return SingleChildScrollView(
        child: SelectionArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                for (var country in countries!) ...{
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(child: Text(country.name?.common ?? 'No name')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(country.capital != null && country.capital!.isNotEmpty ? country.capital!.elementAt(0) : 'No capital'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(country.continents != null && country.continents!.isNotEmpty
                              ? country.continents!.length == 1
                                  ? country.continents!.first
                                  : country.continents.toString()
                              : 'No borders'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: country.flags != null && country.flags!.png != null
                                ? Image.network(country.flags!.png!)
                                : const Icon(Icons.flag_rounded)),
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: const Divider(),
                  )
                }
              ],
            ),
          ),
        ),
      );
    }
  }
}
