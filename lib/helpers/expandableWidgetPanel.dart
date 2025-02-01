import 'package:flutter/material.dart';

class ExpandedWidgetPanel extends StatefulWidget{
  final String title;
  final Widget child;
  final Widget? leadingTitle;
  final Color backgroundColor;
  ExpandedWidgetPanel({this.leadingTitle, required this.title, required this.child, this.backgroundColor = Colors.white});
  @override
  _ExpandedWidgetPanel createState() => _ExpandedWidgetPanel();
}

class _ExpandedWidgetPanel extends State<ExpandedWidgetPanel>{
  bool _expanded = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ExpansionPanelList(
        animationDuration: Duration(milliseconds: 500),
        elevation: 0,
        children: [
          ExpansionPanel(
            backgroundColor: widget.backgroundColor,
            headerBuilder: (context, isExpanded){
              return ListTile(
                leading: widget.leadingTitle,
                title: Text(widget.title, textAlign: TextAlign.center),
              );
            },
            body: widget.child,
            isExpanded: _expanded,
            canTapOnHeader: true,
          ),
        ],
        expansionCallback: (panelIndex, isExpanded){
          _expanded = !_expanded;
          setState(() {
          });
        },
      ),
    );
  }
}