USE [Nashville Housing Portfolio Project]

--Cleaning Data in SQL Queries

SELECT * 
FROM NashvilleHousing

--Standardize Date Format

SELECT SaleDateConverted, CONVERT(date, saledate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, Saledate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



--Populate Propert Address Data

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.parcelid, a.propertyaddress, b.parcelid, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.parcelid = b.parcelid
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a 
SET propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.parcelid = b.parcelid
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



--Breaking Out Address Into Indicidual Columns (Address, City, State)



SELECT Propertyaddress
FROM NashvilleHousing

SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', Propertyaddress)-1) as address
FROM nashvillehousing

SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', Propertyaddress)-1) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', Propertyaddress)+1, LEN(propertyaddress)) as City
FROM nashvillehousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', Propertyaddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', Propertyaddress)+1, LEN(propertyaddress))

SELECT * FROM NashvilleHousing




SELECT owneraddress
FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM NashvilleHousing





ALTER TABLE NashvilleHousing
ADD OwnderSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnderSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

SELECT * FROM NashvilleHousing





--Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant


SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = 	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM NashvilleHousing





--Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) AS row_num
FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num >1


WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) AS row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num >1




--Delete Unused Columns

SELECT * 
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
