import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowingTab extends StatefulWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<FollowingTab>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10),
      separatorBuilder: (BuildContext context, int index) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 0.5,
            width: MediaQuery.of(context).size.width / 1.3,
            child: Divider(),
          ),
        );
      },
      itemCount: 16,
      itemBuilder: (BuildContext context, int index) {
       // Map notif = notifications[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?cs=srgb&dl=pexels-andrea-piacquadio-733872.jpg&fm=jpg',
              ),
              radius: 25,
            ),
            contentPadding: EdgeInsets.all(0),
            title: const Text('Lebron James started following you',
              style: TextStyle(color: Colors.white),

            ),
            trailing: const Text(
              '4 hours ago',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}