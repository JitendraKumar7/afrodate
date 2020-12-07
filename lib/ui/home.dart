import 'package:getwidget/components/badge/gf_button_badge.dart';
import 'package:getwidget/components/badge/gf_badge.dart';

import '../app/app_export.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MeetMatchWidget(),
    LikeMatchWidget(),
    WhoOnlineWidget(),
    ProfileWidget(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: AppBar(),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 231, 76, 60),
        unselectedItemColor: Color.fromARGB(255, 102, 102, 102),
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/home/ic_home_1.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/home/ic_home_3.png'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}

class MeetMatchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeetMatchState();
}

class _MeetMatchState extends State<MeetMatchWidget> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                'Welcome',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              SizedBox(width: 12),
              Text(
                'Vikram',
                style: TextStyle(color: Colors.black87, fontSize: 24),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Text(
                'Membership Type: Free',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              FlatButton(
                onPressed: () {},
                child: ChoiceChip(
                  backgroundColor: Colors.transparent,
                  selectedColor: Colors.deepOrange[300],
                  label: Text(
                    ' Upgrade ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  selected: true,
                  onSelected: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: GFButtonBadge(
                  onPressed: () {},
                  text: 'Visitor',
                  icon: GFBadge(
                    child: Text('9'),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GFButtonBadge(
                  onPressed: () {},
                  text: 'Invite',
                  icon: GFBadge(
                    child: Text('5'),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GFButtonBadge(
                  onPressed: () {},
                  text: 'Messages',
                  icon: GFBadge(
                    child: Text('23'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GFButton(
                size: 40,
                text: 'Meet',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 0 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: GFButton(
                size: 40,
                text: 'Match',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 1 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 1;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchFilterScreen(),
                  ),
                );
              },
              icon: ImageIcon(
                AssetImage('assets/home/ic_home_filter.png'),
              ),
            ),
          ],
        ),
        Expanded(
          child: GridViewState(),
        ),
      ],
    );
  }
}

class SearchFilterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilterScreen> {
  List<String> looking = ['Woman', 'Man', 'Both'];
  List<String> country = [
    'INDIA 1',
    'USA',
    'England',
  ];
  List<String> state = [
    'Delhi',
    'Bang',
    'Kolkatta',
  ];

  String _looking = '';
  String _country;
  String _state;

  double _age = 18;
  bool _termsChecked = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Search Filter',
          style: TextStyle(
            fontSize: 15,
            color: afroGray,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            'Show Me',
            style: TextStyle(
              fontSize: 12,
              color: afroGray,
            ),
          ),
          SizedBox(height: 6),
          Wrap(
            children: looking.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: ChoiceChip(
                  backgroundColor: Colors.transparent,
                  selectedColor: afroRed,
                  label: Text(
                    item,
                    style: TextStyle(
                      color: item == _looking ? Colors.white : afroRed,
                    ),
                  ),
                  selected: item == _looking,
                  onSelected: (selected) {
                    setState(() {
                      _looking = item;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Age',
                style: TextStyle(
                  fontSize: 12,
                  color: afroGray,
                ),
              ),
            ),
            Text(
              '18-45',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                color: afroGray,
              ),
            ),
          ]),
          Slider(
            value: _age,
            min: 18,
            max: 45,
            divisions: 27,
            label: _age.round().toString(),
            onChanged: (double value) {
              setState(() {
                _age = value;
              });
            },
          ),
          SizedBox(height: 12),
          Text(
            'Country',
            style: TextStyle(
              fontSize: 12,
              color: afroGray,
            ),
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _country,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: afroGray, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              hintText: 'Country',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onChanged: (String value) {
              setState(() {
                _country = value;
              });
            },
            items: country.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Text(
            'State',
            style: TextStyle(
              fontSize: 12,
              color: afroGray,
            ),
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _state,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: afroGray, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              hintText: 'State',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onChanged: (String value) {
              setState(() {
                _state = value;
              });
            },
            items: state.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          CheckboxListTile(
            value: _termsChecked,
            onChanged: (value) {
              setState(() {
                _termsChecked = value;
              });
            },
            title: Text(
              'Show match with photo only',
              style: TextStyle(
                fontSize: 15,
                color: afroGray,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          )
        ],
      ),
    );
  }
}

class LikeMatchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LikeMatchState();
}

class _LikeMatchState extends State<LikeMatchWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GFButton(
                size: 40,
                text: 'Likes',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 0 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: GFButton(
                size: 40,
                text: 'My Match',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 1 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 1;
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: index == 0 ? GridViewState1() : GridViewState2(),
        ),
      ],
    );
  }
}

class WhoOnlineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WhoOnlineState();
}

class _WhoOnlineState extends State<WhoOnlineWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GFButton(
                size: 40,
                text: 'Who\'s Online',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 0 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: GFButton(
                size: 40,
                text: 'Who Viewed Me',
                fullWidthButton: true,
                color: Colors.transparent,
                textColor: index == 1 ? afroRed : afroGray,
                onPressed: () {
                  setState(() {
                    index = 1;
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: index == 0 ? GridViewState0() : GridViewState(),
        ),
      ],
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileWidgetState();
}

class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final label;

  const ProfileButton({Key key, this.onPressed, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: afroGray,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: afroGray,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileWidgetState extends State<ProfileWidget> {
  List<Widget> images = List();

  @override
  void initState() {
    super.initState();
    images.add(Image.asset(
      'assets/placeholder.jpg',
      fit: BoxFit.cover,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            GFCarousel(
              height: MediaQuery.of(context).size.width,
              viewportFraction: 1.0,
              items: images.map((image) {
                return Container(
                  height: MediaQuery.of(context).size.width,
                  color: Colors.black87,
                  child: image,
                );
              }).toList(),
            ),
            Positioned.fill(
              left: 12,
              bottom: 24,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Pankaj S',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '25, New Delhi, India',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              right: 12,
              bottom: 24,
              child: Align(
                alignment: Alignment.bottomRight,
                child: AppImage(
                  onGallery: () {
                    Navigator.of(context).pop();
                    UtilsImage.getFromGallery().then((value) => {
                          setState(() {
                            images.add(Image.file(
                              value,
                              fit: BoxFit.cover,
                            ));
                          })
                        });
                  },
                  onCamera: () {
                    Navigator.of(context).pop();
                    UtilsImage.getFromCamera().then((value) => {
                          setState(() {
                            images.add(Image.file(
                              value,
                              fit: BoxFit.cover,
                            ));
                          })
                        });
                  },
                  child: Icon(
                    Icons.filter,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(height: 3),
        ProfileButton(
          label: 'Create Group',
        ),
        Divider(height: 3),
        ProfileButton(
          label: 'Edit Profile',
        ),
        Divider(height: 3),
        ProfileButton(
          label: 'Change Password',
        ),
        Divider(height: 3),
        ProfileButton(
          label: 'Logout',
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (Route<dynamic> route) => false);
          },
        ),
        Divider(height: 3),
        ProfileButton(
          label: 'De-Active Account',
        ),
        Divider(height: 3),
      ],
    );
  }
}

class GridViewState extends StatelessWidget {
  List<String> getList() {
    List<String> _list = <String>[
      'assets/images/demo_7.png',
      'assets/images/demo_8.png',
      'assets/images/demo_9.png',
      'assets/images/demo_10.png',
      'assets/images/demo_11.png',
      'assets/images/demo_2.png',
      'assets/images/demo_3.png',
      'assets/images/demo_4.png',
      'assets/images/demo_5.png',
      'assets/images/demo_6.png',
    ];
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: getList().map((String url) {
          return GridTile(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(url, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pankaj, 25',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              },
                              icon: ImageIcon(
                                AssetImage('assets/home/ic_comment.png'),
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList());
  }
}

class GridViewState0 extends StatelessWidget {
  List<String> getList() {
    List<String> _list = <String>[
      'assets/images/demo_1.png',
      'assets/images/demo_2.png',
      'assets/images/demo_3.png',
      'assets/images/demo_4.png',
      'assets/images/demo_5.png',
      'assets/images/demo_6.png',
      'assets/images/demo_7.png',
      'assets/images/demo_8.png',
    ];
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: getList().map((String url) {
          return GridTile(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(url, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.brightness_1,
                        color: Colors.green,
                        size: 12,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      icon: ImageIcon(
                        AssetImage('assets/home/ic_comment.png'),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList());
  }
}

class GridViewState1 extends StatelessWidget {
  List<String> getList() {
    List<String> _list = <String>[
      'assets/images/demo_4.png',
      'assets/images/demo_5.png',
      'assets/images/demo_6.png',
      'assets/images/demo_7.png',
      'assets/images/demo_8.png',
      'assets/images/demo_9.png',
      'assets/images/demo_10.png',
      'assets/images/demo_11.png',
      'assets/images/demo_12.png',
      'assets/images/demo_13.png',
    ];
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: getList().map((String url) {
          return GridTile(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(url, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Priya, 25',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              },
                              icon: ImageIcon(
                                AssetImage('assets/home/ic_comment.png'),
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite,
                                color: afroRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList());
  }
}

class GridViewState2 extends StatelessWidget {
  List<String> getList() {
    List<String> _list = <String>[
      'assets/images/demo_9.png',
      'assets/images/demo_10.png',
      'assets/images/demo_11.png',
      'assets/images/demo_2.png',
      'assets/images/demo_3.png',
      'assets/images/demo_4.png',
      'assets/images/demo_12.png',
      'assets/images/demo_13.png',
      'assets/images/demo_1.png',
      'assets/images/demo_2.png',
    ];
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(4.0),
        children: getList().map((String url) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            width: 400,
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(url, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Priya, 25',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              },
                              icon: ImageIcon(
                                AssetImage('assets/home/ic_comment.png'),
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite,
                                color: afroRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> children = List<Widget>();

  @override
  void initState() {
    super.initState();

    setState(() {
      children.add(Bubble(
        alignment: Alignment.center,
        color: Color.fromARGB(255, 212, 234, 244),
        elevation: 1 * 2.0,
        margin: BubbleEdges.only(top: 8.0),
        child: Text('TODAY', style: TextStyle(fontSize: 10)),
      ));
      children.add(Bubble(
        style: styleSomebody,
        child: Text('Hi Jason. Sorry to bother you. I have a queston for you.'),
      ));
      children.add(Bubble(
        style: styleMe,
        child: Text('Whats\'up?'),
      ));
      children.add(Bubble(
        style: styleSomebody,
        child: Text('I\'ve been having a problem with my computer.'),
      ));
      children.add(Bubble(
        style: styleSomebody,
        margin: BubbleEdges.only(top: 2.0),
        nip: BubbleNip.no,
        child: Text('Can you help me?'),
      ));
      children.add(Bubble(
        style: styleMe,
        child: Text('Ok'),
      ));
      children.add(Bubble(
        style: styleMe,
        nip: BubbleNip.no,
        margin: BubbleEdges.only(top: 2.0),
        child: Text('What\'s the problem?'),
      ));
    });
  }

  BubbleStyle styleSomebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    elevation: 1 * 2.0,
    margin: BubbleEdges.only(top: 8.0, right: 50.0),
    alignment: Alignment.topLeft,
  );
  BubbleStyle styleMe = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 225, 255, 199),
    elevation: 1 * 2.0,
    margin: BubbleEdges.only(top: 8.0, left: 50.0),
    alignment: Alignment.topRight,
  );

  final controller = TextEditingController();
  final _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.yellow[50],
        child: Column(children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              shrinkWrap: true,
              itemCount: children.length,
              padding: EdgeInsets.all(8.0),
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return children[index];
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red[500],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Row(children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Write your thought...',
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      print('controller text ${controller.text}');
                      setState(() {
                        if (children.length % 2 == 0)
                          children.add(Bubble(
                            style: styleMe,
                            child: Text(controller.text),
                          ));
                        else
                          children.add(Bubble(
                            style: styleSomebody,
                            margin: BubbleEdges.only(top: 2.0),
                            nip: BubbleNip.no,
                            child: Text(controller.text),
                          ));
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 50,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      });
                      controller.text = '';
                    }
                  })
            ]),
          ),
        ]),
      ),
    );
  }
}
