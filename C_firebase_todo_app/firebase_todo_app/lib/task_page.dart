import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'todo_service.dart';
import 'animations.dart';

class TaskPage extends StatefulWidget {
  final String planId;
  final String planTitle;

  const TaskPage({super.key, required this.planId, required this.planTitle});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TodoService _service = TodoService();

  // ─── Add task dialog ───────────────────────────────────────────────────────
  void _showAddTaskDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter task name...",
            prefixIcon: const Icon(Icons.task_alt_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
          onSubmitted: (_) => _submitAdd(ctx, ctrl),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => _submitAdd(ctx, ctrl),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _submitAdd(BuildContext ctx, TextEditingController ctrl) {
    final text = ctrl.text.trim();
    if (text.isNotEmpty) {
      _service.addTask(widget.planId, text);
      Navigator.pop(ctx);
    }
  }

  // ─── Edit task dialog ──────────────────────────────────────────────────────
  void _showEditTaskDialog(String taskId, String currentTitle) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Task name...",
            prefixIcon: const Icon(Icons.edit_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
          onSubmitted: (_) => _submitEdit(ctx, taskId, ctrl),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => _submitEdit(ctx, taskId, ctrl),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _submitEdit(
    BuildContext ctx,
    String taskId,
    TextEditingController ctrl,
  ) {
    final text = ctrl.text.trim();
    if (text.isNotEmpty) {
      _service.updateTask(widget.planId, taskId, text);
      Navigator.pop(ctx);
    }
  }

  // ─── Delete confirmation ───────────────────────────────────────────────────
  void _confirmDelete(String taskId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Task?"),
        content: Text("\"$title\" will be permanently deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              _service.deleteTask(widget.planId, taskId);
              Navigator.pop(ctx);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // ─── Empty state ───────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.checklist_rounded, size: 50, color: cs.primary),
            ),
            const SizedBox(height: 22),
            Text(
              "No tasks yet",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the + button to add your\nfirst task and start making progress!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withOpacity(0.55),
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(widget.planTitle),
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.getTasks(widget.planId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) return _buildEmptyState(context);

          final undone = docs.where((t) {
            final d = t.data() as Map<String, dynamic>?;
            return d?['isDone'] != true;
          }).toList();
          final doneItems = docs.where((t) {
            final d = t.data() as Map<String, dynamic>?;
            return d?['isDone'] == true;
          }).toList();
          final ordered = [...undone, ...doneItems];

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: ordered.length,
            itemBuilder: (context, index) {
              final task = ordered[index];
              final data = task.data() as Map<String, dynamic>?;
              final isDone = data?['isDone'] == true;
              return FadeSlideItem(
                key: ValueKey(task.id),
                index: index,
                child: _TaskItem(
                  task: task,
                  isDone: isDone,
                  service: _service,
                  planId: widget.planId,
                  onEdit: (id, title) => _showEditTaskDialog(id, title),
                  onDelete: (id, title) => _confirmDelete(id, title),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        elevation: 4,
      ),
    );
  }
}

// ─── _TaskItem — hover устгасан, PopupMenuButton нэмсэн ──────────────────────

class _TaskItem extends StatelessWidget {
  final QueryDocumentSnapshot task;
  final bool isDone;
  final TodoService service;
  final String planId;
  final void Function(String id, String title) onEdit;
  final void Function(String id, String title) onDelete;

  const _TaskItem({
    super.key,
    required this.task,
    required this.isDone,
    required this.service,
    required this.planId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final data = task.data() as Map<String, dynamic>?;
    final title = data?['title'] ?? 'Untitled';

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete(task.id, title);
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_sweep, color: Colors.white, size: 26),
      ),
      child: GestureDetector(
        onLongPress: () => onEdit(task.id, title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isDone ? cs.surfaceVariant.withOpacity(0.4) : cs.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDone
                  ? cs.outline.withOpacity(0.1)
                  : cs.outline.withOpacity(0.2),
            ),
            boxShadow: isDone
                ? []
                : [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            leading: GestureDetector(
              onTap: () => service.toggleTask(planId, task.id, isDone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? cs.primary : Colors.transparent,
                  border: Border.all(
                    color: isDone ? cs.primary : cs.outline.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 15.5,
                decoration: isDone ? TextDecoration.lineThrough : null,
                decorationColor: cs.onSurface.withOpacity(0.4),
                color: isDone ? cs.onSurface.withOpacity(0.4) : cs.onSurface,
                fontWeight: isDone ? FontWeight.normal : FontWeight.w500,
              ),
              child: Text(title),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: cs.onSurface.withOpacity(0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'edit') onEdit(task.id, title);
                if (value == 'delete') onDelete(task.id, title);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text("Edit"),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      "Delete",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
