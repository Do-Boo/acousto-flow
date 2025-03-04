import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../utils/carbon_colors.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Mock data for posts
  final List<Post> _posts = [];
  
  @override
  void initState() {
    super.initState();
    
    // Generate sample posts
    _generateSamplePosts();
  }
  
  void _generateSamplePosts() {
    final user1 = User(
      id: '1',
      name: '김민준',
      avatar: 'assets/avatars/user1.png',
      username: 'minjun_kim',
      department: '음향실'
    );
    
    final user2 = User(
      id: '2',
      name: '이서연',
      avatar: 'assets/avatars/user2.png',
      username: 'seoyeon_lee',
      department: '음향실'
    );
    
    final user3 = User(
      id: '3',
      name: '박지훈',
      avatar: 'assets/avatars/user3.png',
      username: 'jihoon_park',
      department: '음향실'
    );
    
    _posts.add(
      Post(
        id: '1',
        user: user1,
        content: '오늘 A동 대회의실 마이크 시스템 점검 완료했습니다. 무선 마이크 2개 배터리 교체하고, 수신기 위치 조정했습니다. 다음 주 화요일 경영진 회의 준비 완료했습니다.',
        images: ['assets/images/mic_setup1.jpg', 'assets/images/mic_setup2.jpg'],
        location: 'A동 대회의실',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        comments: [
          Comment(
            id: '1',
            user: user2,
            content: '고생하셨습니다. 화요일 회의 때 음향 담당은 제가 할게요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          ),
          Comment(
            id: '2',
            user: user1,
            content: '네, 알겠습니다. 회의 시작 30분 전에 미리 준비해주세요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
        ],
        likes: 24,
      ),
    );
    
    _posts.add(
      Post(
        id: '2',
        user: user2,
        content: 'B동 교육장 빔프로젝터 설치 완료했습니다. HDMI와 무선 연결 모두 테스트 완료했습니다. 내일 신입사원 교육 준비 완료했습니다.',
        images: ['assets/images/projector_setup.jpg'],
        location: 'B동 교육장',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        comments: [],
        likes: 8,
      ),
    );
    
    _posts.add(
      Post(
        id: '3',
        user: user3,
        content: 'C동 회의실 3, 4, 5 음향 시스템 전체 점검했습니다. 회의실 4의 스피커에서 간헐적으로 노이즈가 발생하는 문제가 있어 케이블 교체했습니다. 현재는 정상 작동 확인했습니다.',
        images: [],
        location: 'C동 회의실',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        comments: [
          Comment(
            id: '3',
            user: user1,
            content: '회의실 4 스피커 문제 해결해주셔서 감사합니다. 지난 주 회의 때 노이즈 때문에 불편했었는데요.',
            timestamp: DateTime.now().subtract(const Duration(hours: 23)),
          ),
        ],
        likes: 5,
      ),
    );
    
    _posts.add(
      Post(
        id: '4',
        user: user1,
        content: '업무용 장비 재고 현황 업데이트했습니다. 무선마이크 배터리 재고가 부족하니 추가 구매 필요합니다. 발주 요청 올렸습니다.',
        images: ['assets/images/inventory.jpg'],
        location: '음향실 사무실',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        comments: [
          Comment(
            id: '4',
            user: user3,
            content: '발주 승인 처리했습니다. 다음 주 화요일에 입고 예정입니다.',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22)),
          ),
        ],
        likes: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            '피드',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
              fontSize: 16,
            ),
          ),
          centerTitle: false,
          backgroundColor: backgroundColor,
          elevation: 0,
          systemOverlayStyle: isDarkMode
              ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
              : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedSearch01, color: isDarkMode ? Colors.white : CarbonColors.gray80),
              onPressed: () {
                // Search posts
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Refresh posts
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              // In a real app, this would fetch new posts
            });
          },
          color: CarbonColors.blue60,
          child: _posts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return _buildPostCard(post);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feed_outlined,
            size: 64,
            color: CarbonColors.gray60,
          ),
          const SizedBox(height: 16),
          Text(
            '피드가 비어있습니다',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 게시물을 작성해보세요',
            style: TextStyle(
              fontSize: 14,
              color: CarbonColors.gray60,
            ),
          ),
          const SizedBox(height: 24),
          _buildCarbonButton(
            label: '글 작성하기',
            icon: HugeIcons.strokeRoundedAdd01,
            onPressed: () {
              _showCreatePostDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonButton({
    required String label,
    required VoidCallback onPressed,
    IconData? icon,
    bool isPrimary = true,
    bool isSmall = false,
  }) {
    final height = isSmall ? 32.0 : 48.0;
    final horizontalPadding = isSmall ? 16.0 : 20.0;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? CarbonColors.blue60 : Colors.transparent,
        foregroundColor: isPrimary ? Colors.white : CarbonColors.blue60,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: isPrimary ? BorderSide.none : BorderSide(color: CarbonColors.blue60),
        ),
        minimumSize: Size(88, height),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 16 : 20),
            SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 14 : 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? CarbonColors.gray100 : Colors.white,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                _buildCarbonAvatar(post.user.name),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username and time
                      Row(
                        children: [
                          Text(
                            post.user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(post.timestamp),
                            style: TextStyle(
                              color: CarbonColors.gray60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      
                      // Department
                      Text(
                        post.user.department,
                        style: TextStyle(
                          color: CarbonColors.gray60,
                          fontSize: 12,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Post content
                      Text(
                        post.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      
                      // Post images
                      if (post.images.isNotEmpty) 
                        _buildPostImages(post.images),
                      
                      // Location
                      if (post.location.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _buildLocationTag(post.location),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Interaction buttons
                      Row(
                        children: [
                          _buildInteractionButton(
                            HugeIcons.strokeRoundedThumbsUp,
                            post.likes.toString(),
                            () {
                              // Like post
                            },
                          ),
                          const SizedBox(width: 24),
                          _buildInteractionButton(
                            HugeIcons.strokeRoundedComment01,
                            post.comments.length.toString(),
                            () {
                              // Show comments
                              _showComments(post);
                            },
                          ),
                          const SizedBox(width: 24),
                          _buildInteractionButton(
                            HugeIcons.strokeRoundedRepeat,
                            '0',
                            () {
                              // Repost
                            },
                          ),
                          const SizedBox(width: 24),
                          _buildInteractionButton(
                            HugeIcons.strokeRoundedShare01,
                            '',
                            () {
                              // Share post
                            },
                          ),
                        ],
                      ),
                      
                      // Preview first comment if any
                      if (post.comments.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildFirstCommentPreview(post.comments.first),
                        ),
                    ],
                  ),
                ),
                
                // More options
                IconButton(
                  icon: Icon(
                    Icons.more_horiz, 
                    color: CarbonColors.gray60, 
                    size: 20
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    // Show post options
                    _showPostOptions(post);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarbonAvatar(String name) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: CarbonColors.blue60,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        name.characters.first,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildLocationTag(String location) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CarbonColors.gray10,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined, 
            size: 14, 
            color: CarbonColors.gray60
          ),
          const SizedBox(width: 4),
          Text(
            location,
            style: TextStyle(
              fontSize: 12,
              color: CarbonColors.gray60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: CarbonColors.gray60),
          if (count.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                count,
                style: TextStyle(
                  color: CarbonColors.gray60,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFirstCommentPreview(Comment comment) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: CarbonColors.blue60,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              comment.user.name.characters.first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(comment.timestamp),
                      style: TextStyle(
                        color: CarbonColors.gray60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white70 : CarbonColors.gray80,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages(List<String> images) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: CarbonColors.gray20,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: CarbonColors.gray60,
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '새 게시물',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: CarbonColors.gray60),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCarbonAvatar('김'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '김도유',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '음향실',
                            style: TextStyle(
                              color: CarbonColors.gray60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  maxLines: 6,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '무슨 일을 하셨나요?',
                    hintStyle: TextStyle(color: CarbonColors.gray60),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.image_outlined, color: CarbonColors.gray60),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on_outlined, color: CarbonColors.gray60),
                    const Spacer(),
                    _buildCarbonButton(
                      label: '게시',
                      onPressed: () {
                        Navigator.pop(context);
                        // Create post
                      },
                      isSmall: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showComments(Post post) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray100 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    final borderColor = isDarkMode ? CarbonColors.gray80 : CarbonColors.gray20;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '댓글',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: CarbonColors.gray60),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: post.comments.isEmpty 
                      ? Center(
                          child: Text(
                            '아직 댓글이 없습니다',
                            style: TextStyle(color: CarbonColors.gray60),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: post.comments.length,
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: borderColor, width: 0.5),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: CarbonColors.blue60,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      comment.user.name.characters.first,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.user.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _formatTimestamp(comment.timestamp),
                                              style: TextStyle(
                                                color: CarbonColors.gray60,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.content,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              '답글',
                                              style: TextStyle(
                                                color: CarbonColors.blue60,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(
                                              Icons.favorite_border,
                                              size: 16,
                                              color: CarbonColors.gray60,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildCarbonAvatar('김'),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDarkMode ? CarbonColors.gray90 : CarbonColors.gray10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: '댓글 작성...',
                              hintStyle: TextStyle(color: CarbonColors.gray60),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.send,
                        color: CarbonColors.blue60,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPostOptions(Post post) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? CarbonColors.gray90 : Colors.white;
    final textColor = isDarkMode ? Colors.white : CarbonColors.gray100;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: CarbonColors.gray60,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionItem(
                icon: Icons.edit,
                text: '수정하기',
                onTap: () {
                  Navigator.pop(context);
                  // Edit post
                },
              ),
              _buildOptionItem(
                icon: Icons.delete,
                text: '삭제하기',
                onTap: () {
                  Navigator.pop(context);
                  // Delete post
                },
                isDestructive: true,
              ),
              _buildOptionItem(
                icon: Icons.share,
                text: '공유하기',
                onTap: () {
                  Navigator.pop(context);
                  // Share post
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDestructive 
        ? CarbonColors.red60 
        : (isDarkMode ? Colors.white : CarbonColors.gray100);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, 
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return DateFormat('yyyy년 MM월 dd일').format(timestamp);
    }
  }
}

class User {
  final String id;
  final String name;
  final String avatar;
  final String department;
  final String username;
  
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.department,
    required this.username,
  });
}

class Post {
  final String id;
  final User user;
  final String content;
  final List<String> images;
  final String location;
  final DateTime timestamp;
  final List<Comment> comments;
  final int likes;
  
  const Post({
    required this.id,
    required this.user,
    required this.content,
    required this.images,
    required this.location,
    required this.timestamp,
    required this.comments,
    required this.likes,
  });
}

class Comment {
  final String id;
  final User user;
  final String content;
  final DateTime timestamp;
  
  const Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });
} 