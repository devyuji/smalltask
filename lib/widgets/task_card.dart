import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smalltask/constraint.dart';
import 'package:smalltask/database/db.dart';
import 'package:smalltask/models.dart';
import 'package:smalltask/provider.dart/stopwatch_state.dart';
import 'package:smalltask/provider.dart/task_state.dart';
import 'package:smalltask/widgets/modal/custom_bottom_modal.dart';
import 'package:smalltask/widgets/modal/edit_task_modal.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key? key,
    required this.data,
    required this.listKey,
  }) : super(key: key);

  final Task data;
  final GlobalKey<AnimatedListState> listKey;

  Future<void> _delete(BuildContext context) async {
    final _data = Provider.of<TaskState>(context, listen: false).data;
    int index = _data.indexOf(data);

    await Db.instance.delete(data.id);
    Provider.of<TaskState>(context, listen: false).delete(data.id);

    if (_data.isEmpty) {
      Provider.of<StopWatchState>(context, listen: false)
          .toggleTime(StopWatchExecute.reset);
    }

    listKey.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: TaskCard(data: data, listKey: listKey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade800,
          ),
        ),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: <Widget>[
            SlidableAction(
              flex: 1,
              onPressed: _delete,
              icon: Icons.delete_outlined,
              autoClose: true,
              backgroundColor: kPrimaryColor,
            )
          ],
        ),
        child: ListTile(
          onTap: () async {
            await Db.instance.toggleDone(!data.isDone, data.id);
            Provider.of<TaskState>(context, listen: false).toggleDone(data.id);
          },
          onLongPress: () {
            customBottomModal(context, EditModal(value: data));
          },
          contentPadding: const EdgeInsets.all(kDefaultPadding * 2),
          leading: SizedBox(
            height: double.infinity,
            child: SvgPicture.asset(
              "assets/icons/dot.svg",
              width: 10.0,
            ),
          ),
          title: Text(
            data.taskName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              decorationThickness: 10,
              decoration: data.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
