// dummy_data.dart

class DummyData {
  // Current user data
  static final Map<String, dynamic> currentUser = {
    'name': 'Alex Johnson',
    'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    'email': 'alex.johnson@example.com',
  };

  // Stories data (including create story as first item)
  static final List<Map<String, dynamic>> stories = [
    // Create story
    {
      'type': 'create',
      'userName': 'Create story',
      'userImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    },
    // Friend stories
    {
      'type': 'friend',
      'userName': 'Emma Wilson',
      'userImage': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400&h=600&fit=crop',
    },
    {
      'type': 'friend',
      'userName': 'Michael Chen',
      'userImage': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop',
    },
    {
      'type': 'friend',
      'userName': 'Sarah Davis',
      'userImage': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=600&fit=crop',
    },
    {
      'type': 'friend',
      'userName': 'James Rodriguez',
      'userImage': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=400&h=600&fit=crop',
    },
    {
      'type': 'friend',
      'userName': 'Lisa Park',
      'userImage': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&h=600&fit=crop',
    },
    {
      'type': 'friend',
      'userName': 'David Kim',
      'userImage': 'https://images.unsplash.com/photo-1507591064344-4c6ce005-128?w=400&h=400&fit=crop',
      'storyImage': 'https://images.unsplash.com/photo-1507591064344-4c6ce005-128?w=400&h=600&fit=crop',
    },
  ];

  // Posts data
  static final List<Map<String, dynamic>> posts = [
    {
      'userName': 'Mark Thompson',
      'userImage': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
      'time': '2 hrs',
      'content': 'Just bought my dream car! 🚗 After years of saving, finally got this beauty. Can\'t wait to take it on a road trip this weekend!',
      'postImage': 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '1.2K',
      'comments': '245',
      'shares': '45',
    },
    {
      'userName': 'Sophia Martinez',
      'userImage': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=400&fit=crop',
      'time': '4 hrs',
      'content': 'Beautiful sunset drive along the coast. The new car handles like a dream!',
      'postImage': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '3.4K',
      'comments': '489',
      'shares': '124',
    },
    {
      'userName': 'Robert Williams',
      'userImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
      'time': '6 hrs',
      'content': 'Finally finished restoring this classic beauty. It\'s been a 2-year project but totally worth it! What do you think?',
      'postImage': 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '2.8K',
      'comments': '367',
      'shares': '89',
    },
    {
      'userName': 'Jennifer Lee',
      'userImage': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop',
      'time': 'Yesterday',
      'content': 'First road trip with the new electric vehicle! 400 miles on a single charge and the autopilot made the drive so relaxing. The future is here!',
      'postImage': 'https://images.unsplash.com/photo-1553440569-bcc63803a83d?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '5.2K',
      'comments': '892',
      'shares': '256',
    },
    {
      'userName': 'Kevin Brown',
      'userImage': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop',
      'time': 'Yesterday',
      'content': 'Car meetup this weekend was amazing! So many beautiful machines. Here\'s my favorite shot from the event.',
      'postImage': 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '4.1K',
      'comments': '567',
      'shares': '134',
    },
    {
      'userName': 'Amanda Taylor',
      'userImage': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
      'time': '2 days ago',
      'content': 'Text-only post: Just booked my first track day experience! Any tips for a first-timer? I\'m so excited but also a bit nervous. What should I expect? Any recommended instructors or things to prepare for?',
      'postImage': null,
      'postImageFocus': null,
      'likes': '856',
      'comments': '189',
      'shares': '32',
    },
    {
      'userName': 'Thomas Anderson',
      'userImage': 'https://images.unsplash.com/photo-1507591064344-4c6ce005-128?w=400&h=400&fit=crop',
      'time': '2 days ago',
      'content': 'Detailed my car today. 6 hours of washing, claying, polishing, and waxing. The results speak for themselves!',
      'postImage': 'https://images.unsplash.com/photo-1514316454349-750a7fd3da3a?w=800&h=600&fit=crop',
      'postImageFocus': 'car',
      'likes': '2.3K',
      'comments': '267',
      'shares': '54',
    },
  ];

  // Add to dummy_data.dart (after the posts list)

// Friends data
static final List<Map<String, dynamic>> friends = [
  {
    'name': 'Emma Wilson',
    'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
    'mutualFriends': '12 mutual friends',
    'isOnline': true,
  },
  {
    'name': 'Michael Chen',
    'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
    'mutualFriends': '8 mutual friends',
    'isOnline': false,
  },
  {
    'name': 'Sarah Davis',
    'image': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=400&fit=crop',
    'mutualFriends': '25 mutual friends',
    'isOnline': true,
  },
  {
    'name': 'James Rodriguez',
    'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop',
    'mutualFriends': '5 mutual friends',
    'isOnline': true,
  },
  {
    'name': 'Lisa Park',
    'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop',
    'mutualFriends': '18 mutual friends',
    'isOnline': false,
  },
  {
    'name': 'David Kim',
    'image': 'https://images.unsplash.com/photo-1507591064344-4c6ce005-128?w=400&h=400&fit=crop',
    'mutualFriends': '3 mutual friends',
    'isOnline': false,
  },
  {
    'name': 'Sophia Martinez',
    'image': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=400&fit=crop',
    'mutualFriends': '15 mutual friends',
    'isOnline': true,
  },
  {
    'name': 'Robert Williams',
    'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop',
    'mutualFriends': '7 mutual friends',
    'isOnline': false,
  },
];

// Notifications data
static final List<Map<String, dynamic>> notifications = [
  {
    'type': 'friend_request',
    'title': 'Emma Wilson',
    'subtitle': 'sent you a friend request',
    'time': '2 min ago',
    'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
    'isUnread': true,
  },
  {
    'type': 'like',
    'title': 'Michael Chen',
    'subtitle': 'liked your photo',
    'time': '1 hour ago',
    'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop',
    'isUnread': true,
  },
  {
    'type': 'tag',
    'title': 'Sarah Davis',
    'subtitle': 'tagged you in a post',
    'time': '3 hours ago',
    'image': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400&h=400&fit=crop',
    'isUnread': true,
  },
  {
    'type': 'comment',
    'title': 'James Rodriguez',
    'subtitle': 'commented on your post: "Nice car!"',
    'time': '5 hours ago',
    'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop',
    'isUnread': false,
  },
  {
    'type': 'event',
    'title': 'Local Car Meet',
    'subtitle': 'starts in 2 days',
    'time': 'Yesterday',
    'image': 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=400&h=400&fit=crop',
    'isUnread': false,
  },
  {
    'type': 'birthday',
    'title': 'Lisa Park',
    'subtitle': 'has her birthday today',
    'time': 'Yesterday',
    'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop',
    'isUnread': false,
  },
  {
    'type': 'memory',
    'title': 'Memory',
    'subtitle': 'You have a memory from 2 years ago',
    'time': '2 days ago',
    'image': 'https://images.unsplash.com/photo-1514316454349-750a7fd3da3a?w=400&h=400&fit=crop',
    'isUnread': false,
  },
  {
    'type': 'group',
    'title': 'Car Enthusiasts',
    'subtitle': 'David Kim added you to the group',
    'time': '3 days ago',
    'image': 'https://images.unsplash.com/photo-1507591064344-4c6ce005-128?w=400&h=400&fit=crop',
    'isUnread': false,
  },
];

}