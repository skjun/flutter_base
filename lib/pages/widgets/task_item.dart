import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medical/bean/report_bean.dart';
import 'package:medical/model/global_model.dart';
import 'package:medical/pages/widgets/task_info_widget.dart';
import 'package:provider/provider.dart';

class TaskItem extends StatelessWidget {
  final int index;
  final ReportBean reportBean;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  TaskItem(this.index, this.reportBean, {this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    final opacity = 1.0;

    final widget = TaskInfoWidget(
      index,
      space: 0,
      reportBean: reportBean,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return Container(
      margin: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Hero(
            tag: "task_bg$index",
            child: Container(
              decoration: BoxDecoration(
                color: globalModel.getBgInDark().withOpacity(opacity),
                borderRadius: BorderRadius.circular(15.0),
                // image: bgUrl == null
                //     ? null
                //     : DecorationImage(
                //         image: getProvider(bgUrl),
                //         colorFilter: new ColorFilter.mode(
                //             Colors.black.withOpacity(opacity),
                //             BlendMode.dstATop),
                //         fit: BoxFit.cover,
                //       ),
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: widget,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
