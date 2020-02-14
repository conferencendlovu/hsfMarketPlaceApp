import 'package:flutter/material.dart';
import 'package:sliverapp/basket.dart';
import 'package:sliverapp/itemCheckout.dart';

class MyFriendsListItem extends StatefulWidget {
  List<Basket> list;
  String user_id;
  MyFriendsListItem({Key key, this.list, this.user_id}) : super(key: key);
  @override
  _MyFriendsListItemState createState() => _MyFriendsListItemState();
}

class _MyFriendsListItemState extends State<MyFriendsListItem> {
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
              return ItemCheckout(
                id: widget.list[index].id,
                reciever: widget.user_id
              );
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
                height: 300,
                child: Center(
                  child: Image.network(
                    widget.list[index].image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                height: 300,
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
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "€" +
                            widget.list[index].cost +
                            "--" +
                            widget.list[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        widget.list[index].description,
                        //overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
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
