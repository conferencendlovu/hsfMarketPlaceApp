import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliverapp/db.dart';
import 'package:sliverapp/product_detail.dart';
import 'package:sliverapp/wishnote_model.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  Future<List<WishNote>> notes;
  bool isUpdate = false;
  int noteIdForUpdate;
  DBHelper dbHelper;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshNoteList();
  }

  refreshNoteList() {
    setState(() {
      notes = dbHelper.getWishNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color(0xff000000).withOpacity(0.9),
                    Color(0xff283593).withOpacity(0.9)
                  ])),
              child: FutureBuilder(
                future: notes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return generateList(snapshot.data);
                  }
                  if (snapshot.data == null || snapshot.data.length == 0) {
                    return Text('No Data Found');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ))
          ],
        ));
  }

  SingleChildScrollView generateList(List<WishNote> notes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'NAME',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'DELETE',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
            rows: notes
                .map(
                  (note) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          note.note,
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            isUpdate = true;
                            noteIdForUpdate = note.id;
                          });
                          Get.to(ProductDetail(id: note.productId.toString()));
                        },
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            dbHelper.delete(note.id);
                            refreshNoteList();
                          },
                        ),
                      )
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
