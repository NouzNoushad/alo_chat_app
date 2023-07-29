enum SignUpStatus { pending, successful, exists, failed }
enum LoginStatus { pending, successful, exists, noUser, wrongPass, failed }
enum CompleteProfileStatus { pending, successful, failed }
enum Status { success, failed }
enum ChatMenu { settings, logout }
enum ProfileType { complete, update }
enum ChatType { chat, status, search }
enum SearchType { chats, allChats }

const String nameKey = 'name';
const String emailKey = 'email';
const String uidKey = 'uid';

const String dbName = 'users';
const String chatRoomDbName = 'chatRooms';
const String messageDbName = 'messages';
const String statusDbName = 'status';

const String profileImage =
    'https://laneip.com/wp-content/uploads/2022/11/placeholder_pale.png';

List<String> countryCodes = [
  '+91',
  '+94',
  '+92',
  '+86',
  '+61',
  '+44',
  '+1',
  '+977',
  '+880',
  '+975'
];
