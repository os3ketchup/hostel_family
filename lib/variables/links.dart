class Links {
  static const String baseUrl = 'https://hotel.fvsudteb.uz/api/';
  static const String sendPhone = '/auth/register/phone';
  static const String sendVerify = '/auth/register/verify';
  static const String signUp = '/auth/register/sign-up';
  static const String update = '/profile-manager/profile/update-info';
  static const String getProfile = '/profile-manager/profile';
  static const String getDefinedNews = '/news/index';
  static const String getAllNews = '/news/all';
  static const String getNewsDetail = '/news/detail?id=';
  static const String getAllHostels = '/hotel/index';
  static const String getAllComment = '/comment/get-comment?hotelID=';
  static const String writeComment = '/comment/write-comment?hotelId=';
  static const String getRoom = '/room/index?hotelId=';
  static const String getRoomByFilter = '/room/filter-room?hotelId=';
  static const String order = '/order/create';
  // static const String getFavouriteHotel = '/favourite-hotel/index';
  static const String postFavouriteHotel = '/favourite-hotel/create?hotelId=';
  static const String contactAdmin = '/profile-manager/profile/write-message?hotelId=';
  static const String getAllOrder = '/order/get-all-order';
  static const String getUserAllComment = '/profile-manager/profile/get-comment';
  static const String getHotelByCategory = '/hotel-category/index';
  static const String repayment = '/order/repayment?orderId=';
  static const String getBarCode = '/order/get-barcode?orderId=';
  static const String upLoadImage = '/profile-manager/profile/update-image';
  static const String getAllNotification = '/notification/all';
  static const String getDefinedNotification = '/notification/detail?id=';
  static const String searchHotelByName = '/hotel/search?key=';
  static const String deleteAccount = '/profile-manager/profile/delete-account';


}