import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:todo_list/second_database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import '../provider(for languages)/locale_provider.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TodoDatabase todoDatabase = TodoDatabase();
  final String yourProfileIconPath = 'assets/group 7.svg';
  final String yourCalendarIconPath = 'assets/group 6.svg';
  final String yourToDoIconPath = 'assets/group 1 (3).svg';
  int _selectedIndex = 0;

  ///function responsible for tapping (changing screen) on the bottom bar buttons
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _screens = [];

  ///---------------------------------------------------------------------
  ///keyboard stuff first screen
  void _showAddTodoSheet(BuildContext context, int day, int month) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: screenHeight * 0.2,
                decoration: const BoxDecoration(
                    color: Color(0xFFE7E2EA),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 0, bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: todoDescriptionFormController,
                          textInputAction: TextInputAction.newline,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w400),
                          autofocus: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.writeTask,
                              labelStyle: const TextStyle(
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.w500)),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Empty description!';
                            }
                            return value.contains('')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: screenWidth * 0.218,
                            height: screenHeight * 0.049,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                                onPressed: () {
                                  //TODO: add backend
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.category,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            width: screenWidth * 0.218,
                            height: screenHeight * 0.049,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                                onPressed: () {
                                  //TODO:add backend
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.calendar,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.267, 0, screenWidth * 0.048, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                radius: 30,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final newTodo = Todo(
                                      toDo: todoDescriptionFormController
                                          .value.text,
                                      day: day,
                                      month: month,
                                    );
                                    log('New Todo Description: ${newTodo.day}, ${newTodo.month} ');
                                    if (newTodo.toDo.isNotEmpty) {
                                      todoDatabase.insertToDo(newTodo);
                                      //dismisses the bottomsheet
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ///---------------------------------------------------------------------

  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    _screens = [
      tasksMainScreen(context), // Initialize the _screens list inside initState
      calendarScreen(context),
      profileScreen(context),
    ];
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xFFE7E2EA),
      systemNavigationBarColor: const Color(0xFFE7E2EA),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books_sharp),
            label: AppLocalizations.of(context)!.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: AppLocalizations.of(context)!.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded, size: 30.0),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        selectedItemColor: const Color(0xFFdb7faf),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  ///===========================================================================
  ///Screens
  Widget tasksMainScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<String> categories = [
      'All',
      'Work',
      'Activities',
      'All',
      'Work',
      'Activities'
    ]; // List of categories

    // Function to add a new category
    void addCategory(String category) {
      setState(() {
        categories.add(category);
      });
    }

//TODO ADD USAGE OF THIS FUNCTIONS
    // Function to delete a category
    void deleteCategory(int index) {
      setState(() {
        categories.removeAt(index);
      });
    }

    ///THINGS FOR CHANGE TO_DOS

    void editToDos(Todo todo) {
      final todoDescriptionFormController =
          TextEditingController(text: todo.toDo);
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: screenHeight * 0.2,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E2EA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 0, bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: todoDescriptionFormController,
                          textInputAction: TextInputAction.newline,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w400),
                          autofocus: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Empty description!';
                            }
                            return value.contains('')
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: screenWidth * 0.218,
                            height: screenHeight * 0.049,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // TODO: add backend
                              },
                              child: Text(
                                AppLocalizations.of(context)!.category,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            width: screenWidth * 0.218,
                            height: screenHeight * 0.049,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                              ),
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // TODO: add backend
                              },
                              child: Text(
                                AppLocalizations.of(context)!.calendar,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(110, 0, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                radius: 30,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      todo.toDo = todoDescriptionFormController
                                          .value.text;
                                      todoDatabase.updateTodo(todo);
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Function to build the list of text buttons
    List<Widget> buildCategoryButtons() {
      return categories
          .map(
            (category) => Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                  width: screenWidth * 0.218,
                  height: screenHeight * 0.04389,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                      onPressed: (//TODO: add functionality
                          ) {},
                      child: Text(
                        category,
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
          )
          .toList();
    }

    return Scaffold(
      body: Container(
        color: Color(0xFFE7E2EA),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                  child: SizedBox(
                    height: screenHeight * 0.04389,
                    width: screenWidth * 0.827,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: buildCategoryButtons(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: SizedBox(
                    width: screenWidth * 0.048,
                    height: screenHeight * 0.04389,
                    child: PopupMenuButton(
                      color: Theme.of(context).primaryColorDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set the desired border radius
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'manage',
                            child: SizedBox(
                              width: 120, // Set the desired width
                              height: 20, // Set the desired height
                              child: Text(
                                AppLocalizations.of(context)!.manageCategories,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'search',
                            child: SizedBox(
                              width: 120, // Set the desired width
                              height: 20, // Set the desired height
                              child: Text(
                                AppLocalizations.of(context)!.search,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'change language',
                            child: SizedBox(
                              width: 120, // Set the desired width
                              height: 20, // Set the desired height
                              child: Text(
                                AppLocalizations.of(context)!.change_language,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        final provider =
                            Provider.of<LocaleProvider>(context, listen: false);
                        final currentLocale = provider.locale
                            .languageCode; // Get the current language code

                        switch (value) {
                          case "manage":
                            // Handle the "manage" option
                            break;

                          case "search":
                            // Handle the "search" option
                            break;

                          case "change language":
                            // Change the language to the opposite one
                            final newLocale = currentLocale == 'en'
                                ? const Locale('ru')
                                : const Locale('en');
                            provider.setLocale(newLocale);
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Todo>>(
              future: todoDatabase.getTodos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.errorLoadingToDo),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noToDo),
                  );
                } else {
                  final todos = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Dismissible(
                          background: Container(
                            color: Theme.of(context).primaryColorDark,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.delete,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            bool delete = true;
                            final snackbarController =
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                content: SizedBox(
                                  height: screenHeight * 0.0474,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .deleteToDo,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          delete = false;
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                        child: const Text(
                                          'Undo',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            await snackbarController.closed;
                            return delete;
                          },
                          onDismissed: (_) {
                            setState(() {
                              todoDatabase.deleteTodoById(todo.id!);
                            });
                          },
                          direction: DismissDirection.startToEnd,
                          // Allow only right-to-left swipe
                          key: ObjectKey(todo),
                          child: Padding(
                            // Add desired spacing between items
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Center(
                              child: Container(
                                width: 400,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    editToDos(todo);
                                  },
                                  child: Column(
                                    children: [
                                      TodoListTile(
                                        todo: todo,
                                        todoDatabase: todoDatabase,
                                      ),
                                      if (todo.day != 0)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                screenWidth * 0.177, 0, 0, 10),
                                            child: Container(
                                              width: screenWidth * 0.12,
                                              height: screenHeight * 0.035,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Align(
                                                child: Text(
                                                  '${todo.day.toString()}-${todo.month.toString()}',
                                                  style: TextStyle(
                                                      color: DateTime.now()
                                                                  .day
                                                                  .toInt() >
                                                              todo.day
                                                          ? Colors.red[500]
                                                          : Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: SizedBox(
          width: 66,
          height: 66,
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 8.0,
              onPressed: () {
                _showAddTodoSheet(context, 0, 0);
              },
              backgroundColor: Theme.of(context).primaryColorDark,
              child: const Icon(
                Icons.add_rounded,
                size: 37,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///==========================================================================

  Widget profileScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFE7E2EA),
          body: Column(children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.16,
              color: Theme.of(context).primaryColorDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/Group 8.svg',
                  ),
                  SizedBox(
                    width: screenWidth * 0.1,
                  ),
                  const Text(
                    "To-Do list",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'ConcertOne',
                    ),
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  ///---------------------------
  Widget calendarScreen(BuildContext context) {
    final todaysDate = DateTime.now();
    var focusedCalendarDate = DateTime.now();
    final initialCalendarDate = DateTime(2000);
    final lastCalendarDate = DateTime(2050);
    DateTime? selectedCalendarDate;

    return Scaffold(
      backgroundColor: Color(0xFFE7E2EA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10.0),
                elevation: 5.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  side: BorderSide(color: Colors.brown, width: 2.0),
                ),
                child: TableCalendar(
                  // Calendar Header Styling
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle:
                        TextStyle(color: Colors.grey[700], fontSize: 20.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    formatButtonTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 16.0),
                    formatButtonDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  // Calendar Days Styling
                  daysOfWeekStyle: DaysOfWeekStyle(
                    // Weekend days color (Sat,Sun)
                    weekendStyle: TextStyle(color: Colors.red[200]),
                  ),

                  // Calendar Dates styling
                  calendarStyle: CalendarStyle(
                    // highlighted color for today
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      shape: BoxShape.circle,
                    ),
                    // highlighted color for selected day
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // today's date
                  focusedDay: focusedCalendarDate,
                  // earliest possible date
                  firstDay: initialCalendarDate,
                  // latest allowed date
                  lastDay: lastCalendarDate,
                  // default view when displayed
                  availableCalendarFormats: const {
                    CalendarFormat.month: "Month"
                  },

                  // default is Saturday & Sunday but can be set to any day.
                  // instead of day, a number can be mentioned as well.
                  weekendDays: const [DateTime.sunday, 6],
                  // default is Sunday but can be changed according to locale
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  // height between the day row and 1st date row, default is 16.0
                  daysOfWeekHeight: 40.0,
                  // height between the date rows, default is 52.0
                  rowHeight: 60.0,
                  onDaySelected: (DateTime selectedDate, DateTime focusedDate) {
                    setState(() {
                      selectedCalendarDate = selectedDate;
                      focusedCalendarDate = focusedDate;
                    });
                    _showAddTodoSheet(
                        context, selectedDate.day, selectedDate.month);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TodoListTile extends StatefulWidget {
  final Todo todo;
  final TodoDatabase todoDatabase;

  const TodoListTile({
    super.key,
    required this.todo,
    required this.todoDatabase,
  });

  @override
  _TodoListTileState createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          setState(() {
            if (widget.todo.isDone == 0) {
              widget.todo.isDone = 1;
            } else {
              widget.todo.isDone = 0;
            }
            widget.todoDatabase.updateTodo(widget.todo);
          });
        },
        child: Container(
          child: widget.todo.isDone == 1
              ? const Icon(
                  Icons.radio_button_checked,
                  size: 32.0,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  size: 32.0,
                  color: Colors.white,
                ),
        ),
      ),
      title: Text(
        widget.todo.toDo,
        style: TextStyle(
            color: Colors.grey[700],
            decoration:
                widget.todo.isDone == 1 ? TextDecoration.lineThrough : null),
      ),
    );
  }
}
