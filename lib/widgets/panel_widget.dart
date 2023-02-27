import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/view_story_screen.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  const PanelWidget({
    Key? key,
  required this.controller,
  })

      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  late List<DocumentSnapshot> _users;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('profile')
        .get()
        .then((querySnapshot) => setState(() => _users = querySnapshot.docs));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 10,top:10),

      child: CustomScrollView(
        controller: widget.controller,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 220,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text("Stories", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1.2),),

                      ],
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      height: 160,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _users.length,
                          itemBuilder: (BuildContext context, int index) {
                            var user = _users[index];
                            return AspectRatio(
                              aspectRatio: 1.6 / 2.4,
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
                                        Text(user.get('displayName'),style: TextStyle(color: Colors.white),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );

                          }

                      ),


                    ),

                  ]

              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[200]
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey,),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Search",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  //Icon(Icons.camera_alt, color: Colors.grey[800], size: 30,)
                ],
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                mainAxisExtent: 170,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  onLongPress: () => {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
                          )
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

