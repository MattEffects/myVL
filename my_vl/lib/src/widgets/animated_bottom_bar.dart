import 'package:flutter/material.dart';

class BarItem {
  String text;
  IconData iconData;
  IconData selectedIconData;
  Color color;

  BarItem({
    @required this.text, 
    @required this.iconData, 
    this.selectedIconData, 
    this.color = Colors.blue});
}


class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;
  const BarStyle({this.fontSize = 14.0, this.iconSize = 25.0, this.fontWeight = FontWeight.w500});
}

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;

  AnimatedBottomBar({
    this.barItems,
    this.animationDuration = const Duration(milliseconds: 150),
    this.onBarTap,
    this.barStyle = const BarStyle(),
  });

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          top: 10.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int index = 0; index < widget.barItems.length; index++) {
      BarItem item = widget.barItems[index];
      bool _isSelected = selectedBarIndex == index;
      _barItems.add(InkWell(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        splashColor: item.color.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = index;
            widget.onBarTap(selectedBarIndex);
          });
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          duration: widget.animationDuration,
          decoration: BoxDecoration(
              color: _isSelected ? item.color.withOpacity(0.1) : null,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: <Widget>[
              Icon(
                 (_isSelected && item.selectedIconData != null) ? item.selectedIconData : item.iconData,
                size: widget.barStyle.iconSize,
                color: _isSelected ? item.color : Colors.grey.shade600,
              ),
              SizedBox(
                width: _isSelected ? 7.0 : 0.0,
              ),
              AnimatedSize(
                duration: widget.animationDuration,
                vsync: this,
                curve: Curves.easeInOut,
                child: Text(
                  _isSelected ? item.text : '',
                  style: TextStyle(
                    color: _isSelected ? item.color : Colors.grey.shade600,
                    fontWeight: widget.barStyle.fontWeight,
                    fontSize: widget.barStyle.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }
}
