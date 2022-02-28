import 'package:expandable_box/expandable_box.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Box1()),
              );
            },
            child: const Text("toggle"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Box2()),
              );
            },
            child: const Text("hide"),
          ),
        ],
      ),
    );
  }
}

// toggle expanded state
class Box1 extends StatelessWidget {
  const Box1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ExpandableBox(
            expand: false,
            collapsedHeight: 200,
            footerBuilder: (BuildContext context, ExpandableBoxState state) {
              return ElevatedButton(
                  onPressed: () => state.toggle(), child: const Text("toggle"));
            },
            builder: (BuildContext context, ExpandableBoxState state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: new Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")),
                    ],
                  ),
                  Image.network(
                    "https://via.placeholder.com/200",
                    fit: BoxFit.fill,
                  ),
                  ...List.generate(5, (index) => Text("$index")),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Hide collapse evnet button when box expended
class Box2 extends StatelessWidget {
  const Box2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ExpandableBox(
            expand: false,
            collapsedHeight: 100,
            footerBuilder: (BuildContext context, ExpandableBoxState state) {
              if (state.expand) {
                return Container();
              } else {
                return ElevatedButton(
                    onPressed: () => state.toggle(),
                    child: const Text("toggle"));
              }
            },
            builder: (BuildContext context, ExpandableBoxState state) {
              return Column(
                children: List.generate(30, (index) => Text("$index")),
              );
            },
          ),
        ),
      ),
    );
  }
}
