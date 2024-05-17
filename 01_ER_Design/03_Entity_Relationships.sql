-- Customer Relationship

alter table Customer
add constraint FK_IdentityType 
foreign key (IdentityTypeId)
references IdentityType(IdentityTypeId);

alter table Customer
add constraint FK_Gender 
foreign key (GenderId)
references Gender(GenderId);

alter table Customer
add constraint FK_DefaultPhone 
foreign key (DefaultPhoneId)
references Phone(PhoneId);

alter table Customer
add constraint FK_Email 
foreign key (EmailId)
references Email(EmailId);

alter table Customer
add constraint FK_DefaultDeliveryAddress 
foreign key (DefaultDeliveryAddressId)
references DeliveryAddress(DeliveryAddressId);


-- CustomerSession

alter table CustomerSession
add constraint FK_CustomerSessionCustomer 
foreign key (CustomerId)
references Customer(CustomerId);


-- City

alter table City
add constraint FK_Country 
foreign key (CountryId)
references Country(CountryId);


-- District

alter table District
add constraint FK_City 
foreign key (CityId)
references City(CityId);


-- Address

alter table Address
add constraint FK_District 
foreign key (DistrictId)
references District(DistrictId);


-- DeliveryAddress

alter table DeliveryAddress
add constraint FK_DeliveryAddressCustomer  
foreign key (CustomerId)
references Customer(CustomerId);

alter table DeliveryAddress
add constraint FK_Address  
foreign key (AddressId)
references Address(AddressId);

alter table DeliveryAddress
add constraint FK_DeliveryAddressPhone  
foreign key (PhoneId)
references Phone(PhoneId);


-- Category

alter table Category
add constraint FK_ParentCategory  
foreign key (ParentCategoryId)
references Category(CategoryId);


-- Product

alter table Product
add constraint FK_Brand  
foreign key (BrandId)
references Brand(BrandId);


-- ProductImage

alter table ProductImage
add constraint FK_ProductImageProduct  
foreign key (ProductId)
references Product(ProductId);


-- ProductCategory

alter table ProductCategory
add constraint FK_Category  
foreign key (CategoryId)
references Category(CategoryId);

alter table ProductCategory
add constraint FK_ProductCategoryProduct  
foreign key (ProductId)
references Product(ProductId);


-- CustomerProductFavorite 

alter table CustomerProductFavorite 
add constraint FK_CustomerProductFavoriteCustomer  
foreign key (CustomerId)
references Customer(CustomerId);

alter table CustomerProductFavorite 
add constraint FK_CustomerProductFavoriteProduct  
foreign key (ProductId)
references Product(ProductId);


-- Basket

alter table Basket 
add constraint FK_BasketCustomer  
foreign key (CustomerId)
references Customer(CustomerId);


-- BasketProduct

alter table BasketProduct 
add constraint FK_BasketId  
foreign key (BasketId)
references Basket(BasketId);

alter table BasketProduct 
add constraint FK_BasketProductProduct  
foreign key (ProductId)
references Product(ProductId);



-- CustomerOrder

alter table CustomerOrder 
add constraint FK_CustomerOrderCustomer  
foreign key (CustomerId)
references Customer(CustomerId);

alter table CustomerOrder 
add constraint FK_OrderStatusType 
foreign key (OrderStatusTypeId)
references OrderStatusType(OrderStatusTypeId);

alter table CustomerOrder 
add constraint FK_CustomerOrderDeliveryAddress 
foreign key (DeliveryAddressId)
references DeliveryAddress(DeliveryAddressId);


-- CustomerOrderDetail

alter table CustomerOrderDetail 
add constraint FK_CustomerOrder  
foreign key (CustomerOrderId)
references CustomerOrder(CustomerOrderId);

alter table CustomerOrderDetail 
add constraint FK_CustomerOrderDetailProduct  
foreign key (ProductId)
references Product(ProductId);


commit;
