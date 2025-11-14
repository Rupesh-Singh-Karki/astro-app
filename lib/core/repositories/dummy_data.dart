import '../models/chat_message.dart';
import '../models/plan.dart';

class DummyData {
  static List<ChatMessage> initialMessages() {
    return [
      ChatMessage(
        id: '1',
        text: 'Hello, I am your virtual astrologer. How can I assist you today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        fromUser: false,
      ),
      ChatMessage(
        id: '2',
        text: 'I would like insights about my career path.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        fromUser: true,
      ),
      ChatMessage(
        id: '3',
        text: 'Certainly! Could you share your birth date and time?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        fromUser: false,
      ),
    ];
  }

  static List<Plan> plans() {
    return const [
      Plan(
        id: 'basic',
        name: 'Basic Guidance',
        description: 'Monthly general astrology overview and 3 chat questions.',
        pricePerMonth: 9.99,
        features: ['Monthly Overview', '3 Questions', 'Email Support'],
      ),
      Plan(
        id: 'plus',
        name: 'Plus Insights',
        description: 'Weekly personalized insights and 10 chat questions.',
        pricePerMonth: 19.99,
        features: ['Weekly Insights', '10 Questions', 'Priority Replies'],
      ),
      Plan(
        id: 'pro',
        name: 'Pro Vision',
        description: 'Daily guidance, unlimited questions, early AI features.',
        pricePerMonth: 39.99,
        features: ['Daily Guidance', 'Unlimited Questions', 'AI Early Access'],
      ),
    ];
  }
}
