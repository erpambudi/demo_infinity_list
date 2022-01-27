import 'package:demo_infinity_list/person.dart';
import 'package:demo_infinity_list/persons_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  int limit = 10;
  double heightCard = 100;

  void onScroll() async {
    final provider = Provider.of<PersonsProvider>(context, listen: false);
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      if (provider.state != RequestState.loading) {
        await provider.fetchData(limit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Limit diambil dari berapa banyak card yang dapat ditampillan pada layar
    limit = (MediaQuery.of(context).size.height / heightCard).round();
    Provider.of<PersonsProvider>(context, listen: false).fetchData(limit);
    controller.addListener(onScroll);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<PersonsProvider>(context, listen: false).fetchData(limit);
        },
        child: Consumer<PersonsProvider>(
          builder: (context, provider, _) {
            if (provider.state == RequestState.hasData) {
              List<DataResponse> persons = provider.persons;
              return ListView.builder(
                key: const PageStorageKey<String>('pageKey'),
                controller: controller,
                itemCount: provider.hasReachedMax
                    ? persons.length
                    : persons.length + 1,
                itemBuilder: (context, index) {
                  if (index < persons.length) {
                    return itemCard(persons[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else if (provider.state == RequestState.error) {
              return Stack(
                children: [
                  const Center(
                    child: Text("Error"),
                  ),
                  ListView()
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget itemCard(DataResponse person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: heightCard,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(person.id!.toString()),
              Text(person.title!),
            ],
          ),
        ),
      ),
    );
  }
}
