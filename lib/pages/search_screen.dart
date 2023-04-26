import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/user_search_result_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchUserController = TextEditingController();
  String searchName = '';
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamResult;

  @override
  void initState() {
    super.initState();
    streamResult = FirebaseFirestore.instance.collection('profile').snapshots();
  }

  void updateSearchResult() async {
    streamResult = FirebaseFirestore.instance.collection('profile').snapshots();
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            splashRadius: 20,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Search',
            selectionColor: Colors.blue,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Arial',
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 1,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                width: size.width - 30,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF262626)
                ),
                child: TextField(
                  onChanged: (String value) {
                    setState(() {
                      searchName = value;
                      updateSearchResult();
                    });
                  },
                  decoration: const InputDecoration(
                      hintText: 'Search Users',
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Color(0xFFFFFFFF).withOpacity(0.3),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streamResult,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Connection Error!'),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data found!'),
                    );
                  }
                  return UserSearchResultList(
                    searchName: searchName,
                    snapshot: snapshot,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

