-- Customer 
create table Customer (
    CustomerId number(20) primary key,
    FirstName varchar2(100) not null,
    LastName varchar2(100) not null,
    BirthDate date,
    PasswordHash varchar2(255) not null,
    PasswordSalt varchar2(255) not null,
    IdentityTypeId number(3),
    Identitynumber varchar2(12),
    GenderId number(3),
    DefaultPhoneId number(20),
    EmailId number(20) not null unique,
    DefaultDeliveryAddressId number(20),
    IsAccountActive number(1) not null    
);


-- CustomerSession
create table CustomerSession (
    CustomerSessionId number(20) primary key,
    CustomerId number(20) unique,
    IsLogin number(1) not null    
);


-- IdentityType
create table IdentityType (
    IdentityTypeId number(3) primary key,
    TypeName varchar2(50) unique
);


-- GenderType
create table GenderType (
    GenderTypeId number(3) primary key,
    TypeName varchar2(50) unique
);


-- Email
create table Email (
    EmailId number(20) primary key,
    EmailAddress varchar2(255) unique
);


-- Phone
-- Uluslararasý telefon numarasýnýn tamamý için maksimum 15 haneli bir uzunluða izin verilir.
create table Phone (
    PhoneId number(20) primary key,
    PhoneNumber varchar2(20) unique
);


-- Country
-- Dünya üzerinde 195 ülke var
create table Country (
    CountryId number(4) primary key,
    CountryName varchar2(100) unique
);


-- City
-- Dünya üzerinde 2.459.501 þehir var
create table City (
    CityId number(8) primary key,
    CountryId number(4) not null,
    CityName varchar2(100) not null
);


-- District
-- Dünya üzerinde 517.452.005.654 þehir var
create table District (
    DistrictId number(13) primary key,
    CityId number(8) not null,
    DistrictName varchar2(100) not null
);


-- Address
create table Address (
    AddressId number(20) primary key,
    DistrictId number(13) not null,
    AddressDesciption varchar2(255) not null
);


-- DeliveryAddress
create table DeliveryAddress (
    DeliveryAddressId number(20) primary key,
    CustomerId number(20) not null,
    AddressId number(20) not null,
    PhoneId number(20) not null
);


-- Category
create table Category (
    CategoryId number(8) primary key,
    CategoryName varchar2(100) not null,
    ParentCategoryId number(8)
);

-- Brand
create table Brand (
    BrandId number(10) primary key,
    BrandName varchar2(100) not null
);


-- Product
create table Product (
    ProductId number(20) primary key,
    BrandId number(10) not null,
    ProductName varchar2(100) not null,
    ProductDescription varchar2(2000),
    Price number(11,2) not null,
    DiscountPercentage number(3) not null,
    FavCount number(20)
);

-- ProductImage
create table ProductImage (
    ProductImageId number(22) primary key,
    ProductId number(20) not null,
    Image BLOB not null
);

-- ProductCategory
create table ProductCategory (
    CategoryId number(8) not null,
    ProductId number(20) not null
);

-- CustomerProductFavorite
create table CustomerProductFavorite (
    CustomerId number(20) not null,
    ProductId number(20) not null,
    IsFavorite number(1) not null
);


-- Basket
create table Basket (
    BasketId number(20) primary key,
    CustomerId number(20) unique
);

-- BasketProduct
create table BasketProduct (
    BasketProductId number(20) primary key,
    BasketId number(20) not null,
    ProductId number(20) not null,
    ProductQuantity number(10) not null,
    IsSelected number(1) not null
);

-- OrderStatusType
create table OrderStatusType (
    OrderStatusTypeId number(2) primary key,
    TypeName varchar2(50) unique
);

-- Tax
create table Tax (
    TaxId number(3) primary key,
    TaxName varchar2(100) not null,
    TaxPercentage number(5) not null
);


-- CustomerOrderOrder
create table CustomerOrder (
    CustomerOrderId number(23) primary key,
    CustomerId number(20) not null,
    OrderNo varchar2(30) unique,
    OrderDate date not null,
    TotalPrice number(12,2) not null,
    OrderStatusTypeId number(2) not null,
    DeliveryAddressId number(20) not null
);


-- OrderDetail
create table OrderDetail (
    OrderDetailId number(25) primary key,
    CustomerOrderId number(23) not null,
    ProductId number(20) not null,
    Quantity number(10) not null,
    UnitPrice number(11,2) not null
);











