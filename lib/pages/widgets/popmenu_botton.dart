import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:provider/provider.dart';

class PopMenuBt extends StatelessWidget {
  final Color iconColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ReportBean reportBean;

  const PopMenuBt({
    Key key,
    this.iconColor,
    this.onDelete,
    this.onEdit,
    this.reportBean,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    return PopupMenuButton(
      onSelected: (a) {
        switch (a) {
          case "edit":
            if (onEdit != null) onEdit();
            break;
          case "delete":
            if (onDelete != null) onDelete();
            break;
        }
      },
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: "edit",
            child: ListTile(
              title: Text("编辑"),
              leading: Icon(
                Icons.edit,
                color: iconColor,
              ),
            ),
          ),
          PopupMenuItem(
              value: "delete",
              child: ListTile(
                title: Text("删除"),
                leading: Icon(Icons.delete, color: iconColor),
              )),
        ];
      },
      icon: Icon(
        Icons.more_vert,
        color: iconColor ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
