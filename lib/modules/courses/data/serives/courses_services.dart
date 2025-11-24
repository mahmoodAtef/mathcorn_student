import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';

abstract class BaseCoursesServices {
  Future<List<Course>> getCourses({required String grade});
}

class CoursesServices extends BaseCoursesServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Course>> getCourses({required String grade}) async {
    // get user data from firebase
    var courses = await _firestore
        .collection('courses')
        .where('grade', isEqualTo: grade)
        .get();
    return courses.docs.map((doc) => Course.fromJson(doc.data())).toList();
  }
}

List<Course> dummyCourses = [
  Course(
    id: "004",
    name: "iOS App Development with Swift",
    description:
        "Build native iOS applications using Swift and Xcode. Learn UIKit, Core Data, networking, and publish your apps to the App Store. Perfect for beginners and intermediate developers.",
    oldPrice: 189,
    newPrice: 139,
    subscribers: 6789,
    image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=500",
    lectures: [
      Lecture(
        examId: "math_exam_001",
        id: "004-01",
        name: "Swift Programming Basics",
        url:
            "https://ekhafswfaydznddhfxmo.supabase.co/storage/v1/object/public/profile/Mahmoud_Atef.pdf",
        contentType: "pdf",
      ),
      Lecture(
        id: "004-02",
        name: "UIKit Interface Building",
        url: "https://www.youtube.com/watch?v=09TeUXjzpKs",
        contentType: "video",
        fileUrl:
            "https://ekhafswfaydznddhfxmo.supabase.co/storage/v1/object/public/profile/Mahmoud_Atef.pdf",
        examId: "math_exam_001",
      ),
      Lecture(
        id: "004-03",
        name: "Data Persistence with Core Data",
        url: "https://www.youtube.com/watch?v=O7u9nYWjvKk",
        contentType: "video",
      ),
      Lecture(
        id: "004-04",
        name: "App Store Publishing",
        url: "https://www.youtube.com/watch?v=tnbOcbDbft8",
        contentType: "video",
      ),
    ],
  ),

  Course(
    id: "006",
    name: "Financial Trading & Investment",
    description:
        "Learn stock market analysis, cryptocurrency trading, and investment strategies. Understand technical analysis, fundamental analysis, and risk management for successful trading.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 11234,
    image: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=500",
    lectures: [
      Lecture(
        id: "006-01",
        name: "Stock Market Basics",
        url: "https://www.youtube.com/watch?v=p7HKvqRI_Bo",
        contentType: "video",
      ),
      Lecture(
        id: "006-02",
        name: "Technical Analysis",
        url: "https://www.youtube.com/watch?v=08c4iwdGnWs",
        contentType: "video",
      ),
      Lecture(
        id: "006-03",
        name: "Cryptocurrency Trading",
        url: "https://www.youtube.com/watch?v=kHaJEqJDMKw",
        contentType: "video",
      ),
      Lecture(
        id: "006-04",
        name: "Risk Management Strategies",
        url: "https://www.youtube.com/watch?v=L6pCC6sicOY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "007",
    name: "Photography Masterclass",
    description:
        "Complete photography course covering camera basics, composition, lighting, post-processing, and various photography genres. Learn to capture stunning photos like a professional photographer.",
    oldPrice: 159,
    newPrice: 119,
    subscribers: 7543,
    image: "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=500",
    lectures: [
      Lecture(
        id: "007-01",
        name: "Camera Settings & Controls",
        url: "https://www.youtube.com/watch?v=3ly2Qhu8u5g",
        contentType: "video",
      ),
      Lecture(
        id: "007-02",
        name: "Composition Techniques",
        url: "https://www.youtube.com/watch?v=7ZVyNjKSr0M",
        contentType: "video",
      ),
      Lecture(
        id: "007-03",
        name: "Lighting Fundamentals",
        url: "https://www.youtube.com/watch?v=MEfJbD2C-10",
        contentType: "video",
      ),
      Lecture(
        id: "007-04",
        name: "Photo Editing with Lightroom",
        url: "https://www.youtube.com/watch?v=9Q4XzFgJE5M",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "008",
    name: "Amazon FBA Business Course",
    description:
        "Build a profitable Amazon FBA business from scratch. Learn product research, sourcing, listing optimization, PPC advertising, and scaling strategies for long-term success.",
    oldPrice: 299,
    newPrice: 199,
    subscribers: 5678,
    image: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500",
    lectures: [
      Lecture(
        id: "008-01",
        name: "Amazon FBA Overview",
        url: "https://www.youtube.com/watch?v=B3Z8xQYAr1s",
        contentType: "video",
      ),
      Lecture(
        id: "008-02",
        name: "Product Research Methods",
        url: "https://www.youtube.com/watch?v=VGz3-tDO4Jo",
        contentType: "video",
      ),
      Lecture(
        id: "008-03",
        name: "Supplier Sourcing",
        url: "https://www.youtube.com/watch?v=Fco8Qex5Rvc",
        contentType: "video",
      ),
      Lecture(
        id: "008-04",
        name: "Amazon PPC Advertising",
        url: "https://www.youtube.com/watch?v=CWnW4YmwUmY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "009",
    name: "UI/UX Design Complete Course",
    description:
        "Master user interface and user experience design. Learn design thinking, wireframing, prototyping, user research, and create beautiful, functional digital products using Figma and Adobe XD.",
    oldPrice: 169,
    newPrice: 119,
    subscribers: 13579,
    image: "https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500",
    lectures: [
      Lecture(
        id: "009-01",
        name: "UX Design Principles",
        url: "https://www.youtube.com/watch?v=Ovj4hFxko7c",
        contentType: "video",
      ),
      Lecture(
        id: "009-02",
        name: "Wireframing & Prototyping",
        url: "https://www.youtube.com/watch?v=KdfO_e0yK-g",
        contentType: "video",
      ),
      Lecture(
        id: "009-03",
        name: "Figma Design System",
        url: "https://www.youtube.com/watch?v=1pW_sk-2y40",
        contentType: "video",
      ),
      Lecture(
        id: "009-04",
        name: "User Testing Methods",
        url: "https://www.youtube.com/watch?v=BanqXKkgb5k",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "010",
    name: "Complete Excel Mastery",
    description:
        "From basic functions to advanced data analysis, pivot tables, VBA programming, and business intelligence. Become an Excel power user and boost your productivity in any profession.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 18756,
    image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500",
    lectures: [
      Lecture(
        id: "010-01",
        name: "Excel Fundamentals",
        url: "https://www.youtube.com/watch?v=rwbho0CgEAE",
        contentType: "video",
      ),
      Lecture(
        id: "010-02",
        name: "Advanced Formulas & Functions",
        url: "https://www.youtube.com/watch?v=Nd_FptUNyVw",
        contentType: "video",
      ),
      Lecture(
        id: "010-03",
        name: "Pivot Tables & Charts",
        url: "https://www.youtube.com/watch?v=qu-AK0Hv0b4",
        contentType: "video",
      ),
      Lecture(
        id: "010-04",
        name: "VBA Programming Basics",
        url: "https://www.youtube.com/watch?v=G05TrN7nt6k",
        contentType: "video",
      ),
    ],
  ),

  Course(
    id: "016",
    name: "Personal Finance & Wealth Building",
    description:
        "Master personal finance management, investment strategies, budgeting, debt elimination, retirement planning, and wealth-building techniques for financial independence.",
    oldPrice: 149,
    newPrice: 99,
    subscribers: 12987,
    image: "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500",
    lectures: [
      Lecture(
        id: "016-01",
        name: "Budgeting & Money Management",
        url: "https://www.youtube.com/watch?v=HQzoZfc3GwQ",
        contentType: "video",
      ),
      Lecture(
        id: "016-02",
        name: "Investment Strategies",
        url: "https://www.youtube.com/watch?v=gFQNPmLKj1k",
        contentType: "video",
      ),
      Lecture(
        id: "016-03",
        name: "Retirement Planning",
        url: "https://www.youtube.com/watch?v=TT0dTK7o19Q",
        contentType: "video",
      ),
      Lecture(
        id: "016-04",
        name: "Building Passive Income",
        url: "https://www.youtube.com/watch?v=UEl7XNFf93s",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "017",
    name: "Public Speaking & Presentation",
    description:
        "Overcome stage fright and become a confident public speaker. Learn presentation skills, storytelling techniques, body language, and how to engage any audience effectively.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 11456,
    image: "https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=500",
    lectures: [
      Lecture(
        id: "017-01",
        name: "Overcoming Speaking Anxiety",
        url: "https://www.youtube.com/watch?v=FEnb8hozp78",
        contentType: "video",
      ),
      Lecture(
        id: "017-02",
        name: "Presentation Structure",
        url: "https://www.youtube.com/watch?v=Iwpi1Lm6dFo",
        contentType: "video",
      ),
      Lecture(
        id: "017-03",
        name: "Body Language & Voice",
        url: "https://www.youtube.com/watch?v=vn6eSzHPyV8",
        contentType: "video",
      ),
      Lecture(
        id: "017-04",
        name: "Engaging Your Audience",
        url: "https://www.youtube.com/watch?v=8S0FDjFBj8o",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "018",
    name: "Game Development with Unity",
    description:
        "Create 2D and 3D games using Unity game engine. Learn C# programming, game physics, animation, UI design, and publish games to multiple platforms.",
    oldPrice: 189,
    newPrice: 139,
    subscribers: 7234,
    image: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=500",
    lectures: [
      Lecture(
        id: "018-01",
        name: "Unity Interface & Basics",
        url: "https://www.youtube.com/watch?v=gB1F9G0JXOo",
        contentType: "video",
      ),
      Lecture(
        id: "018-02",
        name: "C# for Unity",
        url: "https://www.youtube.com/watch?v=pSiIHe2uZ2w",
        contentType: "video",
      ),
      Lecture(
        id: "018-03",
        name: "2D Game Development",
        url: "https://www.youtube.com/watch?v=E7gmylDS1C4",
        contentType: "video",
      ),
      Lecture(
        id: "018-04",
        name: "3D Game Mechanics",
        url: "https://www.youtube.com/watch?v=44Mm5RGLF7w",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "019",
    name: "Real Estate Investment",
    description:
        "Learn real estate investing strategies including rental properties, fix-and-flip, wholesaling, REITs, and commercial real estate for building long-term wealth.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 9876,
    image: "https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?w=500",
    lectures: [
      Lecture(
        id: "019-01",
        name: "Real Estate Investment Basics",
        url: "https://www.youtube.com/watch?v=7wHqRFWpons",
        contentType: "video",
      ),
      Lecture(
        id: "019-02",
        name: "Rental Property Analysis",
        url: "https://www.youtube.com/watch?v=ygwSRo9Gm7o",
        contentType: "video",
      ),
      Lecture(
        id: "019-03",
        name: "Fix and Flip Strategies",
        url: "https://www.youtube.com/watch?v=0XA3bm8sAA0",
        contentType: "video",
      ),
      Lecture(
        id: "019-04",
        name: "Commercial Real Estate",
        url: "https://www.youtube.com/watch?v=zumJJUe1_4M",
        contentType: "video",
      ),
    ],
  ),

  Course(
    id: "006",
    name: "Financial Trading & Investment",
    description:
        "Learn stock market analysis, cryptocurrency trading, and investment strategies. Understand technical analysis, fundamental analysis, and risk management for successful trading.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 11234,
    image: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=500",
    lectures: [
      Lecture(
        id: "006-01",
        name: "Stock Market Basics",
        url: "https://www.youtube.com/watch?v=p7HKvqRI_Bo",
        contentType: "video",
      ),
      Lecture(
        id: "006-02",
        name: "Technical Analysis",
        url: "https://www.youtube.com/watch?v=08c4iwdGnWs",
        contentType: "video",
      ),
      Lecture(
        id: "006-03",
        name: "Cryptocurrency Trading",
        url: "https://www.youtube.com/watch?v=kHaJEqJDMKw",
        contentType: "video",
      ),
      Lecture(
        id: "006-04",
        name: "Risk Management Strategies",
        url: "https://www.youtube.com/watch?v=L6pCC6sicOY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "007",
    name: "Photography Masterclass",
    description:
        "Complete photography course covering camera basics, composition, lighting, post-processing, and various photography genres. Learn to capture stunning photos like a professional photographer.",
    oldPrice: 159,
    newPrice: 119,
    subscribers: 7543,
    image: "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=500",
    lectures: [
      Lecture(
        id: "007-01",
        name: "Camera Settings & Controls",
        url: "https://www.youtube.com/watch?v=3ly2Qhu8u5g",
        contentType: "video",
      ),
      Lecture(
        id: "007-02",
        name: "Composition Techniques",
        url: "https://www.youtube.com/watch?v=7ZVyNjKSr0M",
        contentType: "video",
      ),
      Lecture(
        id: "007-03",
        name: "Lighting Fundamentals",
        url: "https://www.youtube.com/watch?v=MEfJbD2C-10",
        contentType: "video",
      ),
      Lecture(
        id: "007-04",
        name: "Photo Editing with Lightroom",
        url: "https://www.youtube.com/watch?v=9Q4XzFgJE5M",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "008",
    name: "Amazon FBA Business Course",
    description:
        "Build a profitable Amazon FBA business from scratch. Learn product research, sourcing, listing optimization, PPC advertising, and scaling strategies for long-term success.",
    oldPrice: 299,
    newPrice: 199,
    subscribers: 5678,
    image: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500",
    lectures: [
      Lecture(
        id: "008-01",
        name: "Amazon FBA Overview",
        url: "https://www.youtube.com/watch?v=B3Z8xQYAr1s",
        contentType: "video",
      ),
      Lecture(
        id: "008-02",
        name: "Product Research Methods",
        url: "https://www.youtube.com/watch?v=VGz3-tDO4Jo",
        contentType: "video",
      ),
      Lecture(
        id: "008-03",
        name: "Supplier Sourcing",
        url: "https://www.youtube.com/watch?v=Fco8Qex5Rvc",
        contentType: "video",
      ),
      Lecture(
        id: "008-04",
        name: "Amazon PPC Advertising",
        url: "https://www.youtube.com/watch?v=CWnW4YmwUmY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "009",
    name: "UI/UX Design Complete Course",
    description:
        "Master user interface and user experience design. Learn design thinking, wireframing, prototyping, user research, and create beautiful, functional digital products using Figma and Adobe XD.",
    oldPrice: 169,
    newPrice: 119,
    subscribers: 13579,
    image: "https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500",
    lectures: [
      Lecture(
        id: "009-01",
        name: "UX Design Principles",
        url: "https://www.youtube.com/watch?v=Ovj4hFxko7c",
        contentType: "video",
      ),
      Lecture(
        id: "009-02",
        name: "Wireframing & Prototyping",
        url: "https://www.youtube.com/watch?v=KdfO_e0yK-g",
        contentType: "video",
      ),
      Lecture(
        id: "009-03",
        name: "Figma Design System",
        url: "https://www.youtube.com/watch?v=1pW_sk-2y40",
        contentType: "video",
      ),
      Lecture(
        id: "009-04",
        name: "User Testing Methods",
        url: "https://www.youtube.com/watch?v=BanqXKkgb5k",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "010",
    name: "Complete Excel Mastery",
    description:
        "From basic functions to advanced data analysis, pivot tables, VBA programming, and business intelligence. Become an Excel power user and boost your productivity in any profession.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 18756,
    image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500",
    lectures: [
      Lecture(
        id: "010-01",
        name: "Excel Fundamentals",
        url: "https://www.youtube.com/watch?v=rwbho0CgEAE",
        contentType: "video",
      ),
      Lecture(
        id: "010-02",
        name: "Advanced Formulas & Functions",
        url: "https://www.youtube.com/watch?v=Nd_FptUNyVw",
        contentType: "video",
      ),
      Lecture(
        id: "010-03",
        name: "Pivot Tables & Charts",
        url: "https://www.youtube.com/watch?v=qu-AK0Hv0b4",
        contentType: "video",
      ),
      Lecture(
        id: "010-04",
        name: "VBA Programming Basics",
        url: "https://www.youtube.com/watch?v=G05TrN7nt6k",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "011",
    name: "Android App Development",
    description:
        "Build Android applications using Java and Kotlin. Learn Android Studio, UI design, database integration, API consumption, and publish apps to Google Play Store.",
    oldPrice: 179,
    newPrice: 129,
    subscribers: 9432,
    image: "https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?w=500",
    lectures: [
      Lecture(
        id: "011-01",
        name: "Android Studio Setup",
        url: "https://www.youtube.com/watch?v=4M0hNugPJV8",
        contentType: "video",
      ),
      Lecture(
        id: "011-02",
        name: "Kotlin Programming",
        url: "https://www.youtube.com/watch?v=F9UC9DY-vIU",
        contentType: "video",
      ),
      Lecture(
        id: "011-03",
        name: "Android UI Components",
        url: "https://www.youtube.com/watch?v=EOfCEhWq8sg",
        contentType: "video",
      ),
      Lecture(
        id: "011-04",
        name: "Database & API Integration",
        url: "https://www.youtube.com/watch?v=ZVznzY-aKCk",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "012",
    name: "YouTube Creator Bootcamp",
    description:
        "Learn to create, edit, and grow a successful YouTube channel. Master video production, SEO, thumbnails, analytics, and monetization strategies to build your online presence.",
    oldPrice: 139,
    newPrice: 99,
    subscribers: 14321,
    image: "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=500",
    lectures: [
      Lecture(
        id: "012-01",
        name: "YouTube Channel Setup",
        url: "https://www.youtube.com/watch?v=9YnWp1NmVws",
        contentType: "video",
      ),
      Lecture(
        id: "012-02",
        name: "Video Production Basics",
        url: "https://www.youtube.com/watch?v=0_T3DMVC07k",
        contentType: "video",
      ),
      Lecture(
        id: "012-03",
        name: "YouTube SEO & Analytics",
        url: "https://www.youtube.com/watch?v=kRb-_hRhNSU",
        contentType: "video",
      ),
      Lecture(
        id: "012-04",
        name: "Monetization Strategies",
        url: "https://www.youtube.com/watch?v=2cKFaR5Jqgk",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "013",
    name: "Cybersecurity Fundamentals",
    description:
        "Essential cybersecurity concepts for protecting digital assets. Learn about network security, ethical hacking, risk assessment, incident response, and security best practices.",
    oldPrice: 199,
    newPrice: 149,
    subscribers: 6543,
    image: "https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=500",
    lectures: [
      Lecture(
        id: "013-01",
        name: "Security Fundamentals",
        url: "https://www.youtube.com/watch?v=U_P23SqJaDc",
        contentType: "video",
      ),
      Lecture(
        id: "013-02",
        name: "Network Security",
        url: "https://www.youtube.com/watch?v=kBzbKUirOFk",
        contentType: "video",
      ),
      Lecture(
        id: "013-03",
        name: "Ethical Hacking Basics",
        url: "https://www.youtube.com/watch?v=3Kq1MIfTWCE",
        contentType: "video",
      ),
      Lecture(
        id: "013-04",
        name: "Incident Response",
        url: "https://www.youtube.com/watch?v=JMVQFERP1jM",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "014",
    name: "Spanish Language Mastery",
    description:
        "Complete Spanish language course from beginner to advanced level. Learn grammar, vocabulary, pronunciation, and conversation skills through interactive lessons and cultural insights.",
    oldPrice: 119,
    newPrice: 79,
    subscribers: 16789,
    image: "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=500",
    lectures: [
      Lecture(
        id: "014-01",
        name: "Spanish Basics & Pronunciation",
        url: "https://www.youtube.com/watch?v=DAp_v7EH9AA",
        contentType: "video",
      ),
      Lecture(
        id: "014-02",
        name: "Essential Grammar",
        url: "https://www.youtube.com/watch?v=4E7K-A8wU_0",
        contentType: "video",
      ),
      Lecture(
        id: "014-03",
        name: "Conversation Practice",
        url: "https://www.youtube.com/watch?v=FnOp5xl3lcc",
        contentType: "video",
      ),
      Lecture(
        id: "014-04",
        name: "Spanish Culture & Context",
        url: "https://www.youtube.com/watch?v=iXQFT2Ot5FE",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "015",
    name: "Blockchain & Cryptocurrency",
    description:
        "Understand blockchain technology, cryptocurrency trading, DeFi, NFTs, and smart contract development. Learn about Bitcoin, Ethereum, and emerging blockchain applications.",
    oldPrice: 229,
    newPrice: 169,
    subscribers: 8765,
    image: "https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=500",
    lectures: [
      Lecture(
        id: "015-01",
        name: "Blockchain Fundamentals",
        url: "https://www.youtube.com/watch?v=SSo_EIwHSd4",
        contentType: "video",
      ),
      Lecture(
        id: "015-02",
        name: "Cryptocurrency Basics",
        url: "https://www.youtube.com/watch?v=VYWc9dFqROI",
        contentType: "video",
      ),
      Lecture(
        id: "015-03",
        name: "Smart Contracts",
        url: "https://www.youtube.com/watch?v=ZE2HxTmxfrI",
        contentType: "video",
      ),
      Lecture(
        id: "015-04",
        name: "DeFi & NFTs",
        url: "https://www.youtube.com/watch?v=btB__oHQ0sU",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "016",
    name: "Personal Finance & Wealth Building",
    description:
        "Master personal finance management, investment strategies, budgeting, debt elimination, retirement planning, and wealth-building techniques for financial independence.",
    oldPrice: 149,
    newPrice: 99,
    subscribers: 12987,
    image: "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500",
    lectures: [
      Lecture(
        id: "016-01",
        name: "Budgeting & Money Management",
        url: "https://www.youtube.com/watch?v=HQzoZfc3GwQ",
        contentType: "video",
      ),
      Lecture(
        id: "016-02",
        name: "Investment Strategies",
        url: "https://www.youtube.com/watch?v=gFQNPmLKj1k",
        contentType: "video",
      ),
      Lecture(
        id: "016-03",
        name: "Retirement Planning",
        url: "https://www.youtube.com/watch?v=TT0dTK7o19Q",
        contentType: "video",
      ),
      Lecture(
        id: "016-04",
        name: "Building Passive Income",
        url: "https://www.youtube.com/watch?v=UEl7XNFf93s",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "017",
    name: "Public Speaking & Presentation",
    description:
        "Overcome stage fright and become a confident public speaker. Learn presentation skills, storytelling techniques, body language, and how to engage any audience effectively.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 11456,
    image: "https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=500",
    lectures: [
      Lecture(
        id: "017-01",
        name: "Overcoming Speaking Anxiety",
        url: "https://www.youtube.com/watch?v=FEnb8hozp78",
        contentType: "video",
      ),
      Lecture(
        id: "017-02",
        name: "Presentation Structure",
        url: "https://www.youtube.com/watch?v=Iwpi1Lm6dFo",
        contentType: "video",
      ),
      Lecture(
        id: "017-03",
        name: "Body Language & Voice",
        url: "https://www.youtube.com/watch?v=vn6eSzHPyV8",
        contentType: "video",
      ),
      Lecture(
        id: "017-04",
        name: "Engaging Your Audience",
        url: "https://www.youtube.com/watch?v=8S0FDjFBj8o",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "018",
    name: "Game Development with Unity",
    description:
        "Create 2D and 3D games using Unity game engine. Learn C# programming, game physics, animation, UI design, and publish games to multiple platforms.",
    oldPrice: 189,
    newPrice: 139,
    subscribers: 7234,
    image: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=500",
    lectures: [
      Lecture(
        id: "018-01",
        name: "Unity Interface & Basics",
        url: "https://www.youtube.com/watch?v=gB1F9G0JXOo",
        contentType: "video",
      ),
      Lecture(
        id: "018-02",
        name: "C# for Unity",
        url: "https://www.youtube.com/watch?v=pSiIHe2uZ2w",
        contentType: "video",
      ),
      Lecture(
        id: "018-03",
        name: "2D Game Development",
        url: "https://www.youtube.com/watch?v=E7gmylDS1C4",
        contentType: "video",
      ),
      Lecture(
        id: "018-04",
        name: "3D Game Mechanics",
        url: "https://www.youtube.com/watch?v=44Mm5RGLF7w",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "019",
    name: "Real Estate Investment",
    description:
        "Learn real estate investing strategies including rental properties, fix-and-flip, wholesaling, REITs, and commercial real estate for building long-term wealth.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 9876,
    image: "https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?w=500",
    lectures: [
      Lecture(
        id: "019-01",
        name: "Real Estate Investment Basics",
        url: "https://www.youtube.com/watch?v=7wHqRFWpons",
        contentType: "video",
      ),
      Lecture(
        id: "019-02",
        name: "Rental Property Analysis",
        url: "https://www.youtube.com/watch?v=ygwSRo9Gm7o",
        contentType: "video",
      ),
      Lecture(
        id: "019-03",
        name: "Fix and Flip Strategies",
        url: "https://www.youtube.com/watch?v=0XA3bm8sAA0",
        contentType: "video",
      ),
      Lecture(
        id: "019-04",
        name: "Commercial Real Estate",
        url: "https://www.youtube.com/watch?v=zumJJUe1_4M",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "020",
    name: "Artificial Intelligence & Machine Learning",
    description:
        "Introduction to AI and ML concepts, algorithms, neural networks, deep learning, and practical applications using Python, TensorFlow, and scikit-learn.",
    oldPrice: 299,
    newPrice: 219,
    subscribers: 6789,
    image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=500",
    lectures: [
      Lecture(
        id: "020-01",
        name: "AI & ML Fundamentals",
        url: "https://www.youtube.com/watch?v=ad79nYk2keg",
        contentType: "video",
      ),
      Lecture(
        id: "020-02",
        name: "Machine Learning Algorithms",
        url: "https://www.youtube.com/watch?v=ukzFI9rgwfU",
        contentType: "video",
      ),
      Lecture(
        id: "020-03",
        name: "Neural Networks",
        url: "https://www.youtube.com/watch?v=aircAruvnKk",
        contentType: "video",
      ),
      Lecture(
        id: "020-04",
        name: "Deep Learning with TensorFlow",
        url: "https://www.youtube.com/watch?v=tPYj3fFJGjk",
        contentType: "video",
      ),
    ],
  ),

  Course(
    id: "006",
    name: "Financial Trading & Investment",
    description:
        "Learn stock market analysis, cryptocurrency trading, and investment strategies. Understand technical analysis, fundamental analysis, and risk management for successful trading.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 11234,
    image: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=500",
    lectures: [
      Lecture(
        id: "006-01",
        name: "Stock Market Basics",
        url: "https://www.youtube.com/watch?v=p7HKvqRI_Bo",
        contentType: "video",
      ),
      Lecture(
        id: "006-02",
        name: "Technical Analysis",
        url: "https://www.youtube.com/watch?v=08c4iwdGnWs",
        contentType: "video",
      ),
      Lecture(
        id: "006-03",
        name: "Cryptocurrency Trading",
        url: "https://www.youtube.com/watch?v=kHaJEqJDMKw",
        contentType: "video",
      ),
      Lecture(
        id: "006-04",
        name: "Risk Management Strategies",
        url: "https://www.youtube.com/watch?v=L6pCC6sicOY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "007",
    name: "Photography Masterclass",
    description:
        "Complete photography course covering camera basics, composition, lighting, post-processing, and various photography genres. Learn to capture stunning photos like a professional photographer.",
    oldPrice: 159,
    newPrice: 119,
    subscribers: 7543,
    image: "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=500",
    lectures: [
      Lecture(
        id: "007-01",
        name: "Camera Settings & Controls",
        url: "https://www.youtube.com/watch?v=3ly2Qhu8u5g",
        contentType: "video",
      ),
      Lecture(
        id: "007-02",
        name: "Composition Techniques",
        url: "https://www.youtube.com/watch?v=7ZVyNjKSr0M",
        contentType: "video",
      ),
      Lecture(
        id: "007-03",
        name: "Lighting Fundamentals",
        url: "https://www.youtube.com/watch?v=MEfJbD2C-10",
        contentType: "video",
      ),
      Lecture(
        id: "007-04",
        name: "Photo Editing with Lightroom",
        url: "https://www.youtube.com/watch?v=9Q4XzFgJE5M",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "008",
    name: "Amazon FBA Business Course",
    description:
        "Build a profitable Amazon FBA business from scratch. Learn product research, sourcing, listing optimization, PPC advertising, and scaling strategies for long-term success.",
    oldPrice: 299,
    newPrice: 199,
    subscribers: 5678,
    image: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500",
    lectures: [
      Lecture(
        id: "008-01",
        name: "Amazon FBA Overview",
        url: "https://www.youtube.com/watch?v=B3Z8xQYAr1s",
        contentType: "video",
      ),
      Lecture(
        id: "008-02",
        name: "Product Research Methods",
        url: "https://www.youtube.com/watch?v=VGz3-tDO4Jo",
        contentType: "video",
      ),
      Lecture(
        id: "008-03",
        name: "Supplier Sourcing",
        url: "https://www.youtube.com/watch?v=Fco8Qex5Rvc",
        contentType: "video",
      ),
      Lecture(
        id: "008-04",
        name: "Amazon PPC Advertising",
        url: "https://www.youtube.com/watch?v=CWnW4YmwUmY",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "009",
    name: "UI/UX Design Complete Course",
    description:
        "Master user interface and user experience design. Learn design thinking, wireframing, prototyping, user research, and create beautiful, functional digital products using Figma and Adobe XD.",
    oldPrice: 169,
    newPrice: 119,
    subscribers: 13579,
    image: "https://images.unsplash.com/photo-1561070791-2526d30994b5?w=500",
    lectures: [
      Lecture(
        id: "009-01",
        name: "UX Design Principles",
        url: "https://www.youtube.com/watch?v=Ovj4hFxko7c",
        contentType: "video",
      ),
      Lecture(
        id: "009-02",
        name: "Wireframing & Prototyping",
        url: "https://www.youtube.com/watch?v=KdfO_e0yK-g",
        contentType: "video",
      ),
      Lecture(
        id: "009-03",
        name: "Figma Design System",
        url: "https://www.youtube.com/watch?v=1pW_sk-2y40",
        contentType: "video",
      ),
      Lecture(
        id: "009-04",
        name: "User Testing Methods",
        url: "https://www.youtube.com/watch?v=BanqXKkgb5k",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "010",
    name: "Complete Excel Mastery",
    description:
        "From basic functions to advanced data analysis, pivot tables, VBA programming, and business intelligence. Become an Excel power user and boost your productivity in any profession.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 18756,
    image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500",
    lectures: [
      Lecture(
        id: "010-01",
        name: "Excel Fundamentals",
        url: "https://www.youtube.com/watch?v=rwbho0CgEAE",
        contentType: "video",
      ),
      Lecture(
        id: "010-02",
        name: "Advanced Formulas & Functions",
        url: "https://www.youtube.com/watch?v=Nd_FptUNyVw",
        contentType: "video",
      ),
      Lecture(
        id: "010-03",
        name: "Pivot Tables & Charts",
        url: "https://www.youtube.com/watch?v=qu-AK0Hv0b4",
        contentType: "video",
      ),
      Lecture(
        id: "010-04",
        name: "VBA Programming Basics",
        url: "https://www.youtube.com/watch?v=G05TrN7nt6k",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "011",
    name: "Android App Development",
    description:
        "Build Android applications using Java and Kotlin. Learn Android Studio, UI design, database integration, API consumption, and publish apps to Google Play Store.",
    oldPrice: 179,
    newPrice: 129,
    subscribers: 9432,
    image: "https://images.unsplash.com/photo-1607252650355-f7fd0460ccdb?w=500",
    lectures: [
      Lecture(
        id: "011-01",
        name: "Android Studio Setup",
        url: "https://www.youtube.com/watch?v=4M0hNugPJV8",
        contentType: "video",
      ),
      Lecture(
        id: "011-02",
        name: "Kotlin Programming",
        url: "https://www.youtube.com/watch?v=F9UC9DY-vIU",
        contentType: "video",
      ),
      Lecture(
        id: "011-03",
        name: "Android UI Components",
        url: "https://www.youtube.com/watch?v=EOfCEhWq8sg",
        contentType: "video",
      ),
      Lecture(
        id: "011-04",
        name: "Database & API Integration",
        url: "https://www.youtube.com/watch?v=ZVznzY-aKCk",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "012",
    name: "YouTube Creator Bootcamp",
    description:
        "Learn to create, edit, and grow a successful YouTube channel. Master video production, SEO, thumbnails, analytics, and monetization strategies to build your online presence.",
    oldPrice: 139,
    newPrice: 99,
    subscribers: 14321,
    image: "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=500",
    lectures: [
      Lecture(
        id: "012-01",
        name: "YouTube Channel Setup",
        url: "https://www.youtube.com/watch?v=9YnWp1NmVws",
        contentType: "video",
      ),
      Lecture(
        id: "012-02",
        name: "Video Production Basics",
        url: "https://www.youtube.com/watch?v=0_T3DMVC07k",
        contentType: "video",
      ),
      Lecture(
        id: "012-03",
        name: "YouTube SEO & Analytics",
        url: "https://www.youtube.com/watch?v=kRb-_hRhNSU",
        contentType: "video",
      ),
      Lecture(
        id: "012-04",
        name: "Monetization Strategies",
        url: "https://www.youtube.com/watch?v=2cKFaR5Jqgk",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "013",
    name: "Cybersecurity Fundamentals",
    description:
        "Essential cybersecurity concepts for protecting digital assets. Learn about network security, ethical hacking, risk assessment, incident response, and security best practices.",
    oldPrice: 199,
    newPrice: 149,
    subscribers: 6543,
    image: "https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=500",
    lectures: [
      Lecture(
        id: "013-01",
        name: "Security Fundamentals",
        url: "https://www.youtube.com/watch?v=U_P23SqJaDc",
        contentType: "video",
      ),
      Lecture(
        id: "013-02",
        name: "Network Security",
        url: "https://www.youtube.com/watch?v=kBzbKUirOFk",
        contentType: "video",
      ),
      Lecture(
        id: "013-03",
        name: "Ethical Hacking Basics",
        url: "https://www.youtube.com/watch?v=3Kq1MIfTWCE",
        contentType: "video",
      ),
      Lecture(
        id: "013-04",
        name: "Incident Response",
        url: "https://www.youtube.com/watch?v=JMVQFERP1jM",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "014",
    name: "Spanish Language Mastery",
    description:
        "Complete Spanish language course from beginner to advanced level. Learn grammar, vocabulary, pronunciation, and conversation skills through interactive lessons and cultural insights.",
    oldPrice: 119,
    newPrice: 79,
    subscribers: 16789,
    image: "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=500",
    lectures: [
      Lecture(
        id: "014-01",
        name: "Spanish Basics & Pronunciation",
        url: "https://www.youtube.com/watch?v=DAp_v7EH9AA",
        contentType: "video",
      ),
      Lecture(
        id: "014-02",
        name: "Essential Grammar",
        url: "https://www.youtube.com/watch?v=4E7K-A8wU_0",
        contentType: "video",
      ),
      Lecture(
        id: "014-03",
        name: "Conversation Practice",
        url: "https://www.youtube.com/watch?v=FnOp5xl3lcc",
        contentType: "video",
      ),
      Lecture(
        id: "014-04",
        name: "Spanish Culture & Context",
        url: "https://www.youtube.com/watch?v=iXQFT2Ot5FE",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "015",
    name: "Blockchain & Cryptocurrency",
    description:
        "Understand blockchain technology, cryptocurrency trading, DeFi, NFTs, and smart contract development. Learn about Bitcoin, Ethereum, and emerging blockchain applications.",
    oldPrice: 229,
    newPrice: 169,
    subscribers: 8765,
    image: "https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=500",
    lectures: [
      Lecture(
        id: "015-01",
        name: "Blockchain Fundamentals",
        url: "https://www.youtube.com/watch?v=SSo_EIwHSd4",
        contentType: "video",
      ),
      Lecture(
        id: "015-02",
        name: "Cryptocurrency Basics",
        url: "https://www.youtube.com/watch?v=VYWc9dFqROI",
        contentType: "video",
      ),
      Lecture(
        id: "015-03",
        name: "Smart Contracts",
        url: "https://www.youtube.com/watch?v=ZE2HxTmxfrI",
        contentType: "video",
      ),
      Lecture(
        id: "015-04",
        name: "DeFi & NFTs",
        url: "https://www.youtube.com/watch?v=btB__oHQ0sU",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "016",
    name: "Personal Finance & Wealth Building",
    description:
        "Master personal finance management, investment strategies, budgeting, debt elimination, retirement planning, and wealth-building techniques for financial independence.",
    oldPrice: 149,
    newPrice: 99,
    subscribers: 12987,
    image: "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=500",
    lectures: [
      Lecture(
        id: "016-01",
        name: "Budgeting & Money Management",
        url: "https://www.youtube.com/watch?v=HQzoZfc3GwQ",
        contentType: "video",
      ),
      Lecture(
        id: "016-02",
        name: "Investment Strategies",
        url: "https://www.youtube.com/watch?v=gFQNPmLKj1k",
        contentType: "video",
      ),
      Lecture(
        id: "016-03",
        name: "Retirement Planning",
        url: "https://www.youtube.com/watch?v=TT0dTK7o19Q",
        contentType: "video",
      ),
      Lecture(
        id: "016-04",
        name: "Building Passive Income",
        url: "https://www.youtube.com/watch?v=UEl7XNFf93s",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "017",
    name: "Public Speaking & Presentation",
    description:
        "Overcome stage fright and become a confident public speaker. Learn presentation skills, storytelling techniques, body language, and how to engage any audience effectively.",
    oldPrice: 99,
    newPrice: 69,
    subscribers: 11456,
    image: "https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=500",
    lectures: [
      Lecture(
        id: "017-01",
        name: "Overcoming Speaking Anxiety",
        url: "https://www.youtube.com/watch?v=FEnb8hozp78",
        contentType: "video",
      ),
      Lecture(
        id: "017-02",
        name: "Presentation Structure",
        url: "https://www.youtube.com/watch?v=Iwpi1Lm6dFo",
        contentType: "video",
      ),
      Lecture(
        id: "017-03",
        name: "Body Language & Voice",
        url: "https://www.youtube.com/watch?v=vn6eSzHPyV8",
        contentType: "video",
      ),
      Lecture(
        id: "017-04",
        name: "Engaging Your Audience",
        url: "https://www.youtube.com/watch?v=8S0FDjFBj8o",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "018",
    name: "Game Development with Unity",
    description:
        "Create 2D and 3D games using Unity game engine. Learn C# programming, game physics, animation, UI design, and publish games to multiple platforms.",
    oldPrice: 189,
    newPrice: 139,
    subscribers: 7234,
    image: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=500",
    lectures: [
      Lecture(
        id: "018-01",
        name: "Unity Interface & Basics",
        url: "https://www.youtube.com/watch?v=gB1F9G0JXOo",
        contentType: "video",
      ),
      Lecture(
        id: "018-02",
        name: "C# for Unity",
        url: "https://www.youtube.com/watch?v=pSiIHe2uZ2w",
        contentType: "video",
      ),
      Lecture(
        id: "018-03",
        name: "2D Game Development",
        url: "https://www.youtube.com/watch?v=E7gmylDS1C4",
        contentType: "video",
      ),
      Lecture(
        id: "018-04",
        name: "3D Game Mechanics",
        url: "https://www.youtube.com/watch?v=44Mm5RGLF7w",
        contentType: "video",
      ),
    ],
  ),
  Course(
    id: "019",
    name: "Real Estate Investment",
    description:
        "Learn real estate investing strategies including rental properties, fix-and-flip, wholesaling, REITs, and commercial real estate for building long-term wealth.",
    oldPrice: 249,
    newPrice: 179,
    subscribers: 9876,
    image: "https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?w=500",
    lectures: [
      Lecture(
        id: "019-01",
        name: "Real Estate Investment Basics",
        url: "https://www.youtube.com/watch?v=7wHqRFWpons",
        contentType: "video",
      ),
      Lecture(
        id: "019-02",
        name: "Rental Property Analysis",
        url: "https://www.youtube.com/watch?v=ygwSRo9Gm7o",
        contentType: "video",
      ),
      Lecture(
        id: "019-03",
        name: "Fix and Flip Strategies",
        url: "https://www.youtube.com/watch?v=0XA3bm8sAA0",
        contentType: "video",
      ),
      Lecture(
        id: "019-04",
        name: "Commercial Real Estate",
        url: "https://www.youtube.com/watch?v=zumJJUe1_4M",
        contentType: "video",
      ),
    ],
  ),
];
