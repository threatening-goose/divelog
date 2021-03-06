import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home_state.dart';

class EasingAnimationWidget extends StatefulWidget {
  @override
  EasingAnimationWidgetState createState() => EasingAnimationWidgetState();
}

class EasingAnimationWidgetState extends State<EasingAnimationWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  Widget build(BuildContext context) {
    final screenDimens = MediaQuery.of(context).size;
    final double height = screenDimens.height;
    final double width = screenDimens.width;
    _controller.forward();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Hero(
        tag: "hero-fab",
        child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                  backgroundColor: Theme.of(context).accentColor,
                  body: Transform(
                    transform: Matrix4.translationValues(
                        0.0, -_animation.value * height + (height * 0.05), 0.0),
                    child: new Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0))),
                                width: width * 0.9,
                                height: height * 0.9,
                                child: Column(children: <Widget>[
                                  Container(
                                    width: width * 0.9,
                                    height: height * 0.3,
                                    child: HomeState(Colors.blue),
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(children: getFormItems())),
                                ])))),
                  ));
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuint,
    ))
      ..addStatusListener(handler);
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Unsaved data will be lost.'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () =>
                        {Navigator.of(context).pop(false), closeLogger()},
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void clearForm(status) {}

  void closeLogger() {
    _animation.removeStatusListener(handler);
    _controller.reset();
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
        }
      });
    _controller.forward();
  }

  void handler(status) {
    if (status == AnimationStatus.completed) {
//      _animation.removeStatusListener(handler);
//      _controller.reset();
//      _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//        parent: _controller,
//        curve: Curves.fastOutSlowIn,
//      ))
//        ..addStatusListener((status) {
//          if (status == AnimationStatus.completed) {
//            Navigator.pop(context);
//          }
//        });
//      _controller.forward();
    }
  }

  List<Widget> getFormItems() {
    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(child: _genericTextField("Date")),
          Expanded(child: _genericTextField("Dive buddy"))
        ],
      ),
      _genericTextField("Date"),
      _genericTextField("Dive location"),
      _genericTextField("Max depth"),
      _genericTextField("Average depth"),
      _genericTextField("Temperature"),
      _genericTextField("visibility"),
    ];
  }

  Widget _genericTextField(String text, ) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 2.5),
        child: TextField(
          onChanged: (text) => {},
          decoration: InputDecoration(
              filled: true, fillColor: Colors.white, hintText: text),
          autofocus: false,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
