/****** Script for SelectTopNRows command from SSMS  ******/
SELECT SaleDate
  FROM Housing_Data

  --changing date format
  
  --SELECT SaleDate,convert(Date,SaleDate) as Saleedate
  --FROM Housing_Data;
  Alter table Housing_Data add saledateconverted date;
  update Housing_Data set 
  saledateconverted = CONVERT(Date,SaleDate)

  Select saledateconverted from Housing_Data

  --Populate Property Address Data

  select * from Housing_Data where PropertyAddress is null
  order by ParcelID

  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
  from Housing_Data a
  join Housing_Data b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

  update a
  set propertyaddress = isnull(a.propertyaddress,b.PropertyAddress)
    from Housing_Data a
  join Housing_Data b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

  --Breaking Address into individual Columns.

  select propertyaddress from Housing_Data

  --The SUBSTRING() function extracts some characters from a string
  -- SYNTAX   SUBSTRING(string, start, length)
  -- Parameter	Description
--string	Required. The string to extract from
--start	Required. The start position. The first position in string is 1
--length	Required. The number of characters to extract. Must be a positive number

  select SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as Address from  housing_data

  --The CHARINDEX() function searches for a substring in a string, and returns the position.
  --If the substring is not found, this function returns 0.
  --SYNTAX  CHARINDEX(substring, string, start)
--  substring	Required. The substring to search for
--string	Required. The string to be searched
--start	Optional. The position where the search will start 

  select substring(propertyaddress,charindex(',',propertyaddress)+1, LEN(PropertyAddress)) as CityAddress from housing_data;

  -- Now we have to alter table to insert two columns in the table.
  alter table housing_data add Address Nvarchar(255);
  update housing_data set Address = SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) 
  alter table housing_data add CityAddress Nvarchar(255);
  update Housing_Data set CityAddress= substring(propertyaddress,charindex(',',propertyaddress)+1, LEN(PropertyAddress))

  select * from Housing_Data;

 ---Spliting the ownerer address
 select owneraddress from Housing_Data;

 --The PARSENAME function does not indicate whether an object by the specified name exists.
 -- PARSENAME just returns the specified part of the specified object name

 -- PARSENAME ('object_name' , object_piece )
 --parsename works backward 3,2,1 e.g,

 --The REPLACE() function replaces all occurrences of a substring within a string, with a new substring
 --REPLACE(string, old_string, new_string)
 select PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) from housing_data

  alter table housing_data add OwnerSplitAddress Nvarchar(255);

  update Housing_Data set OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);
  alter table housing_data add OwnerMiddleAddress Nvarchar(255);
  update Housing_Data set OwnerCityAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);
  alter table housing_data add OwnerLastAddress Nvarchar(255);
  update Housing_Data set OwnerStateAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);


  select * from Housing_Data;

  
-- Change Y and N to Yes and No in "Sold as Vacant" field

--checking the overall different results.
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing_Data
Group by SoldAsVacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
End
from Housing_Data;

update Housing_Data
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
End

select * from Housing_Data

-- Remove Duplicates

with removeCTE as(
select *,
 ROW_NUMBER() over (
 partition by parcelid,PropertyAddress,SalePrice,SaleDate,LegalReference
 ORDER BY UniqueID
 ) 
 row_num from Housing_Data
 )
select *
From removeCTE
Where row_num > 1
--Order by PropertyAddress

select * from Housing_Data;


--- Removing Unused Columns.


select * from Housing_Data
alter table housing_data
drop column ownername;

-- spliting owner name

select PARSENAME(replace(ownername,',','.'),2),
PARSENAME(replace(ownername,',','.'),1)
from Housing_Data

alter table housing_data
add firstname nvarchar(255),lastname nvarchar(255)
update Housing_Data set
firstname = PARSENAME(replace(ownername,',','.'),2),
lastname = PARSENAME(replace(ownername,',','.'),1);

