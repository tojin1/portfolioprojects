/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[salesdateconverted]
      
      FROM [portfolio projects].[dbo].[nashvillehousing]
  
  select saledate, convert(date,saledate)
  FROM [portfolio projects].[dbo].[nashvillehousing]

  alter table  [portfolio projects].[dbo].[nashvillehousing]
  add salesdateconverted = convert (date,saledate) ;

  update [portfolio projects].[dbo].[nashvillehousing]
  set salesdateconverted = convert(date,saledate)

  

  -- populate property  address data
  select PropertyAddress,ParcelID
  FROM [portfolio projects].[dbo].[nashvillehousing]
  where PropertyAddress is null
  order by ParcelID

    select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL (a.PropertyAddress,b.propertyaddress)
   FROM [portfolio projects].[dbo].[nashvillehousing] a
   join [portfolio projects].[dbo].[nashvillehousing]b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is  null

  update a 
  set PropertyAddress = ISNULL (a.PropertyAddress,b.propertyaddress)
   FROM [portfolio projects].[dbo].[nashvillehousing] a
   join [portfolio projects].[dbo].[nashvillehousing]b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  --breaking out address into individual columns ( address,state,city)

  select  substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
  substring(propertyaddress,charindex(',',propertyaddress)+1, len (PropertyAddress)) as address
 FROM [portfolio projects].[dbo].[nashvillehousing]

  alter table  [portfolio projects].[dbo].[nashvillehousing]
  add propertsplitaddress nvarchar(255) ;
  

  update [portfolio projects].[dbo].[nashvillehousing]
  set propertsplitaddress = substring(propertyaddress,1,charindex(',',propertyaddress)-1) 

   alter table  [portfolio projects].[dbo].[nashvillehousing]
  add propertysplitcity nvarchar(255) ;
 

  update [portfolio projects].[dbo].[nashvillehousing]
  set propertysplitcity =    substring(propertyaddress,charindex(',',propertyaddress)+1, len (PropertyAddress))

  select * 
   FROM [portfolio projects].[dbo].[nashvillehousing]

   select  PARSENAME(replace(owneraddress,',','.'),3),
   PARSENAME(replace(owneraddress,',','.'),2),
   PARSENAME(replace(owneraddress,',','.'),1)
   FROM [portfolio projects].[dbo].[nashvillehousing]
   


     alter table  [portfolio projects].[dbo].[nashvillehousing]
  add ownersplitaddress nvarchar(255)
  

  update [portfolio projects].[dbo].[nashvillehousing]
  set ownersplitaddress = PARSENAME(replace(owneraddress,',','.'),3)

   alter table  [portfolio projects].[dbo].[nashvillehousing]
  add ownersplitcity nvarchar(255) ;
 

  update [portfolio projects].[dbo].[nashvillehousing]
  set ownersplitcity =       PARSENAME(replace(owneraddress,',','.'),2)


   alter table  [portfolio projects].[dbo].[nashvillehousing]
  add ownersplitstates nvarchar(255) ;
  

  update [portfolio projects].[dbo].[nashvillehousing]
  set ownersplitstates = PARSENAME(replace(owneraddress,',','.'),1)

  
   

   -- change y and n to yes and no field


   select   distinct(SoldAsVacant), COUNT(SoldAsVacant)
   FROM [portfolio projects].[dbo].[nashvillehousing]
   group by SoldAsVacant
   order by 2




   select  SoldAsVacant ,
   case when soldasvacant = 'y' then 'yes'
    when soldasvacant = 'n' then 'no'
	else soldasvacant
	end
   FROM [portfolio projects].[dbo].[nashvillehousing]
  
   update [portfolio projects].[dbo].[nashvillehousing]
   set SoldAsVacant =case when soldasvacant = 'y' then 'yes'
    when soldasvacant = 'n' then 'no'
	else soldasvacant
	end

	--remove duplicates
with rownumcte as(
	select *,
ROW_NUMBER() OVER(
	partition by ParcelId,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference 
	order by
	UniqueId)  as rownumber
	
	   FROM [portfolio projects].[dbo].[nashvillehousing]
	  -- order by ParcelID
	  )
	  delete
	   from rownumcte
	   where rownumber>1
	 ---  order by PropertyAddress


	 -- delete unused column

	 select *
	    FROM [portfolio projects].[dbo].[nashvillehousing]

	    alter table [portfolio projects].[dbo].[nashvillehousing]
        drop column owneraddress,taxdistrict,propertyaddress,salesdate2,salesdate3,salesdate4
		
	    alter table [portfolio projects].[dbo].[nashvillehousing]
        drop column salesdate2,salesdate3,salesdate4

		 