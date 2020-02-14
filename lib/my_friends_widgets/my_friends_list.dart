import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:sliverapp/my_friends_items.dart';
import 'package:sliverapp/users.dart';

class MyFriendsList extends StatefulWidget {
  List<Users> list;
  MyFriendsList({Key key, this.list}) : super(key: key);
  @override
  _MyFriendsListState createState() => _MyFriendsListState();
}

class _MyFriendsListState extends State<MyFriendsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          return friends(context, index);
        });
  }

  Widget friends(BuildContext context, int index) {
    return InkWell(
      onTap: () {
       Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyFriendsItems(id: widget.list[index].id,);
                  },
                ),
              );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(5)),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Center(
                  child: Image.network(
                    "https://i.imgur.com/7qSm5fG.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: index % 2 == 0
                            ? [
                                Color(0xff000000).withOpacity(0.9),
                                Color(0xff283593).withOpacity(0.9)
                              ]
                            : [
                                Color(0xff283593).withOpacity(0.9),
                                Color(0xff000000).withOpacity(0.9)
                              ])),
              ),
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.list[index].email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "wishes to buy " +
                            widget.list[index].count.toString() +
                            " items",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
