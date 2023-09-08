/*Cleaning Data in SQL Queries*/
use Nashville_Dataset
Select * from NashvilleHousing
---------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From NashvilleHousing

update NashvilleHousing
SET SaleDate=CONVERT(Date,SaleDate)

ALTER Table NashvilleHousing
ADD SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)


-----------------------------------------------------------------------------------

--Populate Property Address data

Select *
From NashvilleHousing
where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a 
JOIN NashvilleHousing b
 ON a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a 
JOIN NashvilleHousing b
 ON a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual columns(Address, City, State)

Select propertyAddress from NashvilleHousing

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress )-1)AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress )+1,LEN(PropertyAddress))AS Address
From NashvilleHousing

ALTER Table NashvilleHousing
ADD PropertyAddressSplit NVARCHAR(255);

update NashvilleHousing
SET PropertyAddressSplit= SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress )-1)


ALTER Table NashvilleHousing
ADD PropertyCitySplit NVARCHAR(255);

update NashvilleHousing
SET PropertyCitySplit=SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress )+1,LEN(PropertyAddress)) 

select propertyAddress,  PropertyAddressSplit, PropertyCitySplit from NashvilleHousing



Select * from NashvilleHousing

Select OwnerAddress from NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
	,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
	,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing

ALTER Table NashvilleHousing
ADD CityOwnerSplit NVARCHAR(255);

update NashvilleHousing
SET CityOwnerSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER Table NashvilleHousing
ADD AddressOwnerSplit NVARCHAR(255);

update NashvilleHousing
SET AddressOwnerSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER Table NashvilleHousing
ADD StateOwnerSplit NVARCHAR(255);

update NashvilleHousing
SET StateOwnerSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select OwnerAddress, AddressOwnerSplit, CityOwnerSplit,  StateOwnerSplit 
from NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "solid as Vacant" field

Select * from NashvilleHousing

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
	from NashvilleHousing
	group by SoldAsVacant
	order by 2

select SoldAsVacant,
	CASE WHEN SoldAsVacant='Y' THEN 'Yes'
		 WHEN SoldAsVacant='N' THEN 'No'
		 ELSE SoldAsVacant
	END
from NashvilleHousing

update NashvilleHousing
SET SoldAsVacant=
	CASE WHEN SoldAsVacant='Y' THEN 'Yes'
		 WHEN SoldAsVacant='N' THEN 'No'
		 ELSE SoldAsVacant
	END
from NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicates



WITH RowNumCTE As (
select *, ROW_NUMBER() OVER(
			PARTITION BY ParcelID, 
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY 
						UniqueID
						) Rownum
from NashvilleHousing)
select *
from RowNumCTE
where Rownum >1

---------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,SaleDate, TaxDistrict, PropertyAddress
															
Select * from NashvilleHousing


