import 'package:flutter/material.dart';
import '../screens/home/article_screen.dart';

/// Sample articles for featured content
final articles = {
  'birth_chart': Article(
    title: 'Understanding Your Birth Chart',
    subtitle:
        'Learn how to read and interpret your unique astrological blueprint',
    icon: Icons.auto_stories,
    introduction:
        'Your birth chart, also known as a natal chart, is like a snapshot of the sky at the exact moment you were born. It reveals the positions of the planets, sun, and moon in relation to the twelve zodiac signs and houses. This cosmic blueprint offers profound insights into your personality, strengths, challenges, and life path.',
    sections: [
      ArticleSection(
        heading: 'The Essential Components',
        icon: Icons.widgets,
        content:
            'A birth chart consists of three main components: the planets (representing different aspects of your personality), the zodiac signs (showing how those energies express themselves), and the houses (indicating which life areas are affected). The sun sign represents your core essence, the moon sign reflects your emotional nature, and the rising sign (ascendant) shows how you present yourself to the world.',
      ),
      ArticleSection(
        heading: 'Planetary Positions',
        icon: Icons.public,
        content:
            'Each planet in your chart governs specific aspects of life. The Sun represents your identity and ego, the Moon your emotions and instincts, Mercury your communication style, Venus your love and values, Mars your drive and ambition, Jupiter your growth and wisdom, Saturn your discipline and challenges, and the outer planets (Uranus, Neptune, Pluto) your generational influences and deep transformations.',
      ),
      ArticleSection(
        heading: 'The Twelve Houses',
        icon: Icons.home,
        content:
            'The houses divide your chart into twelve sections, each governing different life areas. The first house relates to self and identity, the second to money and values, the third to communication and siblings, the fourth to home and family, the fifth to creativity and romance, the sixth to health and work, the seventh to partnerships, the eighth to transformation and shared resources, the ninth to higher learning and travel, the tenth to career and public image, the eleventh to friendships and dreams, and the twelfth to spirituality and the subconscious.',
      ),
      ArticleSection(
        heading: 'Aspects and Angles',
        icon: Icons.transform,
        content:
            'Aspects are the geometric angles between planets that reveal how different parts of your personality interact. Conjunctions (0°) blend energies, oppositions (180°) create tension and awareness, trines (120°) bring harmony and ease, squares (90°) generate challenges and growth, and sextiles (60°) offer opportunities. Understanding these aspects helps you navigate life\'s patterns more consciously.',
      ),
    ],
    conclusion:
        'Reading your birth chart is a journey of self-discovery. While it may seem complex at first, each element works together to tell your unique story. Remember, astrology doesn\'t dictate your fate—it illuminates possibilities and helps you understand yourself better. Use your chart as a tool for growth, self-awareness, and making conscious choices aligned with your cosmic blueprint.',
  ),
  'planetary_transits': Article(
    title: 'Planetary Transits This Month',
    subtitle: 'Major astrological events and how they affect you',
    icon: Icons.public,
    introduction:
        'Planetary transits are the current movements of planets through the zodiac, creating dynamic energy patterns that influence our lives. Unlike your natal chart which is fixed, transits are constantly changing, bringing new opportunities, challenges, and themes. Understanding current transits helps you navigate life with greater awareness and timing.',
    sections: [
      ArticleSection(
        heading: 'What Are Transits?',
        icon: Icons.sync,
        content:
            'Transits occur when planets in the current sky form aspects to planets in your birth chart. These cosmic conversations activate specific areas of your chart, bringing certain themes to the forefront. Some transits are quick (like the Moon, lasting hours), while others unfold over years (like Pluto). The slower-moving outer planets (Jupiter, Saturn, Uranus, Neptune, Pluto) create the most significant and lasting impacts.',
      ),
      ArticleSection(
        heading: 'Key Transits This Month',
        icon: Icons.calendar_month,
        content:
            'This month features several important transits: Jupiter in Gemini expands communication and learning opportunities, Saturn in Pisces asks for spiritual discipline and boundary-setting, and Uranus in Taurus continues to shake up financial systems and values. Mars is energizing creative and romantic pursuits, while Venus enhances social connections and artistic expression. Mercury\'s position supports clear thinking and productive conversations.',
      ),
      ArticleSection(
        heading: 'Personal Impact',
        icon: Icons.person,
        content:
            'How these transits affect you personally depends on your birth chart. Look at which houses the transiting planets are moving through—these show which life areas are being activated. Also notice any aspects transiting planets make to your natal planets. For example, if transiting Jupiter trines your natal Sun, you may experience opportunities for growth and success. If transiting Saturn squares your natal Moon, you might face emotional challenges that ultimately strengthen you.',
      ),
      ArticleSection(
        heading: 'Working With Transits',
        icon: Icons.tips_and_updates,
        content:
            'The key to working with transits is awareness and timing. Beneficial transits (like Jupiter or Venus) are ideal times to initiate projects, make connections, and take action. Challenging transits (like Saturn or Pluto) are better for inner work, releasing old patterns, and building resilience. Rather than fighting cosmic currents, learn to surf them. Use transit energy consciously to align your actions with natural timing.',
      ),
      ArticleSection(
        heading: 'Retrogrades Explained',
        icon: Icons.replay,
        content:
            'Retrograde periods occur when planets appear to move backward from Earth\'s perspective. These aren\'t times of bad luck, but rather opportunities to review, revise, and reflect. Mercury retrograde affects communication and technology, Venus retrograde brings relationship reviews, and Mars retrograde slows down action and redirects energy. Use retrograde periods wisely for inner work rather than external launches.',
      ),
    ],
    conclusion:
        'Planetary transits are like cosmic weather patterns—constantly shifting and influencing the energetic atmosphere around us. By tracking significant transits and understanding their meaning, you can make more informed decisions, optimize your timing, and flow with rather than against universal rhythms. Remember, you always have free will in how you respond to planetary energies. Use transit awareness as a tool for empowerment, not limitation.',
  ),
};
