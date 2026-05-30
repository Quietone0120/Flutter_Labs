import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// USER PROFILES
// ─────────────────────────────────────────────────────────────────────────────
class UserProfile {
  final String id;
  final String name;
  final Color avatarColor;
  final String avatarInitial;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.avatarInitial,
  });
}

const UserProfile userA = UserProfile(
  id: 'A',
  name: 'Бат',
  avatarColor: Color(0xFF0084FF),
  avatarInitial: 'Б',
);

const UserProfile userB = UserProfile(
  id: 'B',
  name: 'Мөнх',
  avatarColor: Color(0xFFE91E8C),
  avatarInitial: 'М',
);

// ─────────────────────────────────────────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// APP
// ─────────────────────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messenger Chat',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0084FF),
        ),
      ),
      home: const DualChatScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DUAL CHAT SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class DualChatScreen extends StatefulWidget {
  const DualChatScreen({super.key});

  @override
  State<DualChatScreen> createState() => _DualChatScreenState();
}

class _DualChatScreenState extends State<DualChatScreen> {
  final ChatBloc _sharedBloc = ChatBloc();

  @override
  void dispose() {
    _sharedBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 700;

    if (isWide) {
      return Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: Row(
          children: [
            Expanded(
              child: _ChatPane(
                bloc: _sharedBloc,
                me: userA,
                other: userB,
              ),
            ),
            Container(width: 1.5, color: Colors.white12),
            Expanded(
              child: _ChatPane(
                bloc: _sharedBloc,
                me: userB,
                other: userA,
              ),
            ),
          ],
        ),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFF0084FF),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0084FF),
            elevation: 0,
            title: const Text(
              'Messenger',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: [Tab(text: '👤 Бат'), Tab(text: '👤 Мөнх')],
            ),
          ),
          body: TabBarView(
            children: [
              _ChatPane(bloc: _sharedBloc, me: userA, other: userB),
              _ChatPane(bloc: _sharedBloc, me: userB, other: userA),
            ],
          ),
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHAT PANE
// ─────────────────────────────────────────────────────────────────────────────
class _ChatPane extends StatefulWidget {
  final ChatBloc bloc;
  final UserProfile me;
  final UserProfile other;

  const _ChatPane({required this.bloc, required this.me, required this.other});

  @override
  State<_ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<_ChatPane> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    widget.bloc.sendMessage(text, widget.me.id);
    _textCtrl.clear();
    setState(() => _isTyping = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: widget.bloc.messageStream,
              initialData: widget.bloc.messages,
              builder: (ctx, snap) {
                final msgs = snap.data ?? [];
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return _buildMessageList(msgs);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 10, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE4E6EA))),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              _Avatar(profile: widget.other, radius: 22),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF31A24C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.other.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF050505),
                  ),
                ),
                const Text(
                  'Онлайн',
                  style: TextStyle(fontSize: 12, color: Color(0xFF31A24C), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          _HeaderIconBtn(icon: Icons.phone_rounded, color: const Color(0xFF0084FF)),
          const SizedBox(width: 4),
          _HeaderIconBtn(icon: Icons.videocam_rounded, color: const Color(0xFF0084FF)),
          const SizedBox(width: 4),
          _HeaderIconBtn(icon: Icons.info_outline_rounded, color: const Color(0xFF0084FF)),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> msgs) {
    if (msgs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Avatar(profile: widget.other, radius: 36),
            const SizedBox(height: 12),
            Text(
              widget.other.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF050505),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Мессенжер • Дотны найз',
              style: TextStyle(fontSize: 13, color: Color(0xFF65676B)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Эхний мессежийг илгээнэ үү...',
              style: TextStyle(fontSize: 13, color: Color(0xFF65676B)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: msgs.length,
      itemBuilder: (ctx, i) {
        final msg = msgs[i];
        final isFromMe = msg.senderId == widget.me.id;
        final isFirstInGroup = i == 0 || msgs[i - 1].senderId != msg.senderId;
        final isLastInGroup = i == msgs.length - 1 || msgs[i + 1].senderId != msg.senderId;

        return _MessageRow(
          message: msg,
          isFromMe: isFromMe,
          senderProfile: isFromMe ? widget.me : widget.other,
          showAvatar: !isFromMe && isLastInGroup,
          isFirstInGroup: isFirstInGroup,
          isLastInGroup: isLastInGroup,
          isLast: i == msgs.length - 1,
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E6EA))),
      ),
      child: Row(
        children: [
          Icon(Icons.add_circle_rounded, color: const Color(0xFF0084FF), size: 28),
          const SizedBox(width: 6),
          Icon(Icons.camera_alt_rounded, color: const Color(0xFF0084FF), size: 28),
          const SizedBox(width: 6),
          Icon(Icons.mic_rounded, color: const Color(0xFF0084FF), size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: _textCtrl,
                style: const TextStyle(fontSize: 15, color: Color(0xFF050505)),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                onChanged: (v) => setState(() => _isTyping = v.isNotEmpty),
                decoration: InputDecoration(
                  hintText: '${widget.me.name} бичих...',
                  hintStyle: const TextStyle(color: Color(0xFF8A8D91), fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: _isTyping
                ? GestureDetector(
                    key: const ValueKey('send'),
                    onTap: _send,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0084FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  )
                : GestureDetector(
                    key: const ValueKey('thumb'),
                    onTap: () => widget.bloc.sendMessage('👍', widget.me.id),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('👍', style: TextStyle(fontSize: 26)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MESSAGE ROW
// ─────────────────────────────────────────────────────────────────────────────
class _MessageRow extends StatelessWidget {
  final ChatMessage message;
  final bool isFromMe;
  final UserProfile senderProfile;
  final bool showAvatar;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final bool isLast;

  const _MessageRow({
    required this.message,
    required this.isFromMe,
    required this.senderProfile,
    required this.showAvatar,
    required this.isFirstInGroup,
    required this.isLastInGroup,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    const avatarSpace = 34.0;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(isFromMe ? 18 : (isFirstInGroup ? 18 : 4)),
      topRight: Radius.circular(isFromMe ? (isFirstInGroup ? 18 : 4) : 18),
      bottomLeft: Radius.circular(isFromMe ? 18 : (isLastInGroup ? 18 : 4)),
      bottomRight: Radius.circular(isFromMe ? (isLastInGroup ? 4 : 18) : 18),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInGroup ? 6 : 1,
        bottom: isLastInGroup ? 2 : 1,
      ),
      child: Column(
        crossAxisAlignment: isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isFromMe)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: showAvatar
                      ? _Avatar(profile: senderProfile, radius: 14)
                      : const SizedBox(width: avatarSpace),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.62,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: isFromMe ? const Color(0xFF0084FF) : const Color(0xFFF0F2F5),
                    borderRadius: radius,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isFromMe ? Colors.white : const Color(0xFF050505),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLastInGroup || (isLast && isFromMe))
            Padding(
              padding: EdgeInsets.only(
                left: isFromMe ? 0 : avatarSpace + 12,
                right: 4,
                top: 3,
                bottom: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.time),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF65676B)),
                  ),
                  if (isFromMe && isLast) ...[
                    const SizedBox(width: 4),
                    _StatusIcon(status: message.status),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS ICON
// ─────────────────────────────────────────────────────────────────────────────
class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12, height: 12,
          child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF0084FF)),
        );
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Color(0xFF65676B));
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Color(0xFF65676B));
      case MessageStatus.seen:
        return const Icon(Icons.done_all, size: 14, color: Color(0xFF0084FF));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AVATAR
// ─────────────────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final UserProfile profile;
  final double radius;
  const _Avatar({required this.profile, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: profile.avatarColor,
      child: Text(
        profile.avatarInitial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.85,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _HeaderIconBtn({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
