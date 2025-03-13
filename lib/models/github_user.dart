class GitHubUser {
  final String nickname;
  final int unit;
  final String image;
  final String userUrl;

  GitHubUser({
    required this.nickname,
    required this.unit,
    required this.image,
    required this.userUrl,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      nickname: json['login'] ?? '',
      unit: json['id'] ?? 0,
      image: json['avatar_url'] ?? '',
      userUrl: json['url'] ?? '',
    );
  }
}

class GitHubUserDetails {
  final String login;
  final int id;
  final String avatarUrl;
  final String name;
  final String? bio;
  final int publicRepos;
  final int followers;
  final int following;
  final String? location;
  final String? company;
  final String? blog;
  final String? email;
  final String htmlUrl;

  GitHubUserDetails({
    required this.login,
    required this.id,
    required this.avatarUrl,
    this.name = '',
    this.bio,
    this.publicRepos = 0,
    this.followers = 0,
    this.following = 0,
    this.location,
    this.company,
    this.blog,
    this.email,
    required this.htmlUrl,
  });

  factory GitHubUserDetails.fromJson(Map<String, dynamic> json) {
    return GitHubUserDetails(
      login: json['login'] ?? '',
      id: json['id'] ?? 0,
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      location: json['location'],
      company: json['company'],
      blog: json['blog'],
      email: json['email'],
      htmlUrl: json['html_url'] ?? '',
    );
  }
}
