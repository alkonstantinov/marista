use marista
go


if OBJECT_ID('Level') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Level'
  drop table Level
end
go

create table Level 
(
  LevelId int not null,
  Name nvarchar(50) not null,
  constraint pk_LevelId primary key (LevelId)
)
go

exec p_ak_create_fk_indeces 'Level'
go

insert into Level values (1,'Administrator'), (2,'BrandPromoter')
go


if OBJECT_ID('SiteUser') is not null
begin
  exec p_ak_drop_all_foreign_keys 'SiteUser'
  drop table SiteUser
end
go

create table SiteUser 
(
  SiteUserId int not null identity(1,1),
  Username nvarchar(50) not null,
  Password nvarchar(32) not null,
  LevelId int not null,
  CurrentSessionId nvarchar(50) null,
  constraint pk_SiteUserId primary key (SiteUserId),
  constraint fk_SiteUser_LevelId foreign key (LevelId) references Level(LevelId)
)
go

exec p_ak_create_fk_indeces 'SiteUser'
go

create index ix_SessionId on SiteUser (CurrentSessionId asc)
go

insert into SiteUser(Username, Password, LevelId)
values ('admin', '202cb962ac59075b964b07152d234b70', 1), ('testOne', '202cb962ac59075b964b07152d234b70', 1)
go


if OBJECT_ID('HCategory') is not null
begin
  exec p_ak_drop_all_foreign_keys 'HCategory'
  drop table HCategory
end
go

create table HCategory 
(
  HCategoryId int not null identity(1,1),
  CategoryName nvarchar(200) not null
  constraint pk_HCategoryId primary key (HCategoryId)
)
go

exec p_ak_create_fk_indeces 'HCategory'
go

insert into HCategory(CategoryName)
values ('horizontal cat one'), ('horizontal cat two')
go


if OBJECT_ID('VCategory') is not null
begin
  exec p_ak_drop_all_foreign_keys 'VCategory'
  drop table VCategory
end
go

create table VCategory 
(
  VCategoryId int not null identity(1,1),
  CategoryName nvarchar(200) not null
  constraint pk_VCategoryId primary key (VCategoryId)
)
go

exec p_ak_create_fk_indeces 'VCategory'
go

insert into VCategory(CategoryName)
values ('vertical cat one'), ('vertical cat two')
go


if OBJECT_ID('Product') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Product'
  drop table Product
end
go

create table Product 
(
  ProductId int not null identity(1,1),
  Name nvarchar(100) not null, --ИМЕ
  Description nvarchar(max) not null, --ОПИСАНИЕ
  Price decimal (10,2) not null, --ЦЕНА
  PromotionalPrice decimal (10,2) null, --ПРОМОЦИОНАЛНА ЦЕНА
  VCategoryId int not null, --ВЕРТИКАЛНА КАТЕГОРИЯ - от таблица VCategory
  HCategoryId int not null, --ХОРИЗОНТАЛНА КАТЕГОРИЯ - от таблица HCategory
  Picture varbinary(max) not null, --СНИМКА
  Barcode nvarchar(20) not null default '',
  Available int not null default 0,
  MinQuantity int not null default 0,
  Weight decimal(10,2) not null default 0,
  constraint pk_ProductId primary key (ProductId),
  constraint fk_Product_VCategoryId foreign key (VCategoryId) references VCategory(VCategoryId),
  constraint fk_Product_HCategoryId foreign key (HCategoryId) references HCategory(HCategoryId)
)
go

exec p_ak_create_fk_indeces 'Product'
go


if OBJECT_ID('RelatedProduct') is not null
begin
  exec p_ak_drop_all_foreign_keys 'RelatedProduct'
  drop table RelatedProduct
end
go

create table RelatedProduct 
(
  FromProductId int not null,
  ToProductId int not null,
  constraint pk_RelatedProductId primary key (FromProductId, ToProductId),
  constraint fk_Product_FromProductId foreign key (FromProductId) references Product(ProductId),
  constraint fk_Product_ToProductId foreign key (ToProductId) references Product(ProductId)
)
go

exec p_ak_create_fk_indeces 'RelatedProduct'
go


if OBJECT_ID('BonusSize') is not null
begin
  exec p_ak_drop_all_foreign_keys 'BonusSize'
  drop table BonusSize
end
go

create table BonusSize 
(
  BonusSizeId int not null identity(1,1),
  FromBonus decimal (10,2) not null, -- От цена
  ToBonus decimal (10,2) not null, -- До цена
  BonusPercent decimal (10,2) not null, -- процент
  constraint pk_BonusSizeId primary key (BonusSizeId)
)
go

exec p_ak_create_fk_indeces 'BonusSize'


if OBJECT_ID('SOBonusSize') is not null
begin
  exec p_ak_drop_all_foreign_keys 'SOBonusSize'
  drop table SOBonusSize
end
go

create table SOBonusSize 
(
  SOBonusSizeId int not null identity(1,1),
  FromSO int not null, -- от брой спинофи
  ToSO int not null, -- до брой спинофи
  BonusPercent decimal (10,2) not null, --процент
  constraint pk_SOBonusSizeId primary key (SOBonusSizeId)
)
go

exec p_ak_create_fk_indeces 'SOBonusSize'
go


if OBJECT_ID('Constant') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Constant'
  drop table [Constant]
end
go

create table [Constant]
(
  ConstantId int not null,
  Name nvarchar(100) not null, --ИМЕ НА КОНСТАНТА
  Value decimal (10,2) not null, --СТОЙНОСТ
  constraint pk_ConstantId primary key (ConstantId)
)
go

exec p_ak_create_fk_indeces 'Constant'
go

delete from constant
insert into constant 
(ConstantId, Name, Value)
values
(1, 'Percent from Sales', 23),
(2, 'Minimum Active PBV', 100),
(3, 'Minimum Active Children', 4)
go

if OBJECT_ID('Chat') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Chat'
  drop table Chat
end
go

create table Chat 
(
  ChatId int not null identity(1,1), --идентификатор на чат
  SiteUserId int not null, -- собственик на чата
  constraint pk_ChatId primary key (ChatId),
  constraint fk_Chat_SiteUserId foreign key (SiteUserId) references SiteUser(SiteUserId)
)
go

exec p_ak_create_fk_indeces 'Chat'
go

if OBJECT_ID('ChatItem') is not null
begin
  exec p_ak_drop_all_foreign_keys 'ChatItem'
  drop table ChatItem
end
go


create table ChatItem 
(
  ChatItemId int not null identity(1,1), -- Идентификатор на реплика
  ChatId int not null, -- Идентификатор на чат 
  SiteUserId int not null, -- Кой е казал репликата
  OnDate datetime2 not null, -- в колко часа
  Said nvarchar(max), -- реплика
  FileName nvarchar(max), -- реплика
  Attachment varbinary(max), -- файл
  constraint pk_ChatItemId primary key (ChatItemId),  
  constraint fk_ChatItem_ChatId foreign key (ChatId) references Chat(ChatId),
  constraint fk_ChatItem_SiteUserId foreign key (SiteUserId) references SiteUser(SiteUserId)
)
go
exec p_ak_create_fk_indeces 'ChatItem'
go

if OBJECT_ID('Coupon') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Coupon'
  drop table Coupon
end
go

create table Coupon
(
  CouponId int not null identity(1,1),
  UniqueId nvarchar (10) not null, -- уникален код на купона
  SiteUserId int not null, --кой генерира купона
  Expires datetime2 not null, -- на коя дата изтича валидността на купона
  HCategoryId int null,  --ИЛИ всички продукти от тази категория са с намаление
  VCategoryId int null,  -- ИЛИ всички продукти от тази категория  са с намаление
  ProductId int null, --ИЛИ  само този продукт е с намаление
  ForAll bit not null default 0, -- ИЛИ абсолютно всички продукти са с намаление
  Discount int not null default 0, -- размер на намалението в проценти от 1 до 23
  Used bit not null default 0, -- Дали е използван купонът
  Img varbinary (max), -- Изображение на купона
  constraint pk_CouponId primary key (CouponId),  
  constraint fk_Coupon_SiteUserId foreign key (SiteUserId) references SiteUser(SiteUserId),
  constraint fk_Coupon_HCategoryId foreign key (HCategoryId) references HCategory(HCategoryId),
  constraint fk_Coupon_VCategoryId foreign key (VCategoryId) references VCategory(VCategoryId),
  constraint fk_Coupon_ProductId foreign key (ProductId) references Product(ProductId)
)
go

exec p_ak_create_fk_indeces 'Coupon'
go

insert into Coupon(UniqueId, SiteUserId, Expires, ForAll, Discount)
values ('1',1,'20190101',1,20)
go

if OBJECT_ID('Pyramid') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Pyramid'
  drop table Pyramid
end
go

create table Pyramid 
(
  PyramidId int not null identity(1,1),
  PyramidParentId int null,
  PyramidSpinoffParentId int null,
  SiteUserId int not null,
  SaleBonus decimal (10,2) not null default 0,
  PBV decimal (10,2) not null default 0,  
  Prcnt decimal(10,2) not null default 0,
  ParentPrcnt decimal(10,2) not null default 0,
  SoParentPrcnt decimal(10,2) not null default 0,
  SoPrcnt decimal(10,2) not null default 0,
  FromOthers decimal(10,2) not null default 0,
  ToReceive decimal(10,2) not null default 0,
  constraint pk_PyramidId primary key (PyramidId),
  constraint fk_Pyramid_PyramidParentId foreign key (PyramidParentId) references Pyramid(PyramidId),
  constraint fk_Pyramid_PyramidSpinoffParentId foreign key (PyramidSpinoffParentId) references Pyramid(PyramidId),
  constraint fk_Pyramid_SiteUserId foreign key (SiteUserId) references SiteUser(SiteUserId)

)
go


   
exec p_ak_create_fk_indeces 'Pyramid'
go

if OBJECT_ID('MarketingMaterial') is not null
begin
  exec p_ak_drop_all_foreign_keys 'MarketingMaterial'
  drop table MarketingMaterial
end
go

create table MarketingMaterial 
(
  MarketingMaterialId int not null identity(1,1),
  Title nvarchar(200) not null,
  FileName nvarchar(500) not null,
  Content varbinary(max) not null,
  constraint pk_MarketingMaterialId primary key (MarketingMaterialId)
)
go

exec p_ak_create_fk_indeces 'MarketingMaterial'
go

if OBJECT_ID('CountryType') is not null
begin
  exec p_ak_drop_all_foreign_keys 'CountryType'
  drop table CountryType
end
go
create table CountryType
(
  CountryTypeId int not null,
  CountryTypeName nvarchar(200) not null,
  constraint pk_CountryTypeId primary key (CountryTypeId)
)
go

exec p_ak_create_fk_indeces 'CountryType'
go
insert into CountryType(CountryTypeId, CountryTypeName)
values (1,'България'), (2,'Съседни държави'),(3,'Европейски държави'), (4,'Извъневропейски държави')
go
if OBJECT_ID('Country') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Country'
  drop table Country
end
go
create table Country
(
  CountryId nvarchar(2) not null,
  CountryName nvarchar(200) not null,
  CountryTypeId int not null
  constraint pk_CountryId primary key (CountryId),
  constraint fk_country_CountryTypeId foreign key (CountryTypeId) references CountryType(CountryTypeId)
)
go

exec p_ak_create_fk_indeces 'Country'
go
  
insert into Country(CountryId, CountryName, CountryTypeId) values ('bg', 'Bulgaria', 1)
go

if OBJECT_ID('BP') is not null
begin
  exec p_ak_drop_all_foreign_keys 'BP'
  drop table BP
end
go

create table BP
(
  BPId int not null identity(1,1),
  BPName nvarchar(200) not null,
  EMail nvarchar(200) not null,
  PayPal nvarchar(200) not null,
  Address nvarchar(max) not null,
  CountryId nvarchar(2) not null,
  SiteUserId int not null,
  Files varbinary(max) not null,
  FileName nvarchar(200) not null,
  Active bit not null default 0,
  constraint pk_BPId primary key (BPId),
  constraint fk_BP_CountryId foreign key (CountryId) references Country(CountryId),
  constraint fk_BP_SiteUserId foreign key (SiteUserId) references SiteUser(SiteUserId)
)
go

exec p_ak_create_fk_indeces 'BP'
go

if OBJECT_ID('Customer') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Customer'
  drop table Customer
end
go

create table Customer 
(
  CustomerId int not null identity(1,1),
  Username nvarchar(50) not null,
  Password nvarchar(32) not null,
  CustomerName nvarchar(200) not null,
  Address nvarchar(max) not null,
  City nvarchar(max) not null,
  CountryId nvarchar(2) not null,
  BPId int null,
  constraint pk_CustomerId primary key (CustomerId),
  constraint fk_Customer_CountryId foreign key (CountryId) references Country(CountryId),
  constraint fk_Customer_BPId foreign key (BPId) references BP(BPId)
)
go

exec p_ak_create_fk_indeces 'Customer'
go

if OBJECT_ID('SaleStatus') is not null
begin
  exec p_ak_drop_all_foreign_keys 'SaleStatus'
  drop table SaleStatus
end
go

create table SaleStatus
(
  SaleStatusId int not null,
  Name nvarchar(50) not null,
  constraint pk_SaleStatusId primary key (SaleStatusId)
)
go

exec p_ak_create_fk_indeces 'SaleStatus'
go

insert into SaleStatus values (1,'Waiting for dispatch'), (2,'Dispatched')
go


if OBJECT_ID('Sale') is not null
begin
  exec p_ak_drop_all_foreign_keys 'Sale'
  drop table Sale
end
go

create table Sale
(
  SaleId int not null identity(1,1),
  SaleStatusId int not null default 1,
  CustomerId int not null,
  OnDate datetime not null default getdate(),
  CouponId int null,
  DeliveryPrice decimal(10,2) not null default 0,
  CustomerName nvarchar(200) not null,
  CustomerEmail nvarchar(200) not null,
  CustomerPhone nvarchar(200) not null,
  BillingCountryId nvarchar(2) not null,
  BillingAddress nvarchar(max) not null,
  BillingCity nvarchar(200) not null,
  BillingZip nvarchar(20) not null,
  DeliveryCountryId nvarchar(2) not null,
  DeliveryAddress nvarchar(max) not null,
  DeliveryCity nvarchar(200) not null,
  DeliveryZip nvarchar(20) not null,
  Note nvarchar(max),
  constraint pk_SaleId primary key (SaleId),
  constraint fk_Sale_CustomerId foreign key (CustomerId) references Customer(CustomerId),
  constraint fk_Sale_CouponId foreign key (CouponId) references Coupon(CouponId),
  constraint fk_Sale_BillingCountryId foreign key (BillingCountryId) references Country(CountryId),
  constraint fk_Sale_DeliveryCountryId foreign key (DeliveryCountryId) references Country(CountryId),
  constraint fk_Sale_SaleStatusId foreign key (SaleStatusId) references SaleStatus(SaleStatusId)
)
go

exec p_ak_create_fk_indeces 'Sale'
go



if OBJECT_ID('SaleDetail') is not null
begin
  exec p_ak_drop_all_foreign_keys 'SaleDetail'
  drop table SaleDetail
end
go

create table SaleDetail
(
  SaleDetailId int not null identity(1,1),
  SaleId int not null,
  ProductId int not null,
  Price decimal(10,2) not null,
  Quantity int not null,
  Discount decimal(10,2) not null default 0,
  constraint pk_SaleDetailId primary key (SaleDetailId),
  constraint fk_SaleDetail_SaleId foreign key (SaleId) references Sale(SaleId),
  constraint fk_SaleDetail_ProductId foreign key (ProductId) references Product(ProductId)
)
go

exec p_ak_create_fk_indeces 'SaleDetail'
go


if OBJECT_ID('ResultHistory') is not null
begin
  exec p_ak_drop_all_foreign_keys 'ResultHistory'
  drop table ResultHistory
end
go

create table ResultHistory
(
  ResultHistoryId int not null identity(1,1),
  BpId int not null,
  Month int not null,
  Year int not null,
  Sales decimal(10,2),
  PBV decimal(10,2),
  NBV decimal(10,2),
  Bonus decimal(10,2),
  constraint pk_ResultHistoryId primary key (ResultHistoryId),
  constraint fk_ResultHistory_BPId foreign key (BPId) references BP(BPId)
)
go

exec p_ak_create_fk_indeces 'ResultHistory'
go


if OBJECT_ID('CountryDelivery') is not null
begin
  exec p_ak_drop_all_foreign_keys 'CountryDelivery'
  drop table CountryDelivery
end
go
create table CountryDelivery
(
  CountryDeliveryId int identity(1,1) not null,
  CountryTypeId int not null,
  FromWeight decimal(10,2),
  ToWeight decimal (10,2),
  Price decimal(10,2),
  constraint pk_CountryDeliveryId primary key (CountryDeliveryId),
  constraint fk_CountryDelivery_CountryTypeId foreign key (CountryTypeId) references CountryType(CountryTypeId)
)
go
exec p_ak_create_fk_indeces 'CountryDelivery'
go

insert into CountryDelivery(CountryTypeId,FromWeight, ToWeight,Price)
values (1,0,10000,2), (3,0,10000,7)
go


if OBJECT_ID('ProductPicture') is not null
begin
  exec p_ak_drop_all_foreign_keys 'ProductPicture'
  drop table ProductPicture
end
go
create table ProductPicture
(
  ProductPictureId int identity(1,1) not null,
  ProductId int not null,
  Picture varbinary(max) not null,
  constraint pk_ProductPictureId primary key (ProductPictureId),
  constraint fk_ProductPicture_ProductId foreign key (ProductId) references Product(ProductId)
)
go
exec p_ak_create_fk_indeces 'ProductPicture'
go