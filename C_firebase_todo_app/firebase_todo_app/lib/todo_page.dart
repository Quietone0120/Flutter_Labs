import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'todo_service.dart';
import 'task_page.dart';
import 'animations.dart';

// ─── Shimmer Widget ───────────────────────────────────────────────────────────

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceVariant;
    final highlight = Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [base, highlight, base],
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton Plan Card ───────────────────────────────────────────────────────

class _SkeletonPlanCard extends StatelessWidget {
  const _SkeletonPlanCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ShimmerBox(
                    width: 10,
                    height: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(width: 14),
                  _ShimmerBox(
                    width: 160,
                    height: 16,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const Spacer(),
                  _ShimmerBox(
                    width: 24,
                    height: 24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ShimmerBox(
                width: 80,
                height: 12,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 10),
              _ShimmerBox(
                width: double.infinity,
                height: 6,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── TodoPage ─────────────────────────────────────────────────────────────────

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoService _service = TodoService();
  final TextEditingController _controller = TextEditingController();

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  void _showAddPlanDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "New Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter plan title...",
            prefixIcon: const Icon(Icons.folder_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
          onSubmitted: (_) => _submitPlan(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(onPressed: _submitPlan, child: const Text("Create")),
        ],
      ),
    );
  }

  void _submitPlan() {
    if (_controller.text.trim().isNotEmpty) {
      _service.addPlan(_controller.text.trim());
      _controller.clear();
      Navigator.pop(context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.space_dashboard_outlined,
                size: 52,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "No plans yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tap the button below to create\nyour first plan and get organized!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface.withOpacity(0.55),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Skeleton жагсаалт (анхны load) ────────────────────────────────────────
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: 4,
      itemBuilder: (_, __) => const _SkeletonPlanCard(),
    );
  }

  Widget _buildAvatar() {
    final user = _currentUser;
    final photoUrl = user?.photoURL;
    final displayName = user?.displayName ?? '';
    final initials = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: _showProfileMenu,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? Text(
                  initials,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void _showProfileMenu() {
    final user = _currentUser;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            CircleAvatar(
              radius: 36,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: user?.photoURL == null
                  ? Text(
                      (user?.displayName?.isNotEmpty == true)
                          ? user!.displayName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? "",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.red.shade50,
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Sign out",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _service.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("My Plans"),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [_buildAvatar()],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _service.getPlans(),
        builder: (context, snapshot) {
          // ── Анхны load: skeleton харуулна ──────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonList();
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) return _buildEmptyState(context);

          // ── Өгөгдөл ирсэн: жинхэнэ карт + staggered fade-in ─────────
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              key: const ValueKey('plan-list'),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: docs.length,
              itemBuilder: (context, index) => FadeSlideItem(
                key: ValueKey(docs[index].id),
                index: index,
                child: _PlanCard(
                  plan: docs[index],
                  service: _service,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPlanDialog,
        icon: const Icon(Icons.add),
        label: const Text("New Plan"),
        elevation: 4,
      ),
    );
  }
}

// ─── _PlanCard ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final QueryDocumentSnapshot plan;
  final TodoService service;

  const _PlanCard({super.key, required this.plan, required this.service});

  Color _statusColor(int done, int total) {
    if (total == 0) return Colors.grey.shade400;
    if (done == total) return const Color(0xFF4CAF50);
    if (done == 0) return const Color(0xFFEF5350);
    return const Color(0xFFFF9800);
  }

  String _statusLabel(int done, int total) {
    if (total == 0) return "No tasks";
    if (done == total) return "All done!";
    if (done == 0) return "Not started";
    return "In progress";
  }

  void _showEditPlanDialog(BuildContext context) {
    final data = plan.data() as Map<String, dynamic>?;
    final ctrl = TextEditingController(text: data?['title'] ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Plan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Update plan title...",
            prefixIcon: const Icon(Icons.edit_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
          onSubmitted: (_) => _submitEditPlan(context, ctrl),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => _submitEditPlan(context, ctrl),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _submitEditPlan(BuildContext context, TextEditingController ctrl) {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    service.updatePlan(plan.id, text);
    Navigator.pop(context);
  }

  void _showDeletePlanDialog(BuildContext context) {
    final data = plan.data() as Map<String, dynamic>?;
    final title = data?['title'] ?? 'this plan';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Plan?"),
        content: Text(
          "\"$title\" and all its tasks will be permanently deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              service.deletePlan(plan.id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = plan.data() as Map<String, dynamic>?;
    final title = data?['title'] ?? 'Untitled';
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<QuerySnapshot>(
      stream: service.getTasks(plan.id),
      builder: (context, taskSnap) {
        // ── Task load дуусаагүй үед skeleton progress bar харуулна ──────
        if (taskSnap.connectionState == ConnectionState.waiting &&
            !taskSnap.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _ShimmerBox(
                      width: double.infinity,
                      height: 6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final tasks = taskSnap.data?.docs ?? [];
        final total = tasks.length;
        final done = tasks.where((t) {
          final d = t.data() as Map<String, dynamic>?;
          return d?['isDone'] == true;
        }).length;

        final progress = total > 0 ? done / total : 0.0;
        final dotColor = _statusColor(done, total);
        final statusLabel = _statusLabel(done, total);

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: HeartbeatWidget(
            child: Card(
            elevation: 2,
            shadowColor: colorScheme.primary.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TaskPage(planId: plan.id, planTitle: title),
                    ),
                  ),
                  onLongPress: () => _showEditPlanDialog(context),
                  leading: Tooltip(
                    message: statusLabel,
                    child: Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: dotColor.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') _showEditPlanDialog(context);
                          if (value == 'delete') _showDeletePlanDialog(context);
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
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        total == 0 ? "No tasks yet" : "$done/$total done",
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.55),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ── Progress bar анимацитай ──────────────────────
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (_, value, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            backgroundColor: colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(dotColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}
