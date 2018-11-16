import 'package:bloc_streambuilder/bloc_streambuilder.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class Bloc {
  BlocStream<int> get counter => _counterController.stream;
  BlocSink<int> get setCounter => _counterController.sink;

  void incrementCounter() => _counterController.value++;

  var _counterController = BlocStreamController<int>(seedValue: 0);

  void dispose() {
    _counterController.close();
  }
}

class BlocProvider extends InheritedWidget {
  final Bloc bloc;

  const BlocProvider({this.bloc, Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

  static Bloc of(BuildContext context) {
    return (context.ancestorWidgetOfExactType(BlocProvider) as BlocProvider)
        ?.bloc;
  }
}

class MyAppState extends State<MyApp> {
  Bloc _bloc;

  @override
  void initState() {
    _bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(
          title: 'Counter Example',
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        leading: IconButton(
          icon: Icon(Icons.restore_page),
          onPressed: () => bloc.setCounter.setValue(0),
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            BlocStreamBuilder(
              builder: (context, snapshot) {
                return new Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
              stream: bloc.counter,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: bloc.incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
