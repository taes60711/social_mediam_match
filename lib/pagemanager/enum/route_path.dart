//Route路徑
enum RoutePath {
  home("/"),
  loginPage("/login"),
  signUpPage("/signUp"),

  profilePage("/profile"),
  postEditPage("/postEdit"),
  courseEditPage("/courseEdit"),
  skillChoicePage("/skillChoice"),
  myPosts("/myposts"),
  myCourses("/mycourses"),
  myFriends("/myFriends"),
  privacySettingPage("/privacySetting");

  final String value;
  const RoutePath(this.value);
}
