import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_repo/network/Response/post_response.dart';
import 'package:git_repo/view/widget/ShimmerWidget.dart';
import 'package:provider/provider.dart';
import '../provider/git_provider.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with WidgetsBindingObserver {
  var _post;
  var title = TextEditingController();
  var content = TextEditingController();

  List<dynamic> popUpMenu = [
    {"value": 1, "name": "Delete"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    triggerObservers();
    super.initState();
    _post = Provider.of<PostProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      this.hitpostDetails();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void triggerObservers() {
    WidgetsBinding.instance!.addObserver(this);
  }

  hitpostDetails() async {
    await _post.fetchPost(
      context,
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      child: const Text(
        'Interview Task',
        style: TextStyle(
            fontSize: 18.0,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
          // Color(0xFF662D91),
          title: _title(context),
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<PostProvider>(
              builder: (context, postDetails, __) => postDetails.isFetching
                  ? ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildShimmer();
                      })
                  // CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: postDetails.getPostResponse().length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return
                            // makeCard
                            Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Card(
                            elevation: 4.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              // leading: Image.asset('assets/logo.png'),
                              leading: Container(
                                padding: const EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.grey))),
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child:
                                        Image.asset('assets/programmer.png')),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    postDetails
                                                .getPostResponse()
                                                .elementAt(index)
                                                .title!
                                                .length >
                                            20
                                        ? postDetails
                                                .getPostResponse()
                                                .elementAt(index)
                                                .title!
                                                .substring(0, 20) +
                                            '...'
                                        : postDetails
                                                .getPostResponse()
                                                .elementAt(index)
                                                .title ??
                                            "",
                                  ),
                                  PopupMenuButton(
                                      child: Icon(
                                        Icons.more_vert,
                                        size: 16,
                                      ),
                                      elevation: 40,
                                      enabled: true,
                                      offset: Offset(0, 50),
                                      onSelected: (value) async {
                                        if (value == 1) {
                                          await Provider.of<PostProvider>(
                                                  context,
                                                  listen: false)
                                              .removePost(index);
                                          hitpostDetails();
                                        }
                                      },
                                      itemBuilder: (context) {
                                        return popUpMenu.map((dynamic choice) {
                                          return PopupMenuItem(
                                            value: choice["value"],
                                            child: Text(
                                              choice["name"],
                                            ),
                                          );
                                        }).toList();
                                      }),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    postDetails
                                            .getPostResponse()
                                            .elementAt(index)
                                            .body ??
                                        '',
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  // Text(" Intermediate", style: TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                        );
                        // );
                      })),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.add),
            backgroundColor: Colors.pinkAccent,
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Create Post'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: title,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  icon: Icon(Icons.title),
                                ),
                              ),
                              TextFormField(
                                controller: content,
                                decoration: InputDecoration(
                                  labelText: 'Content',
                                  icon: Icon(Icons.note_add),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.pink)),
                            child: Text("Submit",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .addPost(PostResponse(
                                      userId: 1,
                                      id: 1,
                                      title: title.text,
                                      body: content.text));
                              hitpostDetails();
                              Navigator.pop(context);
                              // your code
                            })
                      ],
                    );
                  });
            }));
  }

  Widget buildShimmer() => ListTile(
      leading: ShimmerWidget.circular(
        width: 48,
        height: 48,
        shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      title: Align(
          alignment: Alignment.centerLeft,
          child: ShimmerWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.3,
          )),
      subtitle: ShimmerWidget.rectangular(height: 14));
}
