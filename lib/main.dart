import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    authentication();
  }

  void authentication() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to open app',
        options: const AuthenticationOptions(
            biometricOnly: false, stickyAuth: true));
    if (!didAuthenticate) {
      SystemNavigator.pop();
    }
  }

  bool ison = false;
  Function(bool)? themes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold)),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black54,
            textColor: Colors.black87,
            style: ListTileStyle.drawer,
          ),
          useMaterial3: true,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              iconSize: 30)),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black54,
            textColor: Colors.black87,
            style: ListTileStyle.drawer,
          ),
          useMaterial3: true,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              iconSize: 30)),
      themeMode: ison ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
          title: 'CRUD Operation',
          isdark: ison,
          themeFunction: (value) {
            setState(() {});
            return ison = value;
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Function(bool) themeFunction;
  bool isdark;

  MyHomePage(
      {super.key,
      required this.title,
      required this.isdark,
      required this.themeFunction});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

addItem(int index, String title, String des) {
  Map<String, dynamic> update = {
    "id": index,
    "title": title,
    "description": des
  };
  data.add(update);
}

List<Map<String, dynamic>> data = [
  {"id": 1, "title": "User1", "description": "this is des1."},
  {"id": 2, "title": "User2", "description": "this is des2."}
];

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                widget.isdark = !widget.isdark;
                widget.themeFunction.call(widget.isdark);
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.isdark ? Colors.white10 : Colors.black12,
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(widget.isdark ? Icons.light_mode : Icons.dark_mode),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
        title: Text.rich(TextSpan(text: widget.title, children: [
          TextSpan(
              text: " using List",
              style: widget.isdark
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white54)
                  : Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54))
        ])),
      ),
      body: data.isEmpty
          ? const Center(child: Text("No Records..."))
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                      title: Text(data[index]["title"] ?? ""),
                      subtitle: Text(data[index]["description"] ?? ""),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                if (data[index]['id'] == index + 1) {
                                  setState(() {
                                    final existingJournal = data.firstWhere(
                                        (element) =>
                                            element['id'] == index + 1);
                                    _titleController.text =
                                        existingJournal['title'];
                                    _descriptionController.text =
                                        existingJournal['description'];
                                    showModalBottomSheet(
                                        context: context,
                                        elevation: 5,
                                        isScrollControlled: true,
                                        builder: (_) => Container(
                                              padding: EdgeInsets.only(
                                                top: 15,
                                                left: 15,
                                                right: 15,
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    120,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        _titleController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText: 'Title'),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _descriptionController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Description'),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      String title =
                                                          _titleController.text
                                                              .toString();
                                                      String des =
                                                          _descriptionController
                                                              .text
                                                              .toString();
                                                      setState(() {
                                                        _titleController.text =
                                                            '';
                                                        _descriptionController
                                                            .text = '';
                                                        data[index]["title"] =
                                                            title;
                                                        data[index][
                                                                "description"] =
                                                            des;
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Update'),
                                                  )
                                                ],
                                              ),
                                            ));
                                  });
                                }
                              },
                            ),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  if (data[index]['id'] == data[index]['id']) {
                                    setState(() {
                                      data.removeAt(index);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Record deleted Successfully...")));
                                    });
                                  }
                                }),
                          ],
                        ),
                      ))),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            elevation: 5,
            isScrollControlled: true,
            builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      addItem(data.length + 1, _titleController.text.toString(),
                          _descriptionController.text.toString());

                      _titleController.text = '';
                      _descriptionController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: const Text('Create New'),
                  )
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
