import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notification/notification_cubit.dart';
import '../pages/following_tab.dart';
import '../pages/notification_tab.dart';
import '../pages/view_story_screen.dart';
import '../repositories/repository.dart';


class PanelWidget extends StatefulWidget {

  const PanelWidget({
    Key? key,
  })
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();


}

class _PanelWidgetState extends State<PanelWidget>  with SingleTickerProviderStateMixin {
  late ScrollController controller;
  late TabController _tabController;
  late List<DocumentSnapshot> _users;




  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('profile')
        .get()
        .then((querySnapshot) => setState(() => _users = querySnapshot.docs));
    controller = ScrollController();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 30, 29),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "NowMap",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 1,top:10),

          child: Flex(
              direction: Axis.vertical,

              children: [
                Container(
                  height: 190,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text("Stories", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),),

                          ],
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          height: 160,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _users.length,
                              itemBuilder: (BuildContext context, int index) {
                                var user = _users[index];
                                return AspectRatio(
                                  aspectRatio: 1.6 / 2.2,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ViewStoryScreen(user: user)));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: const DecorationImage(
                                            image: NetworkImage(    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
                                            ),
                                            fit: BoxFit.cover

                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                begin: Alignment.bottomRight,
                                                colors: [
                                                  Colors.black.withOpacity(.8),
                                                  Colors.black.withOpacity(.2),
                                                ]
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2),
                                                  image:  DecorationImage(
                                                      image: NetworkImage(user.get('profilePic')),
                                                      fit: BoxFit.cover
                                                  )
                                              ),
                                            ),
                                            Text(user.get('userName'),style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                              }

                          ),
                        ),
                        //const SizedBox(height: 5,),
                      ]

                  ),
                ),

                TabBar(
                  controller: _tabController,
                  labelStyle:
                  Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: "Following"),
                    Tab(key: Key("Notifications"),text: "Notifications"),
                  ],
                  indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 8),
                  indicatorColor: Colors.grey.shade700,
                  unselectedLabelColor:Colors.grey.shade400,
                  labelColor: Colors.white,
                  // indicator: CircleTabIndicator(
                  //   radius: 4.1,
                  //   color: Colors.grey.shade600,
                  // ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    height: double.maxFinite,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(
                      controller: _tabController,
                      children:  [
                        FollowingTab(),
                        BlocProvider(
                          create: (context) =>
                              NotificationCubit(repository: Repository()),
                          child: NotificationTab(),
                        ),
                      ],
                    ),
                  ),
                ),
              ]


          ),
        ),
      ),
    );
  }
}

